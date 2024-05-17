//
//  FestivalDetailEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/16/24.
//

import Foundation
import Alamofire

enum FestivalDetailEndPoint {
    case getFestivalDetailItem(id: Int64, isSearch: Bool)
}

extension FestivalDetailEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/festival"
    }
    
    var path: String {
        switch self {
        case .getFestivalDetailItem(let id, _):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getFestivalDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getFestivalDetailItem(_, isSearch):
            let param: [String: Bool] = [
                "isSearch": isSearch
            ]
            return .requestParameters(parameters: param)
        }
    }
}

