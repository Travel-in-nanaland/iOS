//
//  NanaSearchBar.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import SwiftUI

struct NanaSearchBar: View {
	@Binding var searchTerm: String
	
	let placeHolder: LocalizedKey
	let searchAction: () async -> Void
	let showClearButton: Bool
	let clearButtonAction: () -> Void
	let disabled: Bool
	
	init(
		placeHolder: LocalizedKey = .inputSearchTerm,
		searchTerm: Binding<String>,
		searchAction: @escaping () async -> Void = {},
		showClearButton: Bool = true,
		clearButtonAction: @escaping () -> Void = {},
		disabled: Bool = false
	) {
		self.placeHolder = placeHolder
		self._searchTerm = searchTerm
		self.searchAction = searchAction
		self.showClearButton = showClearButton
		self.clearButtonAction = clearButtonAction
		self.disabled = disabled
	}
	
    var body: some View {
		HStack {
			TextField(text: $searchTerm, label: {
				Text(placeHolder)
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
			})
			.submitLabel(.search)
			.disabled(disabled)
			.onSubmit {
				Task {
					if searchTerm != "" {
						await searchAction()
					}
				}
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 11)
			.font(.gothicNeo(.medium, size: 14))
			.background {
				Capsule()
					.stroke(Color.main, lineWidth: 1)
			}
			.contentShape(Rectangle())
			.overlay(alignment: .trailing) {
				if showClearButton {
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
}

#Preview {
	NanaSearchBar(placeHolder: .inputSearchTerm, searchTerm: .constant(""))
}
