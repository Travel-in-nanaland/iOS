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
import AuthenticationServices

// 소셜 로그인을 다루는 manager
final class AuthManager: NSObject {
	@AppStorage("locale") var locale: String = ""
	@AppStorage("isLogin") var isLogin: Bool = false
	@AppStorage("provider") var provider: String = ""
	
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
			
			let loginRequest = LoginRequest(locale: self.locale, provider: "KAKAO", providerId: "\(id)")
			
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
				  let userId = user.userID
			else {
				print("email과 id는 nil일 수 없습니다.")
				return
			}
			
			let loginRequest = LoginRequest(locale: self.locale, provider: "GOOGLE", providerId: "\(userId)")
			
			Task {
				await self.loginToServer(
					request: loginRequest,
					email: email
				)
			}
			
		}
	}
	
	/// 애플 로그인
	func appleLogin() {
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.email]
		
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	func nonMemeberLogin() {
		guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {return}
		print(deviceId)
		
		let loginRequest = LoginRequest(
			locale: self.locale,
			provider: "GUEST",
			providerId: deviceId
		)
		
		Task {
			await loginToServerFromNonMember(request: loginRequest)
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
			self.provider = request.provider
			
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
			
			AppState.shared.isRegisterNeeded = true
		}
	}
	
	/// 비회원 로그인/회원가입
	func loginToServerFromNonMember(request: LoginRequest) async {
		let result = await AuthService.loginServer(body: request)
		
		if let tokens = result?.data {
			// 로그인 성공 토큰 저장하고 홈 화면으로
			KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
			KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
			self.isLogin = true
			self.provider = "GUEST"
			
		} else if result?.status == 404 {
			// 로그인 실패(404)인 경우 회원가입 필요
			let registerRequest = RegisterRequest(
				locale: request.locale,
				email: "GUEST@nanaland.com",
				nickname: "GUEST",
				provider: request.provider,
				providerId: request.providerId
			)
			
			let registerResult = await AuthService.registerServer(body: registerRequest, image: [])
			
			if let tokens = registerResult?.data {
				KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
				KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
				self.isLogin = true
				self.provider = "GUEST"
			} else {
				// TODO: 비회원 에러처리 필요
				print("비회원 회원가입 - 알 수 없는 에러")
			}
		}
	}
	
	/// 로그아웃
	func logout() {
		if provider == "KAKAO" {
			kakaoLogout()
		} else if provider == "GOOGLE" {
			googleLogout()
		} else if provider == "APPLE" {
			Task {
				await logoutFromServer()
			}
		}
	}
	
	/// 카카오 소셜 로그아웃
	private func kakaoLogout() {
		UserApi.shared.logout { error in
			if let error = error {
				print("카카오 로그아웃 에러 - \(error.localizedDescription)")
			}
			else {
				print("카카오 로그아웃 성공")
	
				Task {
					await self.logoutFromServer()
				}
			}
		}
	}
	
	/// 구글 소셜 로그아웃
	private func googleLogout() {
		GIDSignIn.sharedInstance.signOut()
		Task {
			await self.logoutFromServer()
		}
	}
	
	/// 나나랜드 서버 로그아웃
	private func logoutFromServer() async {
		let result = await AuthService.logout()
		if result?.status == 200 {
			print("나나랜드 서버 로그아웃 성공")
			// 토큰 제거하고 메인화면으로
			KeyChainManager.deleteItem(key: "accessToken")
			KeyChainManager.deleteItem(key: "refreshToken")
			AppState.shared.currentTab = .home
			AppState.shared.userInfo = .init()
			AppState.shared.isRegisterNeeded = false
			AppState.shared.navigationPath = NavigationPath()
			self.provider = ""
			self.isLogin = false
		} else {
			print("나나랜드 서버 로그아웃 실패")
		}
	}
	
	/// 회원탈퇴
	func withdraw(withdrawalType: String) {
		if provider == "KAKAO" {
			kakaoWithdraw(withdrawalType: withdrawalType)
		} else if provider == "GOOGLE" {
			googleWithdraw(withdrawalType: withdrawalType)
		} else if provider == "APPLE" {
			
		}
	}
	
	/// 카카오 회원탈퇴
	private func kakaoWithdraw(withdrawalType: String) {
		UserApi.shared.unlink {(error) in
			if let error = error {
				print("카카오 회원탈퇴 에러 - \(error.localizedDescription)")
			}
			else {
				print("카카오 회원탈퇴 성공")
				Task {
					await self.withdrawFromServer(withdrawalType: withdrawalType)
				}
			}
		}
	}
	
	/// 구글 회원탈퇴
	private func googleWithdraw(withdrawalType: String) {
		GIDSignIn.sharedInstance.disconnect { error in
			if let error = error {
				print("구글 회원탈퇴 에러 - \(error.localizedDescription)")
			} else {
				print("구글 회원탈퇴 성공")
				Task {
					await self.withdrawFromServer(withdrawalType: withdrawalType)
				}
			}

		}
	}
	
	/// 나나랜드 서버 회원탈퇴
	private func withdrawFromServer(withdrawalType: String) async {
		let result = await AuthService.withdraw(body: WithdrawRequest(withdrawalType: withdrawalType))
		if result?.status == 200 {
			print("나나랜드 서버 회원탈퇴 성공")
			// 토큰 제거하고 메인화면으로
			KeyChainManager.deleteItem(key: "accessToken")
			KeyChainManager.deleteItem(key: "refreshToken")
			AppState.shared.currentTab = .home
			AppState.shared.userInfo = .init()
			AppState.shared.isRegisterNeeded = false
			AppState.shared.navigationPath = NavigationPath()
			self.provider = ""
			self.isLogin = false
		} else {
			print("나나랜드 서버 회원탈퇴 실패")
		}
	}
}

extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return ASPresentationAnchor()
	}
	
	// 애플 로그인 성공
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
		
		let userId = appleIdCredential.user
		let email = appleIdCredential.email
		
		if let tokenString = String(data: appleIdCredential.identityToken ?? Data(), encoding: .utf8),
		   let emailFromToken = decode(jwtToken: tokenString)["email"] as? String {
			
			KeyChainManager.addItem(key: "appleAuthorizationCode", value: tokenString)
			
			let loginRequest = LoginRequest(locale: self.locale, provider: "APPLE", providerId: userId)
			
			Task {
				await self.loginToServer(
					request: loginRequest,
					email: email ?? emailFromToken,
					gender: "",
					birthDate: ""
				)
			}
		} else {
			// TODO: 토큰 못 가져오는 경우 ErrorHandler처리
		}
		
	}
	
	private func decode(jwtToken jwt: String) -> [String: Any] {
		func base64UrlDecode(_ value: String) -> Data? {
			var base64 = value
				.replacingOccurrences(of: "-", with: "+")
				.replacingOccurrences(of: "_", with: "/")
			
			let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
			let requiredLength = 4 * ceil(length / 4.0)
			let paddingLength = requiredLength - length
			if paddingLength > 0 {
				let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
				base64 = base64 + padding
			}
			return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
		}
		
		func decodeJWTPart(_ value: String) -> [String: Any]? {
			guard let bodyData = base64UrlDecode(value),
				  let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
				return nil
			}
			
			return payload
		}
		
		let segments = jwt.components(separatedBy: ".")
		return decodeJWTPart(segments[1]) ?? [:]
	}


	
	
}
