//
//  NaNaPickDetailServiceEndPoint.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation
import Alamofire

enum NaNaPickDetailEndPoint {
    case getNaNaPickDetail(id: Int64)
}

extension NaNaPickDetailEndPoint: EndPoint {
    
    var baseURL: String {
        return "\(Secrets.baseUrl)/nana"
    }
    
    var path: String {
        switch self {
        case .getNaNaPickDetail(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNaNaPickDetail:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getNaNaPickDetail(_):
            // 파라미터 필요 x
            return .requestPlain
        }
    }
}
