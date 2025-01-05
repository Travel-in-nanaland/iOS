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
	let leftButtonTitle: LocalizedKey?
	let rightButtonTitle: LocalizedKey
	let leftButtonAction: () -> Void
	let rightButtonAction: () -> Void
	
	init(
		title: LocalizedKey,
		message: LocalizedKey? = nil,
		leftButtonTitle: LocalizedKey? = nil,
		rightButtonTitle: LocalizedKey,
		leftButtonAction: @escaping () -> Void = {},
		rightButtonAction: @escaping () -> Void
	) {
		self.title = title
		self.message = message
		self.leftButtonTitle = leftButtonTitle
		self.rightButtonTitle = rightButtonTitle
		self.leftButtonAction = leftButtonAction
		self.rightButtonAction = rightButtonAction
	}
	
	var body: some View {
		ZStack {
			Color.black
				.opacity(0.3)
				.ignoresSafeArea()
			
            VStack(alignment: .center, spacing: 0) {
				Text(title)
					.multilineTextAlignment(.center)
                    .font(.body_semibold)
					.foregroundStyle(.baseBlack)
					.padding(.top, 28)
					.padding(.bottom, 16)
				
				if message != nil {
					Text(message!)
						.multilineTextAlignment(.center)
						.font(.body02_semibold)
						.foregroundStyle(.gray1)
                        .padding(.bottom, 24)
				}
				
				HStack(spacing: 0) {
          
					if leftButtonTitle != nil {
						Button(action: {
							leftButtonAction()
						}, label: {
							Text(leftButtonTitle!)
								.font(.body02)
								.foregroundStyle(Color.white)
						})
                        .frame(width: 110, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundStyle(.gray2)
                        )
                        .padding(.leading, 22)
					}
					Spacer()
					Button(action: {
						rightButtonAction()
					}, label: {
						Text(rightButtonTitle)
							.font(.body02)
							.foregroundStyle(Color.white)
						
					})
                    .frame(width: 110, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(Color.main)
                    )
                    .padding(.trailing, 22)
				}
                .frame(height: 55)
                .padding(.bottom, 12)
			}
            .frame(width: 276)
			.background(Color.white)
			.cornerRadius(10)
		}
		.background(ClearBackground())
	}
}


