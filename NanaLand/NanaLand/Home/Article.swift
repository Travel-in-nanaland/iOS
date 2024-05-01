//
//  Article.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import Foundation

struct Article: Codable, Hashable {
	let id: Int
	let thumbnailUrl: String
	let title: String
	var favorite: Bool
}
