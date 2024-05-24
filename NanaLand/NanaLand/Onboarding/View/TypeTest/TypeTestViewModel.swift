//
//  TypeTestViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/24/24.
//

import Foundation
import SwiftUI

// 여행에서 가장 하고 싶은 것은? 타입
enum TripActivity {
	case sentimental // 감성 장소
	case traditional  // 전통 문화
	case natural  // 자연 경관
	case themepark  // 테마파크
}

@MainActor
final class TypeTestViewModel: ObservableObject {
	struct State {
		var navigationPath: [TypeTestViewType] = []
		
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
		case onTapNextButtonInTest(page: Int, index: Int)
		case onTapSkipButton
		case onTapGotoMainViewButton
	}
	
	@Published var state: State
	
	init(state: State = .init()) {
		self.state = state
	}
	
	func action(_ action: Action) {
		switch action {
		case let .onTapNextButtonInTest(page, index):
			nextButtonTapped(page: page, index: index)
		case .onTapSkipButton:
			skipButtonTapped()
		case .onTapGotoMainViewButton:
			gotoMainViewButtonTapped()
		}
	}
		
	func nextButtonTapped(page: Int, index: Int) {
		switch page {
		case 1:
			state.isTouristSpot = (index == 0 ? true : false)
			state.navigationPath.append(.userTypeTest2)
		case 2:
			state.navigationPath.append(.userTypeTest3)
		case 3:
			state.isCostEffective = (index == 0 ? true : false)
			state.navigationPath.append(.userTypeTest4)
		case 4:
			state.navigationPath.append(.userTypeTest5)
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
			
			state.navigationPath.append(.userTypeTestResult)
		default:
			print("unknown page")
		}
	}
	
	func skipButtonTapped() {
		AppState.shared.showTypeTest = false
	}
	
	func gotoMainViewButtonTapped() {
		AppState.shared.showTypeTest = false
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
	
}
