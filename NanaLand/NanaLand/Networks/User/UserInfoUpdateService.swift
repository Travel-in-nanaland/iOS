//
//  UserInfoUpdateService.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation

struct UserInfoUpdateService {
    static func updateUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?]) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(UserInfoUpdateEndPoint.updateUserInfo(body: body, multipartFile: multipartFile))
    }
}
