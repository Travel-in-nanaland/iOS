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
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .refreshingToken:
			return .get
		case .login:
			return .post
		}
	}
	
	var task: APITask {
		switch self {
		case .refreshingToken:
			return .requestWithoutInterceptor()
		case let .login(body):
			return .requestWithoutInterceptor(body: body)
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
			return nil
		}
	}
	
	
}
