//
//  NanaSearchBar.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import SwiftUI

struct NanaSearchBar: View {
	@Binding var searchTerm: String
	
	let placeHolder: String
	let searchAction: () -> Void
	let clearButtonAction: () -> Void
	
	init(
		searchTerm: Binding<String>,
		placeHolder: String = String(localized: "inputSearchTerm"),
		searchAction: @escaping () -> Void = {},
		clearButtonAction: @escaping () -> Void = {}
	) {
		self._searchTerm = searchTerm
		self.placeHolder = placeHolder
		self.searchAction = searchAction
		self.clearButtonAction = clearButtonAction
	}
	
    var body: some View {
		HStack {
			TextField(text: $searchTerm, label: {
				Text(placeHolder)
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
			})
			.submitLabel(.search)
			.onSubmit {
				searchAction()
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 11)
			.font(.gothicNeo(.medium, size: 14))
			.background {
				Capsule()
					.stroke(Color.main, lineWidth: 1)

			}
			.overlay(alignment: .trailing) {
				Button(action: {
					searchTerm = ""
					clearButtonAction()
				}, label: {
					Image(.icXCircle)
						.resizable()
						.frame(width: 12, height: 12)
						.padding(.horizontal, 12)
				})
			}
		}
    }
}

#Preview {
	NanaSearchBar(searchTerm: .constant(""))
}
