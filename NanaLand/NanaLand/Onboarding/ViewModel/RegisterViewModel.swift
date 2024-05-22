//
//  RegisterViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/13/24.
//

import Foundation

enum RegisterViewType {
	case termsAgreement  // 약관 동의
	case nicknameAndProfile  // 닉네임과 프로필사진
	case userTypeTest1
	case userTypeTest2
	case userTypeTest3
	case userTypeTest4
	case userTypeTest5
	case userTypeTestResult
}

// 여행에서 가장 하고 싶은 것은? 타입
enum TripActivity {
	case sentimental // 감성 장소
	case traditional  // 전통 문화
	case natural  // 자연 경관
	case themepark  // 테마파크
}

@MainActor
final class RegisterViewModel: ObservableObject {
	struct State {
		var registerPath: [RegisterViewType] = []
		var registerRequest: RegisterRequest = RegisterRequest()
		var isRegisterNeeded: Bool = false
		
		// 약관
		var privacyAgreement: Bool = false
		var marketingAgreement: Bool = false
		var locationAgreement: Bool = false
		
		// 닉네임&사진
		var pickedImage: Foundation.Data?
		var nickname: String = ""
		var showNicknameError: Bool = false
		var nicknameErrorMessage: String = ""
		
		// 유형테스트
		// true면 활발한 관광 장소
		// false면 한적한 로컬 장소
		var isTouristSpot: Bool? = nil
		
		// true면 럭셔리 여행
		// false면 가성비 여행
		var isCostEffective: Bool? = nil
		
		// 여행에서 가장 하고 싶은 것은? 데이터
		var tripActivity: TripActivity? = nil
		
		// 결과 타입
		var userType: TripType? = nil
	}
	
	enum Action {
		// 약관
		case onTapAllAgreement
		case onTapPrivacyAgreement
		case onTapMarketingAgreement
		case onTapLocationAgreement
		case onTapOkButtonInAgreement
		
		// 닉네임&사진
		case onTapOkButtonInNicknameAndProfile
		
		// 유형테스트
		case onTapNextButtonInTest(page: Int, index: Int)
		case onTapGotoMainViewButton
	}
	
	@Published var state: State
	
	init(state: State = .init()) {
		self.state = state
	}
	
	func action(_ action: Action) async {
		switch action {
		case .onTapAllAgreement:
			allAgreementTapped()
		case .onTapPrivacyAgreement:
			privacyAgreementTapped()
		case .onTapMarketingAgreement:
			marketingAgreementTapped()
		case .onTapLocationAgreement:
			locationAgreementTapped()
		case .onTapOkButtonInAgreement:
			agreementOkButtonTapped()
		case .onTapOkButtonInNicknameAndProfile:
			await nicknameAndProfileOkButtonTapped()
		case let .onTapNextButtonInTest(page, index):
			nextButtonTapped(page: page, index: index)
		case .onTapGotoMainViewButton:
			gotoMainViewButtonTapped()
		}
	}
	
	func allAgreementTapped() {
		if isAllAgree() {
			state.privacyAgreement = false
			state.marketingAgreement = false
			state.locationAgreement = false
		} else {
			state.privacyAgreement = true
			state.marketingAgreement = true
			state.locationAgreement = true
		}
	}
	
	func privacyAgreementTapped() {
		state.privacyAgreement.toggle()
	}
	
	func marketingAgreementTapped() {
		state.marketingAgreement.toggle()
	}
	
	func locationAgreementTapped() {
		state.locationAgreement.toggle()
	}
	
	func agreementOkButtonTapped() {
		state.registerRequest.consentItems = [
			ConsentItem(
				consentType: "TERMS_OF_USE",
				consent: state.privacyAgreement
			),
			ConsentItem(
				consentType: "MARKETING",
				consent: state.marketingAgreement
			),
			ConsentItem(
				consentType: "LOCATION_SERVICE",
				consent: state.locationAgreement
			)
		]
		
		state.registerPath.append(.nicknameAndProfile)
	}
	
