//
//  SearchEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

enum SearchEndPoint {
	case getSearchAllCategory(term: String)
	case getSearchNatureCategory(term: String, page: Int)
	case getSearchMarketCategory(term: String, page: Int)
	case getSearchFestivalCategory(term: String, page: Int)
	case getSearchExperienceCategory(term: String, page: Int)
}

extension SearchEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/search"
	}
	
	var path: String {
		switch self {
		case .getSearchAllCategory:
			return "/category"
		case .getSearchNatureCategory:
			return "/nature"
		case .getSearchMarketCategory:
			return "/market"
		case .getSearchFestivalCategory:
			return "/festival"
		case .getSearchExperienceCategory:
			return "/experience"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .getSearchAllCategory:
			return .get
		case .getSearchNatureCategory:
			return .get
		case .getSearchMarketCategory:
			return .get
		case .getSearchFestivalCategory:
			return .get
		case .getSearchExperienceCategory:
			return .get
		}
	}
	
	var task: APITask {
		switch self {
		case let .getSearchAllCategory(term):
			let param = ["keyword": term]
			return .requestParameters(parameters: param)
		case let .getSearchNatureCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getSearchMarketCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getSearchFestivalCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
		case let .getSearchExperienceCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
		}
	}
	
}
