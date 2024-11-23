//
//  HomeEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/24/24.
//

import Foundation
import Alamofire

enum HomeEndPoint {
    // 배너 데이터 받아오기
    case getBannerData
    // 추천 게시물 2개 데이터 받아오기
    case getRecommendData
	// 타입 테스트 후 추천 게시물 2개
	case getRecommendDataInTypeTest
    // 인기있는 게시물 받아오기
    case getHotItem
}

extension HomeEndPoint: EndPoint {
    var baseURL: String {
        switch self {
        case .getBannerData:
            return "\(Secrets.baseUrl)/nana"
        case .getRecommendData, .getRecommendDataInTypeTest, .getHotItem:
            return "\(Secrets.baseUrl)/member"
        }
    }
    
    var path: String {
        switch self {
        case .getBannerData:
            return ""
        case .getRecommendData:
            return "/recommended/random"
		case .getRecommendDataInTypeTest:
			return "/recommended"
        case .getHotItem:
            return "/hot"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBannerData:
            return .get
        case .getRecommendData:
            return .get
		case .getRecommendDataInTypeTest:
			return .get
        case .getHotItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getBannerData:
            return .requestPlain
        case .getRecommendData:
            return .requestPlain
		case .getRecommendDataInTypeTest:
			return .requestPlain
        case .getHotItem:
            return .requestPlain
        }
        
    }
}
