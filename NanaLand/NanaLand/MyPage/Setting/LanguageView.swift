//
//  LanguageView.swift
//  NanaLand
//
//  Created by jun on 5/27/24.
//

import SwiftUI

struct LanguageView: View {
    @StateObject var viewModel = LanguageViewModel()
	@State private var showAlert = false
  
    var body: some View {
        VStack(spacing: 0) {
			NanaNavigationBar(title: .languageSetting, showBackButton: true)
                .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                Text(.languageMainDescription)
                    .padding(.leading, 16)
                    .font(.title2)
                Spacer()
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 0) {

				languageButton(language: .korean)
				languageButton(language: .english)
				languageButton(language: .chinese)
				languageButton(language: .malaysia)
            }
            Spacer()
        }
        .toolbar(.hidden)
		.onAppear {
			viewModel.action(.viewOnAppear)
		}
		.fullScreenCover(isPresented: $showAlert) {
			AlertView(
				title: .changeLanguageAlertTitle,
				leftButtonTitle: .no,
				rightButtonTitle: .yes,
				leftButtonAction: {
					showAlert = false
				},
				rightButtonAction: {
					viewModel.action(.changeLanguage)
					showAlert = false
				}
			)
		}
		.transaction { transaction in
			transaction.disablesAnimations = true
		} //애니메이션 효과 없애기
    }
	
	private func languageButton(language: Language) -> some View {
		return Button(action: {
			viewModel.action(.selectLanguage(language: language))
			showAlert = true
		}, label: {
			HStack {
				Text(language.name)
					.padding(.leading, 16)
					.font(.body01)
					.foregroundStyle(.black)
				
				Spacer()
			}
		})
		.frame(height: 50)
		.background(language == viewModel.state.selectedLanguage ? .main10P : .baseWhite)
	}
}

#Preview {
    LanguageView()
}

