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
    case getFilterSearchNatureCategory(term: String, page: Int, filterName: String) // 장소 필터 적용 자연
	case getSearchMarketCategory(term: String, page: Int)
    case getFilterSearchMarketCategory(term: String, page: Int, filterName: String) // 장소 필터 적용 전통시장
	case getSearchFestivalCategory(term: String, page: Int)
    case getFilterSearchFestivalCategory(term: String, page: Int, startDate: String, endDate: String) // 시간 필터 적용 축제
	case getSearchActivityCategory(term: String, page: Int)
    case getFilterSearchActivityCategory(term: String, page: Int, type: String, keyword: String, filterName: String) // 장소, 키워드 필터 적용 액티비티
    case getSearchCultureAndArtsCategory(term: String, page: Int)
    case getFilterSearchCultureAndArtsCategory(term: String, page: Int, type: String, keyword: String, filterName: String) // 장소, 키워드 필터 적용 문화예술
	case getSearchNanaCategory(term: String, page: Int)
    case getSearchRestaurantCategory(term: String, page: Int)
    case getFilterSearchRestaurantCategory(term: String, page: Int, keyword: String, filterName: String) // keyword -> keywordFilterlist, filterName -> addressFilterList
    
	
	// 인기 검색어 조회
	case getPopularKeyword
	
	// 검색량up
	case getVolumeUp
}

extension SearchEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/search"
	}
	
	var path: String {
		switch self {
		case .getSearchAllCategory:
			return "/all"
		case .getSearchNatureCategory:
			return "/nature"
        case .getFilterSearchNatureCategory:
            return "/nature"
		case .getSearchMarketCategory:
			return "/market"
        case .getFilterSearchMarketCategory:
            return "/market"
		case .getSearchFestivalCategory:
			return "/festival"
        case .getFilterSearchFestivalCategory:
            return "/festival"
		case .getSearchActivityCategory:
			return "/experience"
        case .getFilterSearchActivityCategory:
            return "/experience"
        case .getSearchCultureAndArtsCategory:
            return "/experience"
        case .getFilterSearchCultureAndArtsCategory:
            return "/experience"
		case .getSearchNanaCategory:
			return "/nana"
        case .getSearchRestaurantCategory:
            return "/restaurant"
        case .getFilterSearchRestaurantCategory:
            return "/restaurant"
		case .getPopularKeyword:
			return "/popular"
		case .getVolumeUp:
			return "/volume"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .getSearchAllCategory:
			return .get
		case .getSearchNatureCategory:
			return .get
        case .getFilterSearchNatureCategory:
            return .get
		case .getSearchMarketCategory:
			return .get
        case .getFilterSearchMarketCategory:
            return .get
		case .getSearchFestivalCategory:
			return .get
        case .getFilterSearchFestivalCategory:
            return .get
		case .getSearchActivityCategory:
			return .get
        case .getFilterSearchActivityCategory:
            return .get
        case .getSearchCultureAndArtsCategory:
            return .get
        case .getFilterSearchCultureAndArtsCategory:
            return .get
		case .getSearchNanaCategory:
			return .get
        case .getSearchRestaurantCategory:
            return .get
        case .getFilterSearchRestaurantCategory:
            return .get
		case .getPopularKeyword:
			return .get
		case .getVolumeUp:
			return .get
		}
	}
	
	var task: APITask {
		switch self {
		case let .getSearchAllCategory(term):
            let param: [String: Any] = [
                "keyword": term
            ]
			return .requestParameters(parameters: param)
		case let .getSearchNatureCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
        case let .getFilterSearchNatureCategory(term: term, page: page, filterName: filterName):
            let param: [String: Any] = [
                "keyword": term,
                "page": page,
                "addressFilterList": filterName
            ]
            return .requestParameters(parameters: param)
		case let .getSearchMarketCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
        case let .getFilterSearchMarketCategory(term: term, page: page, filterName: filterName):
            let param: [String: Any] = [
                "keyword": term,
                "page": page,
                "addressFilterList": filterName
            ]
            return .requestParameters(parameters: param)
		case let .getSearchFestivalCategory(term: term, page: page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
        case let.getFilterSearchFestivalCategory(term: term, page: page, startDate: startDate, endDate: endDate):
            let param: [String: Any] = [
                "keyword": term,
                "page": page,
                "startDate": startDate,
                "endDate": endDate
            ]
            return .requestParameters(parameters: param)
		case let .getSearchActivityCategory(term: term, page: page):
			let param: [String: Any] = [
                "experienceType": "ACTIVITY",
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
        case let .getFilterSearchActivityCategory(term: term, page: page, type: type, keyword: keyword, filterName):
            let param: [String: Any] = [
                "experienceType": "ACTIVITY", // activity, culture
                "keyword": term, // 검색어
                "page": page, // 페이지
                "keywordFilterList": keyword, // 액티비티 키워드 리스트
                "addressFilterList": filterName // 액티비티 지역 리스트
            ]
            return .requestParameters(parameters: param)
        case let .getSearchCultureAndArtsCategory(term: term, page: page):
            let param: [String: Any] = [
                "experienceType": "CULTURE_AND_ARTS",
                "keyword": term,
                "page": page
            ]
            return .requestParameters(parameters: param)
        case let .getFilterSearchCultureAndArtsCategory(term: term, page: page, type: type, keyword: keyword, filterName):
            let param: [String: Any] = [
                "experienceType": "CULTURE_AND_ARTS", // activity, culture
                "keyword": term, // 검색어
                "page": page, // 페이지
                "keywordFilterList": keyword, // 문화예술 키워드 리스트
                "addressFilterList": filterName // 문화예술 지역 리스트
            ]
            return .requestParameters(parameters: param)
		case let .getSearchNanaCategory(term, page):
			let param: [String: Any] = [
				"keyword": term,
				"page": page
			]
			return .requestParameters(parameters: param)
        case let .getSearchRestaurantCategory(term: term, page: page):
            let param: [String: Any] = [
                "keyword": term,
                "page": page
            ]
            return .requestParameters(parameters: param)
        case let .getFilterSearchRestaurantCategory(term: term, page: page, keyword: keyword, filterName: filterName):
            let param: [String: Any] = [
                "keyword": term,
                "keywordFilter": keyword, // 맛집 키워드 리스트
                "addressFilterList": filterName, // 맛집 지역 리스트
                "page": page
            ]
            return .requestParameters(parameters: param)
		case .getPopularKeyword:
			return .requestPlain
		case .getVolumeUp:
			return .requestPlain
		}
	}
	
}
