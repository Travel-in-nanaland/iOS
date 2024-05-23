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
}
