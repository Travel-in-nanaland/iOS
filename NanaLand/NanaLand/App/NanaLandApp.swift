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
import UserNotifications

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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 파이어 베이스 설정
        FirebaseApp.configure()
        // 앱 실행시 유저에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        // Messaging.messaging().delegate = self
        
        return true
    }
}
