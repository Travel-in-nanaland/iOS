//
//  UserInfoUpdateService.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation
import Alamofire

//struct UserInfoUpdateService {
//    static func updateUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?]) async -> BaseResponse<EmptyResponseModel>? {
//        return await NetworkManager.shared.request(UserInfoUpdateEndPoint.updateUserInfo(body: body, multipartFile: multipartFile))
//    }
//}


struct UserInfoUpdateService {
    
    // 1. 프로필 업데이트 요청
    static func updateUserProfile(nickname: String, description: String, fileKey: String?) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(UserInfoUpdateEndPoint.updateUserProfile(nickname: nickname, description: description, fileKey: fileKey))
    }
}
