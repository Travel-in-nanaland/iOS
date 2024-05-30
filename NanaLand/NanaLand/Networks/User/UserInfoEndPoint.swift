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
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo:
            return .get
		case .patchUserLanguage:
			return .post
        }
    }
    
    var task: APITask {
        switch self {
        case .getUserInfo:
            return .requestPlain
		case let .patchUserLanguage(locale):
			return .requestJSONEncodable(body: locale)
        }
    }
    
}
