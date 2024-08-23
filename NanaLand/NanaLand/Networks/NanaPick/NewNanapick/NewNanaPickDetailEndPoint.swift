//
//  NewNanaPickDetailEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 8/23/24.
//

import Foundation
import Alamofire

enum NewNanaPickDetailEndPoint {
    case getNewNanaPickDetail(id: Int64)
}

extension NewNanaPickDetailEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nana"
    }
    
    var path: String {
        switch self {
        case .getNewNanaPickDetail(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNewNanaPickDetail:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getNewNanaPickDetail:
            return ["Content-Type": "application/json"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNewNanaPickDetail:
            return .requestPlain
        }
    }
}