	func nicknameAndProfileOkButtonTapped() async {
		state.registerRequest.nickname = state.nickname
		state.showNicknameError = false
		state.nicknameErrorMessage = ""
		
		guard nicknameIsValid() else {
			// 형식에 맞지 않은 닉네임
			state.nicknameErrorMessage = "해당 닉네임은 사용할 수 없습니다."
			state.showNicknameError = true
			return
		}
		
		let result = await AuthService.registerServer(body: state.registerRequest, image: [state.pickedImage])
		
		if let tokens = result?.data {
			KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
			KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
			UserDefaults.standard.setValue(true, forKey: "isLogin")
			state.registerPath.append(.userTypeTest1)
		} else if result?.status == 409 {
			// 닉네임 중복
			state.nicknameErrorMessage = "해당 닉네임은 다른 사용자가 사용 중입니다."
			state.showNicknameError = true
		} else {
			// TODO: 에러 처리 필요
			print("회원가입 - 알 수 없는 에러")
		}
	}
	
	func isAllAgree() -> Bool {
		return state.privacyAgreement && state.marketingAgreement && state.locationAgreement
	}
	
	func nicknameIsValid() -> Bool {
		return state.nickname.count > 0 && state.nickname.count < 9
	}
	
	func getTripType() -> TripType {
		if let isTouristSpot = state.isTouristSpot,
		   let isCostEffective = state.isCostEffective,
		   let tripActivity = state.tripActivity {
			
			if isTouristSpot && isCostEffective {
				// 관광장소 && 가성비
				switch tripActivity {
				case .sentimental:
					return .GAMGYUL_ICECREAM
				case .traditional:
					return .GAMGYUL_RICECAKE
				case .natural:
					return .GAMGYUL
				case .themepark:
					return .GAMGYUL_CIDER
				}
			} else if isTouristSpot && !isCostEffective {
				// 관광장소 && 럭셔리
				switch tripActivity {
				case .sentimental:
					return .GAMGYUL_AFFOKATO
				case .traditional:
					return .GAMGYUL_HANGWA
				case .natural:
					return .GAMGYUL_JUICE
				case .themepark:
					return .GAMGYUL_CHOCOLATE
				}
			} else if !isTouristSpot && !isCostEffective {
				// 로컬장소 && 럭셔리
				switch tripActivity {
				case .sentimental:
					return .GAMGYUL_COCKTAIL
				case .traditional:
					return .TANGERINE_PEEL_TEA
				case .natural:
					return .GAMGYUL_YOGURT
				case .themepark:
					return .GAMGYUL_FLATCCINO
				}
			} else {
				// 로컬장소 && 가성비
				switch tripActivity {
				case .sentimental:
					return .GAMGYUL_LATTE
				case .traditional:
					return .GAMGYUL_SIKHYE
				case .natural:
					return .GAMGYUL_ADE
				case .themepark:
					return .GAMGYUL_BUBBLE_TEA
				}
			}
		}
		
		print("타입 검사 오류")
		return .GAMGYUL
	}
	
	func nextButtonTapped(page: Int, index: Int) {
		switch page {
		case 1:
			state.isTouristSpot = (index == 0 ? true : false)
			state.registerPath.append(.userTypeTest2)
		case 2:
			state.registerPath.append(.userTypeTest3)
		case 3:
			state.isCostEffective = (index == 0 ? true : false)
			state.registerPath.append(.userTypeTest4)
		case 4:
			state.registerPath.append(.userTypeTest5)
		case 5:
			switch index {
			case 1:
				state.tripActivity = .sentimental
			case 2:
				state.tripActivity = .traditional
			case 3:
				state.tripActivity = .natural
			case 4:
				state.tripActivity = .themepark
			default:
				print("unknown type")
			}
			
			let type = getTripType()
			state.userType = type
			
			Task {
				await AuthService.patchUserType(body: PatchUserTypeRequest(type: type.rawValue))
			}
			
			state.registerPath.append(.userTypeTestResult)
		default:
			print("unknown page")
		}
	}
	
	func gotoMainViewButtonTapped() {
		state.isRegisterNeeded = false
	}
}
