//
//  UserInfoUpdateEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation
import Alamofire

//enum UserInfoUpdateEndPoint {
//    case updateUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?])
//}
//
//extension UserInfoUpdateEndPoint: EndPoint {
//    var baseURL: String {
//        return "\(Secrets.baseUrl)/member"
//    }
//
//    var path: String {
//        switch self {
//        case .updateUserInfo:
//            return "/profile"
//        }
//    }
//
//    var method: HTTPMethod {
//        switch self {
//        case .updateUserInfo:
//            return .patch
//        }
//    }
//
//    var headers: HTTPHeaders? {
//        return ["Content-Type": "multipart/form-data"]
//    }
//
//    var task: APITask {
//        switch self {
//        case let .updateUserInfo(body, multipartFile):
//            return .requestJSONWithImage(multipartFile: multipartFile, body: body)
//        }
//    }
//}


enum UserInfoUpdateEndPoint {
    case updateUserProfile(nickname: String, description: String, fileKey: String?)
}

extension UserInfoUpdateEndPoint: EndPoint {
    var baseURL: String {
        switch self {
        case .updateUserProfile:
            return "\(Secrets.baseUrl)/member"
        }
    }
    
    var path: String {
        switch self {
        case let .updateUserProfile(_, _, fileKey):
            if let fileKey = fileKey {
                return "/profile?fileKey=\(fileKey)"
            } else {
                return "/profile"
            }
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .updateUserProfile:
            return .patch
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .updateUserProfile:
            return ["Content-Type": "application/json;charset=UTF-8"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .updateUserProfile(nickname, description, fileKey):
            let body = UpdateUserProfileRequest(
                nickname: nickname,
                description: description
            )
            return .requestJSONEncodable(body: body)
        }
    }
}
