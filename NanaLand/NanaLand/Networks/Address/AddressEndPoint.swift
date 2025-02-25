//
//  AddressEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 2/24/25.
//

import Foundation
import Alamofire

enum AddressEndPoint {
    case getKoreanAddress(id: Int64, category: String, number: Int64?)
}


extension AddressEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/address"
    }

    var path: String {
        switch self {
        case .getKoreanAddress(let id, let category, let number):
            return "/kr"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getKoreanAddress:
            return .get
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .getKoreanAddress:
            return ["Content-Type": "application/json;charset=UTF-8"]
        }
    }

    var task: APITask {
        switch self {
        case let .getKoreanAddress(id, category, number):
            if number != nil {
                let param = ["postId": id, "category": category, "number": number] as [String: Any]
                return .requestParameters(parameters: param)
            } else {
                let param = ["postId": id, "category": category] as [String: Any]
                return .requestParameters(parameters: param)
            }
            
        }
    }
}

