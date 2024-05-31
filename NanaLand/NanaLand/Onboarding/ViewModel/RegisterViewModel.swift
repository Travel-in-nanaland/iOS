//
//  RegisterViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/13/24.
//

import Foundation

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
		var nicknameErrorMessage: LocalizedKey?
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
		state.nicknameErrorMessage = nil

		guard nicknameIsValid() else {
			// 형식에 맞지 않은 닉네임
			state.nicknameErrorMessage = .invalidNickname
			state.showNicknameError = true
			return
		}
		
		guard state.nickname.isValidNickname() else {
			// 형식에 맞지 않은 닉네임
			state.nicknameErrorMessage = .onlyCharSpaceNumberNickname
			state.showNicknameError = true
			return
		}
		
		let result = await AuthService.registerServer(body: state.registerRequest, image: [state.pickedImage])
		
		if let tokens = result?.data {
			KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
			KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
			
			UserDefaults.standard.setValue(true, forKey: "isLogin")
			UserDefaults.standard.setValue(state.registerRequest.provider, forKey: "provider")
			AppState.shared.isRegisterNeeded = false
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				AppState.shared.showTypeTest = true
			}
		} else if result?.status == 409 {
			// 닉네임 중복
			state.nicknameErrorMessage = .duplicatedNickname
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
}
