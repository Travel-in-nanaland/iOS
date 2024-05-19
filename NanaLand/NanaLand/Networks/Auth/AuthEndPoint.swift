//
//  AuthEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import Alamofire

enum AuthEndPoint {
	case refreshingToken
	case login(body: LoginRequest)
	case register(body: RegisterRequest, image: [Foundation.Data?])
	case patchUserType(body: PatchUserTypeRequest)
}

extension AuthEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/member"
	}
	
	var path: String {
		switch self {
		case .refreshingToken:
			return "/reissue"
		case .login:
			return "/login"
		case .register:
			return "/join"
		case .patchUserType:
			return "/type"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .refreshingToken:
			return .get
		case .login:
			return .post
		case .register:
			return .post
		case .patchUserType:
			return .patch
		}
	}
	
	var task: APITask {
		switch self {
		case .refreshingToken:
			return .requestWithoutInterceptor()
		case let .login(body):
			return .requestWithoutInterceptor(body: body)
		case let .register(body, image):
			return .requestJSONWithImage(multipartFile: image, body: body, withInterceptor: false)
		case let .patchUserType(body):
			return .requestJSONEncodable(body: body)
		}
	}
	
	var headers: HTTPHeaders? {
		switch self {
		case .refreshingToken:
			if let refreshToken = KeyChainManager.readItem(key: "refreshToken") {
				return ["Authorization": "Bearer \(refreshToken)"]
			} else {
				return nil
			}
		case .login:
			return ["Content-Type": "application/json"]
		case .register:
			return ["Content-Type": "multipart/form-data"]
		case .patchUserType:
			return ["Content-Type": "application/json"]
		}
	}
	
	
}
