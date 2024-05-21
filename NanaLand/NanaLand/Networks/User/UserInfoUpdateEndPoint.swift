//
//  UserInfoUpdateEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation
import Alamofire

enum UserInfoUpdateEndPoint {
    case updateUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?])
}

extension UserInfoUpdateEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/member"
    }
    
    var path: String {
        switch self {
        case .updateUserInfo:
            return "/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateUserInfo:
            return .patch
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "multipart/form-data", "Authorization": KeyChainManager.readItem(key: "accessToken")!]
    }

    var task: APITask {
        switch self {
        case let .updateUserInfo(body, multipartFile):
            return .requestJSONWithImage(multipartFile: multipartFile, body: body, withInterceptor: true)
        }
    }
}
