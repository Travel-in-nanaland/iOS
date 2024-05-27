//
//  ProfileUpdateViewModel.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation
import SwiftUI

class ProfileUpdateViewModel: ObservableObject {

    struct State {
        var getUpdatedProfileMainResponse = ProfileUpdateModel(message: "", status: "")
        var updatedNickName = ""
        var updatedDescription = ""
        var updatedProfilImage = ""
        var isDuplicate = false
    }
    
    enum Action {
        case getUpdatedUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?])
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getUpdatedUserInfo(body, multipartFile):
            let response = await UserInfoUpdateService.updateUserInfo(body: ProfileDTO(nickname: body.nickname, description: body.description), multipartFile: multipartFile)
            // 프로필 수정 후 업데이트 된 유저 정보 얻어오기 위해서
            let updateUserInfo = await UserInfoService.getUserInfo()
            if response != nil {
                await MainActor.run {
                    state.getUpdatedProfileMainResponse.message = response!.message
                    if state.getUpdatedProfileMainResponse.message == "사용자 프로필 수정 성공" {
                        self.state.isDuplicate = false
                    } else {
                        self.state.isDuplicate = true
                    }
                    if let updateUserInfo = updateUserInfo {
                        state.updatedNickName = updateUserInfo.data.nickname
                        state.updatedDescription = updateUserInfo.data.description
                        state.updatedProfilImage = updateUserInfo.data.profileImageUrl
                    }
                 
                    
                    
                }
            }
        }
    }
}
