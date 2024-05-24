//
//  RegisterNavigationView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI

struct RegisterNavigationView: View {
	@ObservedObject var registerVM: RegisterViewModel
	@StateObject var appState = AppState.shared
	
    var body: some View {
		NavigationStack(path: $registerVM.state.registerPath) {
			RegisterTermsAgreementView()
				.navigationDestination(for: RegisterViewType.self) { registerViewtype in
					switch registerViewtype {
					case .termsAgreement:
						RegisterTermsAgreementView()
					case .nicknameAndProfile:
						RegisterNicknameAndProfileView()
					}
				}
		}
		.environmentObject(registerVM)
    }
}

#Preview {
	RegisterNavigationView(registerVM: RegisterViewModel())
}
