//
//  UserInfoService.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation

struct UserInfoService {
    static func getUserInfo() async -> OldBaseResponse<ProfileMainModel>? {
        return await NetworkManager.shared.request(UserInfoEndPoint.getUserInfo)
    }
	
	static func patchUserLanguage(body: PatchUserLanguageRequest) async -> BaseResponse<EmptyResponseModel>? {
		return await NetworkManager.shared.request(UserInfoEndPoint.patchUserLanguage(locale: body))
	}
    static func getUserProfileInto(id: Int64) async -> BaseResponse<ProfileMainModel>? {
        return await NetworkManager.shared.request(UserInfoEndPoint.getUserProfileInfo(id: id))
    }
}
