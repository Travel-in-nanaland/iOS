//
//  LocalizationManager.swift
//  NanaLand
//
//  Created by 정현우 on 5/27/24.
//

import Foundation

class LocalizationManager: ObservableObject {
	static let shared = LocalizationManager()
	
	@Published var language: Language = .english
	
	init() {
		getLanguage()
	}

	func setLanguage(_ language: Language) {
		UserDefaults.standard.set(language.rawValue, forKey: "locale")
        self.language = language
	}

	func getLanguage() {
		let languageCode: String = UserDefaults.standard.string(forKey: "locale") ?? Locale.preferredLanguages.first ?? "ENGLISH"
		self.language = Language(rawValue: languageCode) ?? .english
	}
}


enum Language: String, CaseIterable {
	case english = "ENGLISH"
	case korean = "KOREAN"
	case chinese = "CHINESE"
	case malaysia = "MALAYSIA"
	
	var localizedName: String {
		switch self {
		case .english:
			return "en"
		case .korean:
			return "kr"
		case .chinese:
			return "zh-Hans"
		case .malaysia:
			return  "ms"
		}
	}
	
	var name: String {
		switch self {
		case .english:
			return "English"
		case .korean:
			return "한국어"
		case .chinese:
			return "中国话"
		case .malaysia:
			return "Melayu"
		}
	}
}

