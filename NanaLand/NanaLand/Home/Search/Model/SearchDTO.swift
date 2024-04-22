//
//  SearchDTO.swift
//  NanaLand
//
//  Created by 정현우 on 4/18/24.
//

import Foundation

struct SearchDetailCategoryResponse: Codable {
	let totalElements: Int
	var data: [Article]
	
	init(totalElements: Int = 0, data: [Article] = []) {
		self.totalElements = totalElements
		self.data = data
	}
}

struct SearchAllCategoryResponse: Codable {
	let festival: SearchDetailCategoryResponse
	let nature: SearchDetailCategoryResponse
	let experience: SearchDetailCategoryResponse
	let market: SearchDetailCategoryResponse
	
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
