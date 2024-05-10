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
import GoogleSignIn

// 소셜 로그인을 다루는 manager
final class AuthManager {
	@AppStorage("locale") var locale: String = ""
	
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
				
				//				self.getKakaoUserInfoAndLoginToServer()
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
				//				self.getKakaoUserInfoAndLoginToServer()
			}
		}
	}
	
	/// 카카오 로그인 후 서버에 로그인 시도
	/// 서버에 로그인 실패(404)시 회원가입 필요(데이터 임시저장)
	/// 서버에 로그인 성공 시 다음 화면
	func getUserInfoAndTryLogin() {
		UserApi.shared.me() { (user, error) in
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
			
			let loginRequest = LoginRequest(email: email, provider: "KAKAO", providerId: id)
			
			Task {
				let result = await AuthService.loginServer(body: loginRequest)
				
				if let tokens = result?.data {
					// 로그인 성공 토큰 저장하고 홈 화면으로
					
				} else if result?.status == 404 {
					// 계정 정보 없음 회원 가입 필요
					// 데아터 임시 저장 후 다음 회원가입으로 넘어가기
				}
			}
			
			
		}
	}
	
	func googleLogin() {
		guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
		GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
			guard let result = signInResult else {
				print("구글 로그인 실패")
				print(error?.localizedDescription ?? "")
				return
			}
			
			let user = result.user
			let email = user.profile?.email
			
		}
	}
}
