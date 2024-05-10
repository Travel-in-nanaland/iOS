//
//  AuthService.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import Alamofire

struct AuthService {
	static func refreshingToken() async -> BaseResponse<String>? {
		return await NetworkManager.shared.request(AuthEndPoint.refreshingToken)
	}
	
	static func loginServer(body: LoginRequest) async -> BaseResponse<LoginRegisterResponse>? {
		return await NetworkManager.shared.request(AuthEndPoint.login(body: body))
	}
	
	static func registerServer(body: RegisterRequest) async -> BaseResponse<LoginRegisterResponse>? {
		return await NetworkManager.shared.request(AuthEndPoint.register(body: body))
	}
}
