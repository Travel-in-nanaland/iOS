//
//  FavoriteService.swift
//  NanaLand
//
//  Created by 정현우 on 4/23/24.
//

import Foundation
import Alamofire

struct FavoriteService {
	static func toggleFavoriteNature(id: Int) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleNature(id: id))
	}
	
	static func toggleFavoriteExperience(id: Int) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleExperience(id: id))
	}
	
	static func toggleFavoriteMarket(id: Int) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleMarket(id: id))
	}
	
	static func toggleFavoriteFestival(id: Int) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleFestival(id: id))
	}
	
	static func toggleFavoriteNana(id: Int) async -> BaseResponse<ToggleFavoriteResponse>? {
		return await NetworkManager.shared.request(FavoriteEndPoint.toggleNana(id: id))
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
