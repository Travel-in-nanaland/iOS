//
//  FavoriteEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/22/24.
//

import Foundation
import Alamofire

enum FavoriteEndPoint {
	case toggleFavorite(body: FavoriteToggleRequest)
	case getAllFavoriteList(page: Int)
	case getNatureFavoriteList(page: Int)
	case getMarketFavoriteList(page: Int)
	case getFestivalFavoriteList(page: Int)
	case getExperienceFavoriteList(page: Int)
}

extension FavoriteEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/favorite"
	}
	
	var path: String {
		switch self {
		case let .toggleFavorite(body):
			return "/like/\(body.id)"
		case .getAllFavoriteList:
			return "/all/list"
		case .getNatureFavoriteList:
			return "/nature/list"
		case .getMarketFavoriteList:
			return "/market/list"
		case .getFestivalFavoriteList:
			return "/festival/list"
		case .getExperienceFavoriteList:
			return "/experience/list"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .toggleFavorite:
			return .post
		case .getAllFavoriteList, .getNatureFavoriteList, .getMarketFavoriteList, .getFestivalFavoriteList, .getExperienceFavoriteList:
			return .get
		}
	}
	
	var task: APITask {
		switch self {
		case let .toggleFavorite(body: body):
			return .requestJSONEncodable(body: body)
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