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


	func setLanguage(_ language: Language) async {
		UserDefaults.standard.set(language.rawValue, forKey: "locale")
		let response = await UserInfoService.patchUserLanguage(body: PatchUserLanguageRequest(locale: language.rawValue))
		if response?.status == 200 {
			print("언어 변경 - \(language.rawValue)")
			await MainActor.run {
				self.language = language
			}
		} else {
			print("언어 변경 에러")
		}
	}

	func getLanguage() {
		let languageCode: String = UserDefaults.standard.string(forKey: "locale") ?? Locale.preferredLanguages.first ?? "ENGLISH"
		self.language = Language(rawValue: languageCode) ?? .english
	}
}


enum Language: String, CaseIterable {
	case english = "ENGLISH"
    case chinese = "CHINESE"
	case malaysia = "MALAYSIA"
    case vietnam = "VIETNAMESE"
    case korean = "KOREAN"
	
	init?(deeplinkName: String) {
		switch deeplinkName {
		case "en":
			self = .english
		case "ko":
			self = .korean
		case "zh":
			self = .chinese
		case "ms":
			self = .malaysia
        case "vi":
            self = .vietnam
		default:
			return nil
		}
	}
	
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
        case .vietnam:
            return "vi"
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
        case .vietnam:
            return "Tiếng Việt"
		}
	}
	
	// 딥링크에서 사용하는 언어 이름
	var deeplinkName: String {
		switch self {
		case .english:
			return "en"
		case .korean:
			return "ko"
		case .chinese:
			return "zh"
		case .malaysia:
			return  "ms"
        case .vietnam:
            return "vi"
		}
	}
}
