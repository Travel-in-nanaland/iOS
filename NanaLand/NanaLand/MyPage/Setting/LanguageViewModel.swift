//
//  LanguageViewModel.swift
//  NanaLand
//
//  Created by jun on 5/27/24.
//

import Foundation

class LanguageViewModel: ObservableObject {
	struct State {
		var selectedLanguage: Language? = nil
	}
	
	enum Action {
		case viewOnAppear
		case selectLanguage(language: Language)
		case changeLanguage
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
	func action(_ action: Action) {
		switch action {
		case .viewOnAppear:
			getLocaleFromUserDefaults()
		case let .selectLanguage(language):
			selectLanguage(language: language)
		case .changeLanguage:
			changeLanguage()
		}
	}
	
	private func selectLanguage(language: Language) {
		state.selectedLanguage = language
	}
	
	private func changeLanguage() {
		if state.selectedLanguage != nil {
			Task {
				await LocalizationManager.shared.setLanguage(state.selectedLanguage!)
				// 언어 변경 후 유저 정보 다시 받아오기
				let response = await UserInfoService.getUserInfo()
				if response != nil {
					await MainActor.run {
						print(response!.data)
						AppState.shared.userInfo = response!.data
					}
				}

			}
		}
	}
	
	private func getLocaleFromUserDefaults() {
		let languageCode = UserDefaults.standard.string(forKey: "locale") ?? ""
		state.selectedLanguage = Language(rawValue: languageCode)
	}
}
