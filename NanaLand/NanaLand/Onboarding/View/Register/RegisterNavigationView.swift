//
//  RegisterNavigationView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI

struct RegisterNavigationView: View {
	@ObservedObject var registerVM: RegisterViewModel
	
    var body: some View {
		NavigationStack(path: $registerVM.state.registerPath) {
			RegisterTermsAgreementView()
				.navigationDestination(for: RegisterViewType.self) { registerViewtype in
					switch registerViewtype {
					case .termsAgreement:
						RegisterTermsAgreementView()
					case .nicknameAndProfile:
						RegisterNicknameAndProfileView()
					case .userTypeTest1:
						TypeTestView(
							page: 1,
							titleFirstLine: "여행 장소를",
							titleSecondLine: "고를 때 \(registerVM.state.nickname) 님은?",
							firstItem: (image: .tourSpot, title: "활발한 관광 장소"),
							secondItem: (image: .localSpot, title: "한적한 로컬 장소")
						)
					case .userTypeTest2:
						TypeTestView(
							page: 2,
							titleFirstLine: "여행 계획을",
							titleSecondLine: "세울 때 \(registerVM.state.nickname) 님은?",
							firstItem: (image: .fluid, title: "유동적"),
							secondItem: (image: .planned, title: "완전 계획적")
						)
					case .userTypeTest3:
						TypeTestView(
							page: 3,
							titleFirstLine: "여행 경비를",
							titleSecondLine: "정할 때 \(registerVM.state.nickname) 님은?",
							firstItem: (image: .costEffective, title: "가성비 여행"),
							secondItem: (image: .luxury, title: "럭셔리 여행")
						)
					case .userTypeTest4:
						TypeTestView(
							page: 4,
							titleFirstLine: "여행 다닐 때",
							titleSecondLine: "\(registerVM.state.nickname) 님은?",
							firstItem: (image: .takePicture, title: "남는건 사진뿐!"),
							secondItem: (image: .seeWithEyes, title: "눈으로 담아야지")
						)
					case .userTypeTest5:
						TypeTestView(
							page: 5,
							titleFirstLine: "여행에서 가장",
							titleSecondLine: "하고 싶은 것은?",
							isTwoLine: true,
							firstItem: (image: .emotionalSpot, title: "감성 장소"),
							secondItem: (image: .traditionalCulture, title: "전통 문화"),
							thirdItem: (image: .naturalScene, title: "자연 경관"),
							fourthItem: (image: .themepark, title: "테마파크")
						)
					case .userTypeTestResult:
						TypeTestResultView()
					}
				}
		}
		.environmentObject(registerVM)
    }
}

#Preview {
	RegisterNavigationView(registerVM: RegisterViewModel())
}
