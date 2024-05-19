//
//  FavoriteService.swift
//  NanaLand
//
//  Created by 정현우 on 4/23/24.
//

import Foundation
import Alamofire

struct FavoriteService {
	static func toggleFavorite(id: Int, category: Category) async -> OldBaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleFavorite(body: FavoriteToggleRequest(id: id, category: category)))
	}
	
	static func getAllFavoriteList(page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<FavoriteListResponse>? = await NetworkManager.shared.request(FavoriteEndPoint.getAllFavoriteList(page: page))
		
		return mapFavoriteArticleToArticle(response)
	}
	
	static func getNatureFavoriteList(page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<FavoriteListResponse>? = await NetworkManager.shared.request(FavoriteEndPoint.getNatureFavoriteList(page: page))
		
		return mapFavoriteArticleToArticle(response)
	}
	
	static func getMarketFavoriteList(page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<FavoriteListResponse>? = await NetworkManager.shared.request(FavoriteEndPoint.getMarketFavoriteList(page: page))
		
		return mapFavoriteArticleToArticle(response)
	}
	
	static func getFestivalFavoriteList(page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<FavoriteListResponse>? = await NetworkManager.shared.request(FavoriteEndPoint.getFestivalFavoriteList(page: page))
		
		return mapFavoriteArticleToArticle(response)
	}
	
	static func getExperienceFavoriteList(page: Int) async -> OldBaseResponse<ArticleResponse>? {
		let response: OldBaseResponse<FavoriteListResponse>? = await NetworkManager.shared.request(FavoriteEndPoint.getExperienceFavoriteList(page: page))
		
		return mapFavoriteArticleToArticle(response)
	}
	
	// MARK: -  private func
	static private func mapFavoriteArticleToArticle(_ response: OldBaseResponse<FavoriteListResponse>?) -> OldBaseResponse<ArticleResponse>? {
		guard let response = response else {return nil}
		
		let articles = response.data.data.map {
			return Article(from: $0)
		}
		
		
		
		let articleResponse = ArticleResponse(totalElements: response.data.totalElements, data: articles)
		
		return OldBaseResponse(status: response.status, message: response.message, data: articleResponse)
	}
}
