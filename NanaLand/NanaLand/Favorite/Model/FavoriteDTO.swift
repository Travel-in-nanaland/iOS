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

struct FavoriteArticle: Codable, Hashable {
	let id: Int
	let title: String
	let thumbnailUrl: String
	let category: Category
	
	// 찜 리스트에서 제거를 위한 변수
	var isFavorite: Bool
	
	init(
		id: Int,
		title: String,
		thumbnailUrl: String,
		category: String,
		isFavorite: Bool = true
	) {
		self.id = id
		self.title = title
		self.thumbnailUrl = thumbnailUrl
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
		self.isFavorite = isFavorite
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
		self.thumbnailUrl = try container.decode(String.self, forKey: .thumbnailUrl)
		
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
		
		self.isFavorite = true
	}
	
//	var categoryType: Category = {
//		switch category {
//		case "NATURE":
//			return .nature
//		case "EXPERIENCE":
//			return .experience
//		case "FESTIVAL":
//			return .festival
//		case "MARKET":
//			return .market
//		default:
//			print("error in FavoriteArticle category mapping")
//			return .nature
//		}
//	}()
}
