//
//  NanaNavigationBar.swift
//  NanaLand
//
//  Created by 정현우 on 4/21/24.
//

import SwiftUI

struct NanaNavigationBar: View {
	@Environment(\.dismiss) var dismiss
	
	let title: LocalizedKey
	let showBackButton: Bool
	
	init(title: LocalizedKey, showBackButton: Bool = false) {
		self.title = title
		self.showBackButton = showBackButton
	}
	
    var body: some View {
		ZStack(alignment: .bottom) {
			Rectangle()
				.fill(Color.clear)
				.frame(height:20)
				.background(
					Color.white
						.shadow(color: Color.baseBlack.opacity(0.05), radius: 8, y: 5)
				)
			
			
			HStack {
				Spacer()
				Text(title)
					.font(.gothicNeo(.bold, size: 20))
				Spacer()
			}
			.frame(height: 56)
			.background(Color.white)
		}
		.frame(height: 56)
		.overlay(alignment: .leading) {
			if showBackButton {
				Button(action: {
					dismiss()
				}, label: {
					Image("icLeft")
						.resizable()
						.frame(width: 32, height: 32)
				})
				.padding(.horizontal, 16)
				.tint(.baseBlack)
			}
		}
    }
}

#Preview {
	NanaNavigationBar(title: .favorite, showBackButton: true)
}
