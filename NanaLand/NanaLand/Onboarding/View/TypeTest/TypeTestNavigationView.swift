//
//  TypeTestNavigationView.swift
//  NanaLand
//
//  Created by 정현우 on 5/24/24.
//

import SwiftUI

enum TypeTestViewType {
	case userTypeTest2
	case userTypeTest3
	case userTypeTest4
	case userTypeTest5
	case userTypeTestResult
	
}

struct TypeTestNavigationView: View {
	let nickname: String
	@StateObject var typeTestVM = TypeTestViewModel()
	
    var body: some View {
		NavigationStack(path: $typeTestVM.state.navigationPath) {
			TypeTestView(
				nickname: nickname,
				page: 1,
				titleFirstLine: .typeTest1Q1L,
				titleSecondLine: .typeTest1Q2L,
				firstItem: (image: .tourSpot, title: .touristSpot),
				secondItem: (image: .localSpot, title: .localSpot)
			)
			.navigationDestination(for: TypeTestViewType.self) { viewType in
				switch viewType {
				case .userTypeTest2:
					TypeTestView(
						nickname: nickname,
						page: 2,
						titleFirstLine: .typeTest2Q1L,
						titleSecondLine: .typeTest2Q2L,
						firstItem: (image: .fluid, title: .flexible),
						secondItem: (image: .planned, title: .organized)
					)
				case .userTypeTest3:
					TypeTestView(
						nickname: nickname,
						page: 3,
						titleFirstLine: .typeTest3Q1L,
						titleSecondLine: .typeTest3Q2L,
						firstItem: (image: .costEffective, title: .budgetTravel),
						secondItem: (image: .luxury, title: .luxuryTravel)
					)
				case .userTypeTest4:
					TypeTestView(
						nickname: nickname,
						page: 4,
						titleFirstLine: .typeTest4Q1L,
						titleSecondLine: .typeTest4Q2L,
						firstItem: (image: .takePicture, title: .photoRemain),
						secondItem: (image: .seeWithEyes, title: .captureWithEyes)
					)
				case .userTypeTest5:
					TypeTestView(
						nickname: nickname,
						page: 5,
						titleFirstLine: .typeTest5Q1L,
						titleSecondLine: .typeTest5Q2L,
						isTwoLine: true,
						firstItem: (image: .emotionalSpot, title: .sentimentalPlace),
						secondItem: (image: .traditionalCulture, title: .traditionalCulture),
						thirdItem: (image: .naturalScene, title: .naturalScenery),
						fourthItem: (image: .themepark, title: .themePark)
					)
				case .userTypeTestResult:
					TypeTestResultView(nickname: nickname)
				}
				
			}
		}
		.environmentObject(typeTestVM)
    }
}

#Preview {
	@StateObject var lm = LocalizationManager()
	lm.setLanguage(.malaysia)
    return TypeTestNavigationView(nickname: "현우")
		.environmentObject(lm)
	
}
