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
	@AppStorage("isLogin") var isLogin: Bool = false
	
	@ObservedObject var registerVM: RegisterViewModel
	
	init(registerVM: RegisterViewModel) {
		self.registerVM = registerVM
	}

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
				
				self.getKakaoUserInfoAndTryLogin()
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
				self.getKakaoUserInfoAndTryLogin()
			}
		}
	}
	
	/// 카카오 로그인 후 서버에 로그인 시도
	func getKakaoUserInfoAndTryLogin() {
		UserApi.shared.me() {[weak self] (user, error) in
			guard let self = self else {return}
				
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
			
			let loginRequest = LoginRequest(locale: self.locale, provider: "KAKAO", providerId: id)
			
			Task {
				var gender: String = ""
				if let userGender = user?.kakaoAccount?.gender {
					gender = userGender == .Male ? "MALE" : "FEMALE"
				}
				
				var birthDate: String = ""
				if let birthYear = user?.kakaoAccount?.birthyear,
				   let birthDay = user?.kakaoAccount?.birthday {
					birthDate = "\(birthYear)-\(birthDay.prefix(2))-\(birthDay.suffix(2))"
				}
				
				await self.loginToServer(
					request: loginRequest,
					email: email,
					gender: gender,
					birthDate: birthDate
				)
			}
			
			
		}
	}
	
	/// 구글 로그인
	func googleLogin() {
		guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
		GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) {[weak self] signInResult, error in
			guard let self = self else {return}
			
			guard let result = signInResult else {
				print("구글 로그인 실패")
				print(error?.localizedDescription ?? "")
				return
			}
			
			let user = result.user
			
			guard let email = user.profile?.email,
				  let userId = user.userID,
				  let id = Int64(userId)
			else {
				print("email과 id는 nil일 수 없습니다.")
				return
			}
			
			let loginRequest = LoginRequest(locale: self.locale, provider: "GOOGLE", providerId: id)
			
			Task {
				await self.loginToServer(
					request: loginRequest,
					email: email
				)
			}
			
		}
	}
	
	/// 서버에 로그인 실패(404)시 회원가입 필요(데이터 임시저장)
	/// 서버에 로그인 성공 시 다음 화면
	func loginToServer(request: LoginRequest, email: String, gender: String = "", birthDate: String = "") async {
		let result = await AuthService.loginServer(body: request)
		
		if let tokens = result?.data {
			// 로그인 성공 토큰 저장하고 홈 화면으로
			KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
			KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
			self.isLogin = true
			
		} else if result?.status == 404 {
			// 로그인 실패(404)인 경우 회원가입 필요
			// 현재 상태 저장하고 약관 동의 화면으로
			registerVM.state.registerRequest = RegisterRequest(
				locale: locale,
				email: email,
				gender: gender,
				birthDate: birthDate,
				provider: request.provider,
				providerId: request.providerId
			)
			
			registerVM.state.isRegisterNeeded = true
		}
	}
}
