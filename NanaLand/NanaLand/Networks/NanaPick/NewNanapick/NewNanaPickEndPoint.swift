//
//  NewNanaPickEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 8/21/24.
//

import Foundation
import Alamofire

enum NewNanaPickEndPoint {
    case getNanaPickRecommend
    case getNanaPickGridList(page: Int, size: Int)
}

extension NewNanaPickEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/nana"
    }
    
    var path: String {
        switch self {
        case .getNanaPickRecommend:
            return "/recommend"
        case .getNanaPickGridList(let page, let size):
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNanaPickRecommend:
            return .get
        case .getNanaPickGridList:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getNanaPickRecommend:
            return ["Content-Type": "application/json"]
        case .getNanaPickGridList:
            return ["Content-Type": "application/json"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNanaPickRecommend:
            return .requestPlain
        case let .getNanaPickGridList(page, size):
            let param = ["page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        }
    }
}

