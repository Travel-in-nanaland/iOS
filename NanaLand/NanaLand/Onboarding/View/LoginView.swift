//
//  LoginView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI
import GoogleSignInSwift

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
				HStack(spacing: 8) {
					Image(.kakaoLoginIcon)
						.resizable()
						.frame(width: 18, height: 18)
					
					Text("카카오 로그인")
						.font(.system(size: 14))
				}
				.frame(width: Constants.screenWidth-32, height: 48)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.fill(Color(hex: 0xFEE500))
				}
				.onTapGesture {
					authManager.kakaoLogin()
				}
				
				HStack(spacing: 0) {
					Text("Apple로 로그인")
				}
				.frame(width: Constants.screenWidth-32, height: 48)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.fill(Color(hex: 0x050708))
				}
				
				HStack(spacing: 16) {
					Image(.googleLoginIcon)
						.resizable()
						.frame(width: 18, height: 18)
					
					Text("Google 로그인")
						.font(.system(size: 14))
						.foregroundStyle(Color.baseBlack)
				}
				.frame(width: Constants.screenWidth-32, height: 48)
				.background {
					RoundedRectangle(cornerRadius: 12)
						.stroke(Color(hex: 0x747775), lineWidth: 1)
				}
				.onTapGesture {
					authManager.googleLogin()
				}
				
			}
			.padding(.bottom, 24)
			
			Button(action: {
				
			}, label: {
				Text("로그인없이 둘러보기")
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
