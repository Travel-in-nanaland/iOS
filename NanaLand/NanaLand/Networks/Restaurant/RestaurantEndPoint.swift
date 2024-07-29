//
//  RestaurantEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
import Alamofire

enum RestaurantEndPoint {
    case getRestaurantMainItem(page: Int64, size: Int64, filterName: String)
}

extension RestaurantEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nature"
    }
    
    var path: String {
        switch self {
        case .getRestaurantMainItem:
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getRestaurantMainItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getRestaurantMainItem(page, size, filterName):
            let param = ["addressFilterList": filterName, "page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        }
    }
}
