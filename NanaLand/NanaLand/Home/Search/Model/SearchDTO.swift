//
//  SearchDTO.swift
//  NanaLand
//
//  Created by 정현우 on 4/18/24.
//

import Foundation

struct SearchDetailCategoryResponse: Codable {
	let totalElements: Int
	var data: [SearchArticle]
	
	init(totalElements: Int = 0, data: [SearchArticle] = []) {
		self.totalElements = totalElements
		self.data = data
	}
}

struct SearchArticle: Codable {
	let id: Int
	let thumbnailUrl: String
	let title: String
	var favorite: Bool
}

struct SearchAllCategoryResponse: Codable {
	var festival: SearchDetailCategoryResponse
	var nature: SearchDetailCategoryResponse
	var experience: SearchDetailCategoryResponse
	var market: SearchDetailCategoryResponse
	
	init(
		festival: SearchDetailCategoryResponse = SearchDetailCategoryResponse(),
		nature: SearchDetailCategoryResponse = SearchDetailCategoryResponse(),
		experience: SearchDetailCategoryResponse = SearchDetailCategoryResponse(),
		market: SearchDetailCategoryResponse = SearchDetailCategoryResponse()
	) {
		self.festival = festival
		self.nature = nature
		self.experience = experience
		self.market = market
	}
}
