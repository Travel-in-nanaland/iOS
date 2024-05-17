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

	init() {
		//KakaoSDK.initSDK(appKey: Secrets.kakaoLoginNativeAppKey)
	}
	
    var body: some Scene {
        WindowGroup {
			NanaHome()
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
