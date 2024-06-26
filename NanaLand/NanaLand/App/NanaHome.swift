//
//  NanaHome.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import SwiftUI

struct NanaHome: View {
	@StateObject var registerVM = RegisterViewModel()
	
	@State var isSplashCompleted: Bool = false
	// remote config 값을 가져 왔는지
	@State var didGetRemoteConfig: Bool = false
	// remote config 값을 가져왔는데 업데이트가 필요한 경우
	@State var showUpdateRequired: Bool = false
	
	@AppStorage("locale") var locale: String = ""
	@AppStorage("isLogin") var isLogin: Bool = false
    
    @StateObject var viewModel = ProfileMainViewModel()
	
	let remoteConfigManager = RemoteConfigManager()
	
	var body: some View {
		ZStack {
			// splash가 완료되지 않았거나, 리모트 컨피그를 받아오지 못했거나, (리모트 컨피그를 받아왔는데 업데이트가 필요하거나)
			if !isSplashCompleted || !didGetRemoteConfig || (didGetRemoteConfig && showUpdateRequired) {
				SplashView()
					.onAppear {
						// 토큰 refresh 성공하면 isLogin true로
						Task {
							if let data = await AuthService.refreshingToken()?.data {
								KeyChainManager.addItem(key: "accessToken", value: data.accessToken)
								KeyChainManager.addItem(key: "refreshToken", value: data.refreshToken)
								isLogin = true
								// isLogin이 true로 바뀔 경우에 유저 정보 appState에 저장
								if isLogin {
									Task {
										await getUserInfo()
										AppState.shared.userInfo = viewModel.state.getProfileMainResponse
										
										
									}
								}
							}
							
							if let minimumVersion = await remoteConfigManager.getMinimumVersion() {
								let updateRequired = remoteConfigManager.checkUpdateRequired(minimumVersion: minimumVersion)
								showUpdateRequired = updateRequired
								didGetRemoteConfig = true
							}
						}
						
						DispatchQueue.main.asyncAfter(deadline: .now() + Constants.splashTime, execute: {
							isSplashCompleted = true
							AppState.shared.isSplashCompleted = true
						})
						
						// 테스트 용
						//					locale = ""
						//					isLogin = false
					}
			} else if locale.isEmpty {
				LanguageSelectView()
			} else if AppState.shared.isRegisterNeeded {
				RegisterNavigationView(registerVM: registerVM)
			} else if !isLogin {
				LoginView(registerVM: registerVM)
			} else {
				NanaLandTabView()
					.onAppear {
						if AppState.shared.userInfo.nickname == "" {
							Task {
								await getUserInfo()
								
								AppState.shared.userInfo = viewModel.state.getProfileMainResponse
							}
						}
					}
			}
			
			if showUpdateRequired {
				AlertView(title: .updateRequired, rightButtonTitle: .openAppstore, rightButtonAction: {
					if let url = URL(string: "https://apps.apple.com/app/id6502518614") {
						if UIApplication.shared.canOpenURL(url) {
							UIApplication.shared.open(url, options: [:], completionHandler: nil)
						}
					}
				})
			}
			
		}
	}
    
    func getUserInfo() async {
        await viewModel.action(.getUserInfo)
    }
}
