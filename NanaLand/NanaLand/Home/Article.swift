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
	let category: Category
	
	init(
		id: Int,
		thumbnailUrl: String,
		title: String,
		favorite: Bool,
		category: Category
	) {
		self.id = id
		self.thumbnailUrl = thumbnailUrl
		self.title = title
		self.favorite = favorite
		self.category = category
	}
	
	init(from favoriteArticle: FavoriteArticle) {
		self.id = favoriteArticle.id
		self.thumbnailUrl = favoriteArticle.thumbnailUrl
		self.title = favoriteArticle.title
		self.favorite = true
		self.category = favoriteArticle.category
	}
	
	init(from searchArticle: SearchArticle, category: Category) {
		self.id = searchArticle.id
		self.thumbnailUrl = searchArticle.thumbnailUrl
		self.title = searchArticle.title
		self.favorite = searchArticle.favorite
		self.category = category
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
            case "RESTAURANT":
                return .restaurant
			default:
				print("error in Article category mapping")
				return .nature
			}
		}()
	}
}

struct ArticleResponse: Codable {
	var totalElements: Int
	var data: [Article]
	
	init(totalElements: Int = 0, data: [Article] = []) {
		self.totalElements = totalElements
		self.data = data
	}
}

struct SearchAllArticleResponse: Codable {
	var festival: ArticleResponse
	var nature: ArticleResponse
	var experience: ArticleResponse
	var market: ArticleResponse
	var nana: ArticleResponse
    var restaurant: ArticleResponse
	
	init(
		festival: ArticleResponse = ArticleResponse(),
		nature: ArticleResponse = ArticleResponse(),
		experience: ArticleResponse = ArticleResponse(),
		market: ArticleResponse = ArticleResponse(),
		nana: ArticleResponse = ArticleResponse(),
        restaurant: ArticleResponse = ArticleResponse()
	) {
		self.festival = festival
		self.nature = nature
		self.experience = experience
		self.market = market
		self.nana = nana
        self.restaurant = restaurant
	}
}
