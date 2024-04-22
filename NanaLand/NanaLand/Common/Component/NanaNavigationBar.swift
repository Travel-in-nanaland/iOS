//
//  NanaNavigationBar.swift
//  NanaLand
//
//  Created by 정현우 on 4/21/24.
//

import SwiftUI

struct NanaNavigationBar: View {
	@Environment(\.dismiss) var dismiss
	
	let title: String
	let showBackButton: Bool
	
	init(title: String, showBackButton: Bool = false) {
		self.title = title
		self.showBackButton = showBackButton
	}
	
    var body: some View {
		HStack {
			Spacer()
			Text(title)
				.font(.gothicNeo(.bold, size: 20))
			Spacer()
		}
		.frame(height: 56)
		.background(
			Color.white
				.shadow(color: Color.baseBlack.opacity(0.1), radius: 4, y: 9)
		)
		.overlay(alignment: .leading) {
			if showBackButton {
				Button(action: {
					dismiss()
				}, label: {
					Image(.icLeft)
						.resizable()
						.frame(width: 32, height: 32)
				})
				.padding(.horizontal, 16)
			}
		}
    }
}

#Preview {
    NanaNavigationBar(title: String(localized: "favorite"), showBackButton: true)
}
