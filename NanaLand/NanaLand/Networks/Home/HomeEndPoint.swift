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
}

extension HomeEndPoint: EndPoint {
    var baseURL: String {
        switch self {
        case .getBannerData:
            return "\(Secrets.baseUrl)/nana"
        case .getRecommendData:
            return "\(Secrets.baseUrl)/member"
        }
    }
    
    var path: String {
        switch self {
        case .getBannerData:
            return ""
        case .getRecommendData:
            return "/recommended/random"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getBannerData:
            return .get
        case .getRecommendData:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json", "Authorization": "Bearer " + "\(KeyChainManager.readItem(key: "accessToken")!)"]
    }
    
    var task: APITask {
        switch self {
        case .getBannerData:
            return .requestPlain
        case .getRecommendData:
            return .requestPlain
        }
        
    }
}
