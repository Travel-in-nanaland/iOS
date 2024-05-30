//
//  ProfileMainModel.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation

struct ProfileMainModel: Codable {
	let consentItems: [ConsentItem]
    let email: String
    let provider: String
    var profileImageUrl: String
    var nickname: String
    var description: String
    let level: Int
    var travelType: String?
    let hashtags: [String]
	
	init(
		consentItems: [ConsentItem] = [],
		email: String = "",
		provider: String = "",
		profileImageUrl: String = "",
		nickname: String = "",
		description: String = "",
		level: Int = 0,
		travelType: String? = nil,
		hashtags: [String] = []
	) {
		self.consentItems = consentItems
		self.email = email
		self.provider = provider
		self.profileImageUrl = profileImageUrl
		self.nickname = nickname
		self.description = description
		self.level = level
		self.travelType = travelType
		self.hashtags = hashtags
	}
}
