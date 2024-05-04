//
//  FavoriteService.swift
//  NanaLand
//
//  Created by 정현우 on 4/23/24.
//

import Foundation
import Alamofire

struct FavoriteService {
	static func toggleFavorite(id: Int, category: Category) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleFavorite(body: FavoriteToggleRequest(id: id, category: category)))
	}
	
	static func getAllFavoriteList(page: Int) async -> BaseResponse<FavoriteListResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.getAllFavoriteList(page: page))
	}
	
	static func getNatureFavoriteList(page: Int) async -> BaseResponse<FavoriteListResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.getNatureFavoriteList(page: page))
	}
	
	static func getMarketFavoriteList(page: Int) async -> BaseResponse<FavoriteListResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.getMarketFavoriteList(page: page))
	}
	
	static func getFestivalFavoriteList(page: Int) async -> BaseResponse<FavoriteListResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.getFestivalFavoriteList(page: page))
	}
	
	static func getExperienceFavoriteList(page: Int) async -> BaseResponse<FavoriteListResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.getExperienceFavoriteList(page: page))
	}
}
