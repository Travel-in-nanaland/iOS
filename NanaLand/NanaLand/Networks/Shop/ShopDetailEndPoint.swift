//
//  ShopDetailEndPoint.swift
//  NanaLand
//
//  Created by jun on 4/29/24.
//

import Foundation
import Alamofire

enum ShopDetailEndPoint {
    case getShopDetailItem(id: Int64)
}

extension ShopDetailEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/market"
    }
    
    var path: String {
        switch self {
        case .getShopDetailItem(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getShopDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getShopDetailItem(_):
            
            return .requestPlain
        }
    }
}
