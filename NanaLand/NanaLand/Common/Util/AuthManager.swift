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
import SwiftJWT
import Alamofire

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
            UserDefaults.standard.set(email, forKey: "UserEmail")
            
            let loginRequest = LoginRequest(locale: self.locale, provider: "KAKAO", providerId: "\(id)", fcmToken: "\(UserDefaults.standard.string(forKey: "FCMToken"))")
			
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
            UserDefaults.standard.set(email, forKey: "UserEmail")
			
            let loginRequest = LoginRequest(locale: self.locale, provider: "GOOGLE", providerId: "\(userId)", fcmToken: UserDefaults.standard.string(forKey: "FCMToken") ?? "")
			
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
	
	func nonMemeberLogin() async {
		guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {return}
		print(deviceId)
		
		let loginRequest = LoginRequest(
			locale: self.locale,
			provider: "GUEST",
			providerId: deviceId,
            fcmToken: "\(UserDefaults.standard.string(forKey: "FCMToken") ?? "")"
		)
		
		await loginToServerFromNonMember(request: loginRequest)
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
            print("비회원 로그인 성공: 토큰 획득")
			KeyChainManager.addItem(key: "accessToken", value: tokens.accessToken)
			KeyChainManager.addItem(key: "refreshToken", value: tokens.refreshToken)
            UserDefaults.standard.set("", forKey: "UserEmail")
			self.isLogin = true
			self.provider = "GUEST"
		} else if result?.status == 404 {
			// 로그인 실패(404)인 경우 회원가입 필요
            print("비회원 로그인 실패: 회원가입 진행")
			let registerRequest = RegisterRequest(
				locale: request.locale,
				email: "GUEST@nanaland.com",
				nickname: "GUEST",
				provider: request.provider,
				providerId: request.providerId
			)
			
			let registerResult = await AuthService.registerServer(body: registerRequest, image: [])
			
			if let tokens = registerResult?.data {
                print("비회원 회원가입 성공: 토큰 획득")
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
		} else {
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
			appleWithdraw(withdrawalType: withdrawalType)
		} else {
			Task {
				await self.withdrawFromServer(withdrawalType: withdrawalType)
			}
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
	
	/// 애플 회원탈퇴
	private func appleWithdraw(withdrawalType: String) {
		guard let authorizationCode = KeyChainManager.readItem(key: "appleAuthorizationCode") else {return}
		let jwt = makeAppleJWT()
		getAppleRefreshToken(jwt: jwt, code: authorizationCode, completion: { refreshToken in
			self.revokeAppleToken(jwt: jwt, token: refreshToken, completion: {
				print("애플 회원 탈퇴 성공")
				Task {
					await self.withdrawFromServer(withdrawalType: withdrawalType)
				}
			})
		})
	}
	
	private func makeAppleJWT() -> String {
		let myHeader = Header(kid: Secrets.appleKeyId)
		struct MyClaims: Claims {
			let iss: String  // apple team id
			let iat: Int  // 현재일자
			let exp: Int  // 만료일자
			let aud: String  // "https://appleid.apple.com/"
			let sub: String  // 번들 id
		}
		
		let nowDate = Date()
		var dateComponent = DateComponents()
		dateComponent.month = 6
		let sixDate = Calendar.current.date(byAdding: dateComponent, to: nowDate) ?? Date()
		let iat = Int(Date().timeIntervalSince1970)
		let exp = iat + 3600
		let myClaims = MyClaims(
			iss: Secrets.appleTeamId,
			iat: iat,
			exp: exp,
			aud: "https://appleid.apple.com",
			sub: "com.jeju.nanaland"
		)
		var myJWT = JWT(header: myHeader, claims: myClaims)
		
		//JWT 발급을 요청값의 암호화 과정에서 다운받아두었던 Key File이 필요하다.(.p8 파일)
		guard let url = Bundle.main.url(forResource: Secrets.appleKeyPath, withExtension: "p8") else{
			return ""
		}
		
		let privateKey: Data = try! Data(contentsOf: url, options: .alwaysMapped)
		let jwtSigner = JWTSigner.es256(privateKey: privateKey)
		let signedJWT = try! myJWT.sign(using: jwtSigner)
		print("🗝 singedJWT - \(signedJWT)")
		return signedJWT
	}
	
	// 애플 토큰 리프레싱
	private func getAppleRefreshToken(jwt: String, code: String, completion: @escaping (String) -> Void) {
		let url = "https://appleid.apple.com/auth/token?client_id=com.jeju.nanaland&client_secret=\(jwt)&code=\(code)&grant_type=authorization_code"
		let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
		
		AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
			.validate(statusCode: 200..<500)
			.responseData { response in
				switch response.result {
				case .success(let result):
					let decoder = JSONDecoder()
					if let decodedData = try? decoder.decode(AppleTokenResponse.self, from: result) {
						print("애플 토큰 발급 성공 \(decodedData.refresh_token)")
						completion(decodedData.refresh_token)
					} else {
						print("애플 토큰 발급 실패")
					}
				case .failure(let error):
					print("애플 토큰 발급 실패 - \(error.localizedDescription)")
				}
			}
	}
	
	// 발금된 토큰 revoke
	private func revokeAppleToken(jwt: String, token: String, completion: @escaping () -> Void) {
		let url = "https://appleid.apple.com/auth/revoke?client_id=com.jeju.nanaland&client_secret=\(jwt)&token=\(token)&token_type_hint=refresh_token"
		let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
		
		AF.request(url, method: .post, headers: header)
			.validate(statusCode: 200..<600)
			.responseData { response in
				guard let statusCode = response.response?.statusCode else {
					print("애플 토큰 삭제 실패")
					return
				}
				if statusCode == 200 {
					print("애플 토큰 삭제 성공")
					completion()
				} else {
					print("애플 토큰 삭제 실패")
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

struct AppleTokenResponse: Codable {
	let access_token: String
	let token_type: String
	let expires_in: Int
	let refresh_token: String
	let id_token: String
}

extension AuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return ASPresentationAnchor()
	}
	
	// 애플 로그인 성공
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		guard let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {return}
		let userId = appleIdCredential.user
		var email = appleIdCredential.email ?? ""
        
        // email이 비어있을 때 (2번째 로그인 부터는 email이 identityToken에 들어있음.
        if email.isEmpty {
            if let tokenString = String(data: appleIdCredential.identityToken ?? Data(), encoding: .utf8) {
                email = decode(jwtToken: tokenString)["email"] as? String ?? ""
            }
        }
        
		registerVM.state.nickname = appleIdCredential.fullName?.givenName ?? ""
		if let authorizationCode = String(data: appleIdCredential.authorizationCode ?? Data(), encoding: .utf8) {
			KeyChainManager.addItem(key: "appleAuthorizationCode", value: authorizationCode)
			
            let loginRequest = LoginRequest(locale: self.locale, provider: "APPLE", providerId: userId, fcmToken: "\(UserDefaults.standard.string(forKey: "FCMToken") ?? "")")
            print("email:\(email)")
            UserDefaults.standard.set("", forKey: "UserEmail")
			Task {
				await self.loginToServer(
					request: loginRequest,
					email: email,
					gender: "",
					birthDate: ""
				)
			}
		} else {
			// TODO: 토큰 못 가져오는 경우 ErrorHandler처리
            print("토큰 못 가져옴")
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
