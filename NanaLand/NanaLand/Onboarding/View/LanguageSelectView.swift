//
//  LanguageSelectView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI

struct LanguageSelectView: View {
	@AppStorage("locale") var locale: String = ""
	
    var body: some View {
		VStack(spacing: 98) {
			VStack(spacing: 4) {
				Text("안녕하세요!")
					.font(.gothicNeo(.regular, size: 22))
				
				Text("언어를 선택해주세요")
					.font(.largeTitle01)
			}
			
			VStack(spacing: 32) {
				languageButton(title: "English", callback: {
					locale = "ENGLISH"
				})
				
				languageButton(title: "中国话", callback: {
					locale = "CHINESE"
				})
				
				languageButton(title: "Melayu", callback: {
					locale = "MALAYSIA"
				})
				languageButton(title: "한국어", callback: {
					locale = "KOREAN"
				})
			}
			
			Spacer()
		}
		.padding(.top, 60)
		
		
		
    }
	
	
	private func languageButton(title: String, callback: @escaping () -> Void) -> some View {
		RoundedRectangle(cornerRadius: 30)
			.fill(Color.main)
			.frame(width: 260, height: 48)
			.overlay {
				Text(title)
					.foregroundStyle(Color.baseWhite)
					.font(.body01)
			}
			.onTapGesture {
				callback()
			}
	}
	
}

#Preview {
    LanguageSelectView()
}
