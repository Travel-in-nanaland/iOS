//
//  RegisterInductionView.swift
//  NanaLand
//
//  Created by 정현우 on 5/21/24.
//

import SwiftUI

struct RegisterInductionView: View {
	let closeAction: () -> Void
	
    var body: some View {
		ZStack {
			Color.baseBlack.opacity(0.7)
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: 0) {
				Image(.logo)
					.resizable()
					.frame(width: 50, height: 50)
					.padding(.top, 47)
					.padding(.bottom, 32)
				
				Text("나나랜드의 회원이 되셔야,\n모든 서비스를\n이용하실 수 있습니다✨")
					.multilineTextAlignment(.center)
					.font(.title01_bold)
					.padding(.bottom, 40)
				
				Button(action: {
					UserDefaults.standard.setValue(false, forKey: "isLogin")
				}, label: {
					RoundedRectangle(cornerRadius: 30)
						.fill(Color.main)
						.frame(width: Constants.screenWidth-120, height: 48)
						.overlay {
							HStack(spacing: 4) {
								Text("회원가입 하러 가기")
									.font(.body_semibold)
								
								Image(.icRight)
									.resizable()
									.frame(width: 20, height: 20)
							}
						}
				})
				.tint(Color.baseWhite)
				.padding(.bottom, 40)
			}
			.frame(width: Constants.screenWidth-60)
			.background(Color.baseWhite)
			.clipShape(RoundedRectangle(cornerRadius: 10))
			.overlay(alignment: .topTrailing) {
				Button(action: {
					closeAction()
				}, label: {
					Image(.icX)
						.resizable()
						.frame(width: 32, height: 32)
				})
				.padding(.top, 16)
				.padding(.trailing, 16)
			}
			
		}
    }
}

#Preview {
	RegisterInductionView(closeAction: {})
}
