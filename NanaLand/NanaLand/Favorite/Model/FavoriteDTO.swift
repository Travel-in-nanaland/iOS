//
//  FavoriteDTO.swift
//  NanaLand
//
//  Created by 정현우 on 4/23/24.
//

import Foundation

struct ToggleFavoriteResponse: Codable {
	let favorite: Bool
}

struct FavoriteListResponse: Codable {
	var totalElements: Int
	var data: [FavoriteArticle]
	
	init(totalElements: Int = 0, data: [FavoriteArticle] = []) {
		self.totalElements = totalElements
		self.data = data
	}
}

struct FavoriteToggleRequest: Codable {
	let id: Int
	let category: String
	
	init(id: Int, category: Category) {
		self.id = id
		self.category = category.uppercase
	}
}

struct FavoriteArticle: Codable {
	let id: Int
	let title: String
	let firstImage: ArticleImageList
	let category: Category
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.firstImage = try container.decode(ArticleImageList.self, forKey: .firstImage)
		
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
            case "RESTAURANT":
                return .restaurant
            case "NANA":
                return .nanaPick
			default:
				print("error in FavoriteArticle category mapping")
				return .nature
			}
		}()
	}
}
