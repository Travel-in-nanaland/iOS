//
//  SearchService.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

struct SearchService {
	static func searchAllCategory(term: String) async -> OldBaseResponse<SearchAllArticleResponse>? {
		let response: OldBaseResponse<SearchAllCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchAllCategory(term: term))
		
		return mapSearchAllArticleToArticle(response)
	}
	
	static func searchNatureCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchNatureCategory(term: term, page: page))
		
		return mapSearchDetailArticleToArticle(response, category: .nature)
	}
	
	static func searchMarketCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchMarketCategory(term: term, page: page))
		
		return mapSearchDetailArticleToArticle(response, category: .market)
	}
	
	static func searchFestivalCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchFestivalCategory(term: term, page: page))
		
		return mapSearchDetailArticleToArticle(response, category: .festival)
	}
	
	static func searchExperienceCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchExperienceCategory(term: term, page: page))
		
		return mapSearchDetailArticleToArticle(response, category: .experience)
	}
	
	static func searchNanaCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchNanaCategory(term: term, page: page))
		
		return mapSearchDetailArticleToArticle(response, category: .nanaPick)
	}
    
    static func searchRestaurantCategory(term: String, page: Int) async -> OldBaseResponse<ArticleResponse>? {
        let response: OldBaseResponse<SearchDetailCategoryResponse>? = await NetworkManager.shared.request(SearchEndPoint.getSearchExperienceCategory(term: term, page: page))
        
        return mapSearchDetailArticleToArticle(response, category: .experience)
    }
    
	static func getPopularKeyword() async -> OldBaseResponse<[String]>? {
		return await NetworkManager.shared.request(SearchEndPoint.getPopularKeyword)
	}
	
	static func getVolumeUp() async -> OldBaseResponse<[Article]>? {
		return await NetworkManager.shared.request(SearchEndPoint.getVolumeUp)
	}
	
	
	// MARK: -  private func
	
	// 전체 검색 mapping
	static private func mapSearchAllArticleToArticle(_ response: OldBaseResponse<SearchAllCategoryResponse>?) -> OldBaseResponse<SearchAllArticleResponse>? {
		guard let response = response else {return nil}
		
		let festivalArticles = response.data.festival.data.map({
			return Article(from: $0, category: .festival)
		})
		
		let natureArticles = response.data.nature.data.map({
			return Article(from: $0, category: .nature)
		})
		
		let experienceArticles = response.data.experience.data.map({
			return Article(from: $0, category: .experience)
		})
		
		let marketArticles = response.data.market.data.map({
			return Article(from: $0, category: .market)
		})
        
        let restaurantArticles = response.data.restaurant.data.map({
            return Article(from: $0, category: .restaurant)
        })
        
        let nanaArticles = response.data.nana.data.map({
            return Article(from: $0, category: .nanaPick)
        })
        
		let articleResponse = SearchAllArticleResponse(
			festival: ArticleResponse(
				totalElements: response.data.festival.totalElements,
				data: festivalArticles
			),
			nature: ArticleResponse(
				totalElements: response.data.nature.totalElements,
				data: natureArticles
			),
			experience: ArticleResponse(
				totalElements: response.data.experience.totalElements,
				data: experienceArticles
			),
			market: ArticleResponse(
				totalElements: response.data.market.totalElements,
				data: marketArticles
			),
            nana: ArticleResponse (
                totalElements: response.data.nana.totalElements,
                data: nanaArticles
            ),
            restaurant: ArticleResponse(
                totalElements: response.data.restaurant.totalElements,
                data: restaurantArticles
            )
		)
		
		return OldBaseResponse(status: response.status, message: response.message, data: articleResponse)
	}
	
	// 카테고리 검색 mapping
	static private func mapSearchDetailArticleToArticle(_ response: OldBaseResponse<SearchDetailCategoryResponse>?, category: Category) -> OldBaseResponse<ArticleResponse>? {
		guard let response = response else {return nil}
		
		let articles = response.data.data.map({
			return Article(from: $0, category: category)
		})
		
		let articleResponse = ArticleResponse(totalElements: response.data.totalElements, data: articles)
		
		return OldBaseResponse(status: response.status, message: response.message, data: articleResponse)
	}
}
