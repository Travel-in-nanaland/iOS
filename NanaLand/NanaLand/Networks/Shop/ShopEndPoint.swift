//
//  ShopEndPoint.swift
//  NanaLand
//
//  Created by jun on 4/26/24.
//

import Foundation
import Alamofire

enum ShopEndPoint {
    case getShopMainItem(page: Int64, size: Int64, filterName: String)
}

extension ShopEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/market"
    }
    
    var path: String {
        switch self {
        case .getShopMainItem:
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getShopMainItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getShopMainItem(page, size, filterName):
            let param = ["addressFilterList": filterName, "page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        }
    }
}
