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
	
	@State var isSplashCompleted: Bool = false
	@AppStorage("isLogin") var isLogin: Bool = true
	@AppStorage("isLanguageSelected") var isLanguageSelected: Bool = true
	
	var body: some View {
		if !isSplashCompleted {
			SplashView()
				.onAppear {
					Task {
						if let result = await AuthService.refreshingToken() {
							KeyChainManager.addItem(key: "accessToken", value: result.data)
							isLogin = true
						}
					}
					
					DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: {
						isSplashCompleted = true
					})
				}
		} else if !isLanguageSelected {
			LanguageSelectView()
		} else if !isLogin {
			LoginView()
		} else {
			NanaLandTabView()
				.environmentObject(appState)
		}
	}
}
