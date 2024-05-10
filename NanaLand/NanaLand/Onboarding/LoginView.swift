//
//  LoginView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI
import GoogleSignInSwift

struct LoginView: View {
	let authManager = AuthManager()
	
    var body: some View {
		VStack(spacing: 16) {
			HStack(spacing: 8) {
				Image(.kakaoLoginIcon)
				
				Text("카카오 로그인")
					.font(.system(size: 14))
			}
			.background {
				RoundedRectangle(cornerRadius: 12)
					.fill(Color(hex: 0xFEE500))
					.frame(width: Constants.screenWidth-32, height: 48)
			}
			.onTapGesture {
//				Task {
//					await authManager.kakaoLogin()
//				}
				authManager.kakaoLogin()
			}
			
			GoogleSignInButton(action: authManager.googleLogin)
		}
    }
}

#Preview {
    LoginView()
}