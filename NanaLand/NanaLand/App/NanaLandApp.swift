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
import Firebase

@main
struct NanaLandApp: App {
	@StateObject var localizationdManager = LocalizationManager.shared
	@StateObject var appState = AppState.shared
	@AppStorage("hasRunBefore") var hasRunBefore: Bool = false

	init() {
		KakaoSDK.initSDK(appKey: Secrets.kakaoLoginNativeAppKey)
		
		if !hasRunBefore {
			KeyChainManager.deleteItem(key: "accessToken")
			KeyChainManager.deleteItem(key: "refreshToken")
			hasRunBefore = true
		}
		
		FirebaseApp.configure()
	}
	
    var body: some Scene {
        WindowGroup {
			NanaHome()
				.environmentObject(localizationdManager)
				.onOpenURL{ url in
					if url.scheme == "nanaland" {
						DeepLinkManager.shared.handleDeepLink(url: url )
					} else if (AuthApi.isKakaoTalkLoginUrl(url)) {
						AuthController.handleOpenUrl(url: url)
					} else {
						GIDSignIn.sharedInstance.handle(url)
					}
				}
				.onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
		}
	}
}
