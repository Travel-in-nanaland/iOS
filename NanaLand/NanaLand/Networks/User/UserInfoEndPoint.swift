//
//  UserInfoEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation
import Alamofire

enum UserInfoEndPoint {
    case getUserInfo
}

extension UserInfoEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/member"
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
}
