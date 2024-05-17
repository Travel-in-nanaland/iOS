//
//  NatureEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/2/24.
//

import Foundation
import Alamofire

enum NatureEndPoint {
    case getNatureMainItem(page: Int64, size: Int64, filterName: String)
}

extension NatureEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nature"
    }
    
    var path: String {
        switch self {
        case .getNatureMainItem:
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNatureMainItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNatureMainItem(page, size, filterName):
            let param = ["addressFilterList": filterName, "page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        }
    }
}
