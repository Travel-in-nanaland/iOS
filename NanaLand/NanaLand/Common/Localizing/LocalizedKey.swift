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
	case next
	case requiredWithBracket
	case optionalWithBracket
	case destination
	case gotoMainScreen
	
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
	
	//MARK: - TypeTest
	case skipTypeTest
	// Question
	// First Question, First Line
	case typeTest1Q1L
	case typeTest1Q2L
	case typeTest2Q1L
	case typeTest2Q2L
	case typeTest3Q1L
	case typeTest3Q2L
	case typeTest4Q1L
	case typeTest4Q2L
	case typeTest5Q1L
	case typeTest5Q2L
	// Answer
	case touristSpot
	case localSpot
	case flexible
	case organized
	case budgetTravel
	case luxuryTravel
	case photoRemain
	case captureWithEyes
	case sentimentalPlace
	case traditionalCulture
	case naturalScenery
	case themePark
	// Result
	case your
	case yourPreference
	case yourTravelStyle
	case tangerineJuiced
	case juiceCommingSoon
	case yourTravelStyleIs
	// Type
	case GAMGYUL_ICECREAM
	case GAMGYUL_ICECREAM_DESCRIPTION
	case GAMGYUL_RICECAKE
	case GAMGYUL_RICECAKE_DESCRIPTION
	case GAMGYUL
	case GAMGYUL_DESCRIPTION
	case GAMGYUL_CIDER
	case GAMGYUL_CIDER_DESCRIPTION
	case GAMGYUL_AFFOKATO
	case GAMGYUL_AFFOKATO_DESCRIPTION
	case GAMGYUL_HANGWA
	case GAMGYUL_HANGWA_DESCRIPTION
	case GAMGYUL_JUICE
	case GAMGYUL_JUICE_DESCRIPTION
	case GAMGYUL_CHOCOLATE
	case GAMGYUL_CHOCOLATE_DESCRIPTION
	case GAMGYUL_COCKTAIL
	case GAMGYUL_COCKTAIL_DESCRIPTION
	case TANGERINE_PEEL_TEA
	case TANGERINE_PEEL_TEA_DESCRIPTION
	case GAMGYUL_YOGURT
	case GAMGYUL_YOGURT_DESCRIPTION
	case GAMGYUL_FLATCCINO
	case GAMGYUL_FLATCCINO_DESCRIPTION
	case GAMGYUL_LATTE
	case GAMGYUL_LATTE_DESCRIPTION
	case GAMGYUL_SIKHYE
	case GAMGYUL_SIKHYE_DESCRIPTION
	case GAMGYUL_ADE
	case GAMGYUL_ADE_DESCRIPTION
	case GAMGYUL_BUBBLE_TEA
	case GAMGYUL_BUBBLE_TEA_DESCRIPTION
	case nanalandMadeYouJuice
	
	
	
	//MARK: - localized()
	func localized(for language: Language) -> String {
		guard let path = Bundle.main.path(forResource: language.localizedName, ofType: "lproj"),
			  let bundle = Bundle(path: path) else {
			return NSLocalizedString(self.rawValue, comment: "")
		}
		return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
	}

	func localized(for language: Language, _ arguments: [CVarArg]) -> String {
			let format = localized(for: language)
			return String(format: format, arguments: arguments)
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
