//
//  SearchEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

enum SearchEndPoint {
	// 전체 검색
	case getSearchAllCategory(term: String)
	
	// 각 카테고리 별 검색
	case getSearchNatureCategory(term: String, page: Int)
	case getSearchMarketCategory(term: String, page: Int)
	case getSearchFestivalCategory(term: String, page: Int)
	case getSearchExperienceCategory(term: String, page: Int)
	
	// 인기 검색어 조회
	case getPopularKeyword
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
		case .getPopularKeyword:
			return "/popular"
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
		case .getPopularKeyword:
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
		case .getPopularKeyword:
			return .requestPlain
		}
	}
	
}