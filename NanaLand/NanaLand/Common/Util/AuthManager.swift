//
//  AuthManager.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

// 소셜 로그인을 다루는 manager
final class AuthManager {
	@AppStorage("locale") var locale: String = "KOREAN"
	
	/// 카카오 로그인
	func kakaoLogin() {
		if (UserApi.isKakaoTalkLoginAvailable()) {
			// 카카오톡 앱으로 로그인
			UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
				guard let self = self else { return }
				
				guard error == nil else {
					print("카카오톡 앱으로 로그인 에러 - ")
					print(error!.localizedDescription)
					return
				}
				
				print("카카오톡 앱으로 로그인 성공")
				
				self.getKakaoUserInfoAndLoginToServer()
			}
		} else {
			// 카카오 계정으로 로그인
			UserApi.shared.loginWithKakaoAccount {[weak self] (oauthToken, error) in
				guard let self = self else { return }
				
				guard error == nil else {
					print("카카오 계정으로 로그인 에러 - ")
					print(error!.localizedDescription)
					return
				}
				
				print("카카오 계정으로 로그인 성공")
				self.getKakaoUserInfoAndLoginToServer()
			}
		}
	}
	
	/// 카카오 유저 정보를 가져오고 나나랜드 서버에 로그인
	func getKakaoUserInfoAndLoginToServer() {
		UserApi.shared.me() {[weak self] (user, error) in
			guard let self = self else { return }
			
			guard error == nil else {
				print("유저 정보 가져오기 에러 - ")
				print(error!.localizedDescription)
				return
			}
			
			guard let email = user?.kakaoAccount?.email,
				  let id = user?.id
			else {
				print("email과 id는 nil일 수 없습니다.")
				return
			}
			let gender = user?.kakaoAccount?.gender.map { $0 == .Male ? "male" : "female" } ?? ""
			
			let birthDate: String = {
				if let birthYear = user?.kakaoAccount?.birthyear,
				   let birthDay = user?.kakaoAccount?.birthday {
					return "\(birthYear)-\(birthDay.prefix(2))-\(birthDay.suffix(2))"
				} else {
					return ""
				}
			}()
			
			let request = LoginRequest(
				locale: self.locale,
				email: email,
				gender: gender,
				birthDate: birthDate,
				provider: "KAKAO",
				providerId: id
			)
			Task {
				let serverTokens = await AuthService.loginServer(body: request)
				if let serverTokens = serverTokens {
					KeyChainManager.addItem(key: "accessToken", value: serverTokens.data.accessToken)
					KeyChainManager.addItem(key: "refreshToken", value: serverTokens.data.refreshToken)
				} else {
					print("나나랜드 서버에서 토큰 받아오기 실패")
				}
			}
		}
	}
}
