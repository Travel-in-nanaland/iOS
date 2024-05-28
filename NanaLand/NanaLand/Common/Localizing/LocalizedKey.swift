//
//  LocalizedKey.swift
//  NanaLand
//
//  Created by 정현우 on 5/27/24.
//

import Foundation

enum LocalizedKey: String {
	//MARK: - Common
	case resultCount
	case charCount
	case confirm
	case requiredWithBracket
	case optionalWithBracket
	
	//MARK: - Tab
	case home
	case favorite
	case jejuStory
	case myNana
	
	//MARK: - Category
	case all
	case nature
	case festival
	case market
	case experience
	case nanaPick
	
	
	//MARK: - Search
	case inputSearchTerm
	case recentSearchTerm
	case removeAll
	case popularSearchTerm
	case searchVolumeUp
	case noResult
	
	//MARK: - Login/Register
	case nonMemeberLogin
	case welcomeToNanaLand
	case enterNicknameAndProfile
	
	//MARK: - Terms
	case allAgree
	case termsOfUseAgree
	case marketingAgree
	case locationAgree
	
	//MARK: - Error/Alert
	case duplicatedNickname
	case invalidNickname
	case onlyCharSpaceNumberNickname
	
	
	//MARK: - localized()
	func localized(for language: Language) -> String {
		guard let path = Bundle.main.path(forResource: language.localizedName, ofType: "lproj"),
			  let bundle = Bundle(path: path) else {
			return NSLocalizedString(self.rawValue, comment: "")
		}
		return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
	}
	
	static func + (lhs: LocalizedKey, rhs: LocalizedKey) -> String {
		let leftLocalizedString = lhs.localized(for: LocalizationManager.shared.language)
		let rightLocalizedString = rhs.localized(for: LocalizationManager.shared.language)
		return leftLocalizedString + rightLocalizedString
	}

	static func + (lhs: String, rhs: LocalizedKey) -> String {
		let localizedString = rhs.localized(for: LocalizationManager.shared.language)
		return lhs + localizedString
	}

	static func + (lhs: LocalizedKey, rhs: String) -> String {
		let localizedString = lhs.localized(for: LocalizationManager.shared.language)
		return localizedString + rhs
	}
}
