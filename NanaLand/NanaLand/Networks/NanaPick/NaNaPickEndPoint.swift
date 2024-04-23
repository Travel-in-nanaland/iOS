//
//  NaNaPickEndPoint.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation
import Alamofire

enum NaNaPickEndPoint {
    case getNaNaPick(page: Int, size: Int)
}

extension NaNaPickEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nana"
    }
    
    var path: String {
        switch self {
        case .getNaNaPick:
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNaNaPick:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNaNaPick(page, size):
            let param = ["page": page, "size": size]
            return .requestParameters(parameters: param)
        }
    }
    
}
