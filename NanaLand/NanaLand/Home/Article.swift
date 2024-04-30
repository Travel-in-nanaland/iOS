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

struct ArticleWithCategory: Codable, Hashable {
	let id: Int
	let thumbnailUrl: String
	let title: String
	var favorite: Bool
	let category: Category
	
	init(
		id: Int,
		thumbnailUrl: String,
		title: String,
		favorite: Bool,
		category: String
	) {
		self.id = id
		self.thumbnailUrl = thumbnailUrl
		self.title = title
		self.favorite = favorite
		self.category = {
			switch category {
			case "NATURE":
				return .nature
			case "EXPERIENCE":
				return .experience
			case "FESTIVAL":
				return .festival
			case "MARKET":
				return .market
			default:
				print("error in FavoriteArticle category mapping")
				return .nature
			}
		}()
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
		self.favorite = try container.decode(Bool.self, forKey: .favorite)
		
		let categoryString = try container.decode(String.self, forKey: .category)
		self.category =  {
			switch categoryString {
			case "NATURE":
				return .nature
			case "EXPERIENCE":
				return .experience
			case "FESTIVAL":
				return .festival
			case "MARKET":
				return .market
			default:
				print("error in FavoriteArticle category mapping")
				return .nature
			}
		}()
	}
}
