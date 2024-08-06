//
//  RestaurantEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
import Alamofire

enum RestaurantEndPoint {
    case getRestaurantMainItem(keyword: String, address: String, page: Int, size: Int) // 메인 아이템 조회
    case getRestaurantDetailItem(id: Int64, isSearch: Bool) // 상세 조회
}

extension RestaurantEndPoint: EndPoint {
    var baseURL: String {
        // MVP2 테스트용 포트번호 8083
        return "http://13.125.110.80:8083/restaurant"
    }
    
    var path: String {
        switch self {
        case .getRestaurantMainItem:
            return "/list"
        case .getRestaurantDetailItem(let id, _):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRestaurantMainItem:
            return .get
        case .getRestaurantDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getRestaurantMainItem(keyword, address, page, size):
            let param = ["keywordFilter": keyword, "addressFilterList": address, "page": page, "size": size] as [String: Any]
            return .requestParameters(parameters: param)
            
        case let .getRestaurantDetailItem(_, isSearch):
            let param = ["isSearch": isSearch] as [String: Any]
            return .requestParameters(parameters: param)
        }
    }
}
