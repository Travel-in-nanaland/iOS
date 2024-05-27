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
	
	//MARK: - localized()
	func localized(for language: Language) -> String {
		guard let path = Bundle.main.path(forResource: language.localizedName, ofType: "lproj"),
			  let bundle = Bundle(path: path) else {
			return NSLocalizedString(self.rawValue, comment: "")
		}
		return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
	}
}
