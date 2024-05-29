//
//  AlertView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct AlertView: View {
	let title: LocalizedKey
	let message: LocalizedKey?
	let leftButtonTitle: LocalizedKey
	let rightButtonTitle: LocalizedKey
	let leftButtonAction: () -> Void
	let rightButtonAction: () -> Void
	
	var body: some View {
		ZStack {
			Color.black
				.opacity(0.3)
				.ignoresSafeArea()
			
			VStack(spacing: 0) {
				Text(title)
					.multilineTextAlignment(.center)
					.font(.title01_bold)
					.foregroundStyle(.baseBlack)
					.padding(.top, 28)
					.padding(.bottom, 16)
				
				if message != nil {
					Text(message!)
						.multilineTextAlignment(.center)
						.font(.body01)
						.foregroundStyle(.gray1)
				}
				
				Divider()
					.foregroundStyle(Color.gray2)
					.frame(height: 1)
					.padding(.top, 24)
				
				HStack(spacing: 0) {
					Button(action: {
						leftButtonAction()
					}, label: {
						Text(leftButtonTitle)
							.font(.title02_bold)
							.foregroundStyle(Color.baseBlack)
							.frame(width: (Constants.screenWidth - 61)/2)
					})
					
					Divider()
						.foregroundStyle(Color.gray2)
						.frame(width: 1)
						
					
					Button(action: {
						rightButtonAction()
					}, label: {
						Text(rightButtonTitle)
							.font(.title02_bold)
							.foregroundStyle(Color.main)
							.frame(width: (Constants.screenWidth - 61)/2)
					})
				}
				.frame(height: 55)

				
				
			}
			.frame(width: Constants.screenWidth - 60)
			.background(Color.white)
			.cornerRadius(10)
		}
		.background(ClearBackground())
	}
}


