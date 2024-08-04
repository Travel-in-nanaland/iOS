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
	case patchUserLanguage(locale: PatchUserLanguageRequest)
    case getUserProfileInfo(id: Int64) // 다른 유저 프로필 조회
}

extension UserInfoEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/member"
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return "/profile"
		case .patchUserLanguage:
			return "/language"
        case .getUserProfileInfo:
            return "/profile"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
		case .patchUserLanguage:
			return .post
        case .getUserProfileInfo:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case .getUserInfo:
            return .requestPlain
		case let .patchUserLanguage(locale):
			return .requestJSONEncodable(body: locale)
        case let .getUserProfileInfo(id):
            let param = ["id": id]
            return .requestParameters(parameters: param)
        }
    }
    
}
