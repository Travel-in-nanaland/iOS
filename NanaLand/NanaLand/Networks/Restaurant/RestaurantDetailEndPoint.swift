//
//  RestaurantDetailEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
import Alamofire

enum RestaurantDetailEndPoint {
    case getRestaurantDetailItem(id: Int64)
}

extension RestaurantDetailEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nature"
    }
    
    var path: String {
        switch self {
        case .getRestaurantDetailItem(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRestaurantDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getRestaurantDetailItem(_):
            return .requestPlain
        }
    }
}
