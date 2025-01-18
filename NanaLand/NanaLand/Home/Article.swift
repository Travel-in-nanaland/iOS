//
//  Article.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import Foundation

struct Article: Codable {
    
	let id: Int
	let firstImage: ArticleImageList
	let title: String
	var favorite: Bool?
	var category: Category
    let onGoing: Bool?
	
	init(
		id: Int,
        firstImage: ArticleImageList,
		title: String,
		favorite: Bool?,
		category: Category,
        onGoing: Bool?
	) {
		self.id = id
		self.firstImage = firstImage
		self.title = title
		self.favorite = favorite
		self.category = category
        self.onGoing = onGoing
	}
	
	init(from favoriteArticle: FavoriteArticle) {
		self.id = favoriteArticle.id
        self.firstImage = favoriteArticle.firstImage
		self.title = favoriteArticle.title
		self.favorite = true
		self.category = favoriteArticle.category
        self.onGoing = favoriteArticle.onGoing
	}
	
	init(from searchArticle: SearchArticle, category: Category) {
		self.id = searchArticle.id
        self.firstImage = searchArticle.firstImage
		self.title = searchArticle.title
		self.favorite = searchArticle.favorite
		self.category = category
        self.onGoing = searchArticle.onGoing
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int.self, forKey: .id)
		self.title = try container.decode(String.self, forKey: .title)
        self.firstImage = try container.decode(ArticleImageList.self, forKey: .firstImage)
		self.favorite = try container.decodeIfPresent(Bool.self, forKey: .favorite)
        self.onGoing = try container.decodeIfPresent(Bool.self, forKey: .onGoing) // 선택적으로 디코드
		
		let categoryString = try container.decode(String.self, forKey: .category)
		self.category =  {
			switch categoryString {
			case "NATURE":
				return .nature
			case "ACTIVITY":
				return .activity
            case "CULTURE_AND_ARTS":
                return .cultureAndArts
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
	var activity: ArticleResponse
    var cultureAndArts: ArticleResponse
	var market: ArticleResponse
	var nana: ArticleResponse
    var restaurant: ArticleResponse
	
	init(
		festival: ArticleResponse = ArticleResponse(),
		nature: ArticleResponse = ArticleResponse(),
        activity: ArticleResponse = ArticleResponse(),
        cultureAndArts: ArticleResponse = ArticleResponse(),
		market: ArticleResponse = ArticleResponse(),
		nana: ArticleResponse = ArticleResponse(),
        restaurant: ArticleResponse = ArticleResponse()
	) {
		self.festival = festival
		self.nature = nature
		self.activity = activity
        self.cultureAndArts = cultureAndArts
		self.market = market
		self.nana = nana
        self.restaurant = restaurant
	}
}

struct ArticleImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
