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
import FirebaseMessaging

@main
struct NanaLandApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 파이어 베이스 설정
        FirebaseApp.configure()
        // 앱 실행시 유저에게 알림 허용 권한을 받음
        if #available(iOS 10.0, *) {
                  // For iOS 10 display notification (sent via APNS)
                  UNUserNotificationCenter.current().delegate = self

                  let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
                  UNUserNotificationCenter.current().requestAuthorization(
                      options: authOption,
                      completionHandler: {_, _ in })
              } else {
                  let settings: UIUserNotificationSettings =
                  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                  application.registerUserNotificationSettings(settings)
              }
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
         Messaging.messaging().delegate = self
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
        }
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        print("토큰을 받았다")
        // Store this token to firebase and retrieve when to send message to someone...
        let dataDict: [String: String] = ["token": fcmToken ?? ""]

        // Store token in Firestore For Sending Notifications From Server in Future...

        print(dataDict)

    }
    // 푸시 메세지가 앱이 켜져있을 때 나올떄
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  willPresent notification: UNNotification,
                                  withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {

        let userInfo = notification.request.content.userInfo


        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }


        print(userInfo)

        completionHandler([[.banner, .badge, .sound]])
      }

        // 푸시메세지를 받았을 떄
      func userNotificationCenter(_ center: UNUserNotificationCenter,
                                  didReceive response: UNNotificationResponse,
                                  withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo

        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }

        print(userInfo)

        completionHandler()
      }
}
