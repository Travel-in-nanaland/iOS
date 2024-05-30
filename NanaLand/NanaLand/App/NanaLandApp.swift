//
//  NanaLandApp.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

@main
struct NanaLandApp: App {
	@StateObject var localizationdManager = LocalizationManager.shared
	@AppStorage("hasRunBefore") var hasRunBefore: Bool = false

	init() {
		KakaoSDK.initSDK(appKey: Secrets.kakaoLoginNativeAppKey)
		
		if !hasRunBefore {
			KeyChainManager.deleteItem(key: "accessToken")
			KeyChainManager.deleteItem(key: "refreshToken")
			hasRunBefore = true
		}
	}
	
    var body: some Scene {
        WindowGroup {
			NanaHome()
				.environmentObject(localizationdManager)
				.onOpenURL{ url in
					if (AuthApi.isKakaoTalkLoginUrl(url)) {
						AuthController.handleOpenUrl(url: url)
					} else {
						GIDSignIn.sharedInstance.handle(url)
					}
				}
		}
	}
}
