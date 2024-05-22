//
//  AuthService.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation
import Alamofire

struct AuthService {
	static func refreshingToken() async -> BaseResponse<LoginRegisterResponse>? {
		return await NetworkManager.shared.request(AuthEndPoint.refreshingToken)
	}
	
	static func loginServer(body: LoginRequest) async -> BaseResponse<LoginRegisterResponse>? {
		return await NetworkManager.shared.request(AuthEndPoint.login(body: body))
	}
	
	static func registerServer(body: RegisterRequest, image: [Foundation.Data?]) async -> BaseResponse<LoginRegisterResponse>? {
		return await NetworkManager.shared.request(AuthEndPoint.register(body: body, image: image))
	}
	
	static func patchUserType(body: PatchUserTypeRequest) async -> BaseResponse<String>? {
		return await NetworkManager.shared.request(AuthEndPoint.patchUserType(body: body))
	}
}
