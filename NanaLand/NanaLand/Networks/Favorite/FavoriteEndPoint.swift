//
//  FavoriteEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/22/24.
//

import Foundation
import Alamofire

enum FavoriteEndPoint {
	case toggleNature(id: Int)
	case toggleExperience(id: Int)
	case toggleMarket(id: Int)
	case toggleFestival(id: Int)
	case toggleNana(id: Int)
	case getAllFavoriteList(page: Int)
	case getNatureFavoriteList(page: Int)
	case getMarketFavoriteList(page: Int)
	case getFestivalFavoriteList(page: Int)
	case getExperienceFavoriteList(page: Int)
}

extension FavoriteEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)"
	}
	
	var path: String {
		switch self {
		case .toggleNature(let id):
			return "/nature/like/\(id)"
		case .toggleExperience(let id):
			return "/experience/like/\(id)"
		case .toggleMarket(let id):
			return "/market/like/\(id)"
		case .toggleFestival(let id):
			return "/festival/like/\(id)"
		case .toggleNana(let id):
			return "/nana/like/\(id)"
		case .getAllFavoriteList:
			return "/favorite/all/list"
		case .getNatureFavoriteList:
			return "/favorite/nature/list"
		case .getMarketFavoriteList:
			return "/favorite/market/list"
		case .getFestivalFavoriteList:
			return "/favorite/festival/list"
		case .getExperienceFavoriteList:
			return "/favorite/experience/list"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .toggleNature, .toggleExperience, .toggleMarket, .toggleFestival, .toggleNana:
			return .post
		case .getAllFavoriteList, .getNatureFavoriteList, .getMarketFavoriteList, .getFestivalFavoriteList, .getExperienceFavoriteList:
			return .get
		}
	}
	
	var task: APITask {
		switch self {
		case .toggleNature, .toggleExperience, .toggleMarket, .toggleFestival, .toggleNana:
			return .requestPlain
		case let .getAllFavoriteList(page: page):
			let param: [String: Any] = [
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getNatureFavoriteList(page: page):
			let param: [String: Any] = [
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getMarketFavoriteList(page: page):
			let param: [String: Any] = [
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getFestivalFavoriteList(page: page):
			let param: [String: Any] = [
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getExperienceFavoriteList(page: page):
			let param: [String: Any] = [
				"page": page
			]
			return .requestParameters(parameters: param)
		}
	}
	
	
}
