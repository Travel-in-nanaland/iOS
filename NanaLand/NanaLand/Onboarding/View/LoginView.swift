//
//  LoginView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI
import GoogleSignInSwift
import AuthenticationServices

struct LoginView: View {
	@ObservedObject var registerVM: RegisterViewModel
	let authManager: AuthManager
	
	init(registerVM: RegisterViewModel) {
		self.registerVM = registerVM
		self.authManager = AuthManager(registerVM: registerVM)
	}
	
    var body: some View {
		VStack(spacing: 0) {
			
			Spacer()
			
			Image(.logo)
				.resizable()
				.frame(width: 172.8, height: 171.3)
				.padding(.bottom, 32)
			
			Text("nanaland")
				.foregroundStyle(Color.main)
				.font(.gothicNeo(.bold, size: 48))
			
			Text("IN JEJU")
				.foregroundStyle(Color.main)
				.font(.gothicNeo(.light, size: 25))
			
			Spacer()
			
			VStack(spacing: 16) {
				if LocalizationManager.shared.language == .korean {
					Button(action: {
						authManager.kakaoLogin()
					}, label: {
						HStack(spacing: 8) {
							Image(.kakaoLoginIcon)
								.resizable()
								.frame(width: 18, height: 18)
							
							Text("카카오 로그인")
								.font(.gothicNeo(.medium, size: 14))
								.foregroundStyle(Color.black)
						}
						.frame(width: Constants.screenWidth-32, height: 48)
						.background {
							RoundedRectangle(cornerRadius: 12)
								.fill(Color(hex: 0xFEE500))
						}
					})
				}
				
				
				Button(action: {
					authManager.appleLogin()
				}, label: {
					HStack(spacing: 8) {
						Image(.appleLoginIcon)
							.resizable()
							.frame(width: 18, height: 18)
						
						Text(.appleLogin)
							.font(.gothicNeo(.medium, size: 14))
							.foregroundStyle(Color.white)
						
					}
					.frame(width: Constants.screenWidth-32, height: 48)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.fill(Color(hex: 0x050708))
					}
				})
				
				Button(action: {
					authManager.googleLogin()
				}, label: {
					HStack(spacing: 16) {
						Image(.googleLoginIcon)
							.resizable()
							.frame(width: 18, height: 18)
						
						Text(.googleLogin)
							.font(.system(size: 14))
							.foregroundStyle(Color.baseBlack)
					}
					.frame(width: Constants.screenWidth-32, height: 48)
					.background {
						RoundedRectangle(cornerRadius: 12)
							.stroke(Color(hex: 0x747775), lineWidth: 1)
					}
				})
				
			}
			.padding(.bottom, 24)
			
			Button(action: {
				authManager.nonMemeberLogin()
			}, label: {
				Text(.nonMemeberLogin)
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
			})
			.padding(.bottom, 40)
		}
    }
}

#Preview {
	LoginView(registerVM: RegisterViewModel())
}
