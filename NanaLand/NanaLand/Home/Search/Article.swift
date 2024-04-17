//
//  Article.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import Foundation

struct Article: Codable {
	let id: Int
	let thumbnailUrl: String
	let title: String
}

struct ArticlesWithCount: Codable {
	let count: Int
	let data: [Article]
}

struct BaseResponse<T: Codable>: Codable {
	let status: Int
	let message: String
	let data: T
}

struct SearchAllCategoryResponse: Codable {
	let festival: ArticlesWithCount
	let nature: ArticlesWithCount
	let experience: ArticlesWithCount
	let market: ArticlesWithCount
}
