//
//  NatureDetailEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/3/24.
//

import Foundation
import Alamofire

enum NatureDetailEndPoint {
    case getNatureDetailItem(id: Int64)
}

extension NatureDetailEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nature"
    }
    
    var path: String {
        switch self {
        case .getNatureDetailItem(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNatureDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getNatureDetailItem(_):
            return .requestPlain
        }
    }
}

