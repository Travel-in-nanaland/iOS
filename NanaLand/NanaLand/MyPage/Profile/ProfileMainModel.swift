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
    let reviews: [Review]
    let notices: [Notice]
	
	init(
		consentItems: [ConsentItem] = [],
		email: String = "",
		provider: String = "",
		profileImageUrl: String = "",
		nickname: String = "",
		description: String = "",
		level: Int = 0,
		travelType: String? = nil,
		hashtags: [String] = [],
        reviews: [Review] = [Review(id: 1, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트입니다.", createdAt: "2024-06-12", heartCount: 3, images: ["" : ""], reviewTypeKeywords: [])],
        notices: [Notice] = [Notice(id: 1, type: "공지사항", imageUrl: "", title: "테스트", date: "2024.06.12", content: "내용")]
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
        self.reviews = reviews
        self.notices = notices
	}
    
    struct Review: Codable {
        let id: Int64
        let postId: Int64
        let category: String
        let placeName: String
        let rating: Int
        let content: String
        let createdAt: String
        let heartCount: Int
        let images: [String: String]
        let reviewTypeKeywords: [String]
    }
    
    struct Notice: Codable {
        let id: Int64
        let type: String
        let imageUrl: String
        let title: String
        let date: String
        let content: String
    }
}
