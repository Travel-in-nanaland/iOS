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
    var profileImage: ProfileDetailImagesList
    var nickname: String
    var description: String
    var travelType: String?
    var hashtags: [String]
    let myProfile: Bool
	
	init(
		consentItems: [ConsentItem] = [],
		email: String = "",
		provider: String = "",
        profileImage: ProfileDetailImagesList = ProfileDetailImagesList(originUrl: "", thumbnailUrl: ""),
		nickname: String = "",
		description: String = "",
		travelType: String? = nil,
		hashtags: [String] = [],
        myProfile: Bool = true
	) {
		self.consentItems = consentItems
		self.email = email
		self.provider = provider
		self.profileImage = profileImage
		self.nickname = nickname
		self.description = description
		self.travelType = travelType
		self.hashtags = hashtags
        self.myProfile = myProfile
	}
}

struct ProfileDetailImagesList: Codable {
    var originUrl: String
    var thumbnailUrl: String
}
