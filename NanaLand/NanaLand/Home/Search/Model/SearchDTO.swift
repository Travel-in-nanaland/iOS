//
//  SearchDTO.swift
//  NanaLand
//
//  Created by 정현우 on 4/18/24.
//

import Foundation

struct SearchDetailCategoryResponse: Codable {
	let count: Int
	var data: [Article]
	
	init(count: Int = 0, data: [Article] = []) {
		self.count = count
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
