//
//  NanaHome.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import SwiftUI

struct NanaHome: View {
	@StateObject var appState = AppState()
	@StateObject var registerVM = RegisterViewModel()
	
	@State var isSplashCompleted: Bool = false
	
	@AppStorage("locale") var locale: String = ""
	@AppStorage("isLogin") var isLogin: Bool = false
	
	var body: some View {
		if !isSplashCompleted {
			SplashView()
				.onAppear {
					// 토큰 refresh 성공하면 isLogin true로
					Task {
						if let data = await AuthService.refreshingToken()?.data {
							KeyChainManager.addItem(key: "accessToken", value: data.accessToken)
							KeyChainManager.addItem(key: "refreshToken", value: data.refreshToken)
//							isLogin = true
						}
					}
					
					DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
						isSplashCompleted = true
					})
					
					// 테스트 용
					locale = ""
					isLogin = false
				}
		} else if locale.isEmpty {
			LanguageSelectView()
		} else if registerVM.state.isRegisterNeeded {
			RegisterNavigationView(registerVM: registerVM)
		} else if !isLogin {
			LoginView(registerVM: registerVM)
		} else {
			NanaLandTabView()
				.environmentObject(appState)
		}
	}
}
