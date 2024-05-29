//
//  TypeTestCheckStyleView.swift
//  NanaLand
//
//  Created by 정현우 on 5/28/24.
//

import SwiftUI

struct TypeTestCheckStyleView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let nickname: String
	
	var body: some View {
		VStack(spacing: 0) {
			titlePart
				.padding(.bottom, 53)
			
			circles
			
			Spacer()
			
			Button(action: {
				typeTestVM.action(.onTapLetsgoButton)
			}, label: {
				RoundedRectangle(cornerRadius: 30)
					.fill(Color.main)
					.frame(height: 48)
					.overlay {
						Text("Let's Go!")
							.foregroundStyle(Color.baseWhite)
							.font(.body_bold)
					}

			})
		}
		.padding(.top, 110)
		.padding(.bottom, 24)
		.padding(.horizontal, 16)
		.toolbar(.hidden, for: .navigationBar)
	}
	
	private var titlePart: some View {
		VStack(spacing: 16) {
			if LocalizationManager.shared.language == .malaysia {
				Text(.yourPreference)
					.font(.largeTitle02_regular)
					.foregroundStyle(Color.black)
				
				Text(.your, arguments: [nickname])
					.font(.largeTitle02)
					.foregroundStyle(Color.main)
			} else {
				Text(.your, arguments: [nickname])
					.font(.largeTitle02)
					.foregroundStyle(Color.main)
				
				Text(.yourPreference)
					.font(.largeTitle02_regular)
					.foregroundStyle(Color.black)
			}
			
			Text(.yourTravelStyle)
				.font(.largeTitle02_regular)
				.foregroundStyle(Color.black)
				.multilineTextAlignment(.center)
		}
	}
	
	private var circles: some View {
		VStack(spacing: 0) {
			Circle()
				.fill(Color.main)
				.frame(width: 24, height: 24)
				.padding(.bottom, 37)
			
			Circle()
				.fill(Color.main50P)
				.frame(width: 15, height: 15)
				.padding(.bottom, 34)
			
			Circle()
				.fill(Color.main10P)
				.frame(width: 11, height: 11)
				.padding(.bottom, 40)
			
			Circle()
				.fill(Color.main10P)
				.frame(width: 11, height: 11)
		}
	}
}

#Preview {
    TypeTestCheckStyleView(nickname: "현우")
		.environmentObject(TypeTestViewModel())
}
