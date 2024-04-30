//
//  SearchService.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

struct SearchService {
	static func searchAllCategory(term: String) async -> BaseResponse<SearchAllCategoryResponse>? {
		return await NetworkManager.shared.request(SearchEndPoint.getSearchAllCategory(term: term))
	}
	
	static func searchNatureCategory(term: String, page: Int) async -> BaseResponse<SearchDetailCategoryResponse>? {
		return await NetworkManager.shared.request(SearchEndPoint.getSearchNatureCategory(term: term, page: page))
	}
	
	static func searchMarketCategory(term: String, page: Int) async -> BaseResponse<SearchDetailCategoryResponse>? {
		return await NetworkManager.shared.request(SearchEndPoint.getSearchMarketCategory(term: term, page: page))
	}
	
	static func searchFestivalCategory(term: String, page: Int) async -> BaseResponse<SearchDetailCategoryResponse>? {
		return await NetworkManager.shared.request(SearchEndPoint.getSearchFestivalCategory(term: term, page: page))
	}
	
	static func searchExperienceCategory(term: String, page: Int) async -> BaseResponse<SearchDetailCategoryResponse>? {
		return await NetworkManager.shared.request(SearchEndPoint.getSearchExperienceCategory(term: term, page: page))
	}
	
	static func getPopularKeyword() async -> BaseResponse<[String]>? {
		return await NetworkManager.shared.request(SearchEndPoint.getPopularKeyword)
	}
	
	static func getVolumeUp() async -> BaseResponse<[ArticleWithCategory]>? {
		return await NetworkManager.shared.request(SearchEndPoint.getVolumeUp)
	}
}
