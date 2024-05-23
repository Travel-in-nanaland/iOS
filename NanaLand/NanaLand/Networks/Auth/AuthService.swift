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
	
	static func patchUserType(body: PatchUserTypeRequest) async -> BaseResponse<EmptyResponseModel>? {
		return await NetworkManager.shared.request(AuthEndPoint.patchUserType(body: body))
	}
	
	static func logout() async -> BaseResponse<EmptyResponseModel>? {
		return await NetworkManager.shared.request(AuthEndPoint.logout)
	}
	
	static func withdraw(body: WithdrawRequest) async -> BaseResponse<EmptyResponseModel>? {
		return await NetworkManager.shared.request(AuthEndPoint.withdraw(body: body))
	}
}
