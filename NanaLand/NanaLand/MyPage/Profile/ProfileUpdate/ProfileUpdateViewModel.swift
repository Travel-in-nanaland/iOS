//
//  ProfileUpdateViewModel.swift
//  NanaLand
//
//  Created by jun on 5/20/24.
//

import Foundation
import SwiftUI

//class ProfileUpdateViewModel: ObservableObject {
//
//    struct State {
//        var getUpdatedProfileMainResponse = ProfileUpdateModel(message: "", status: "")
//        var updatedNickName = ""
//        var updatedDescription = ""
//        var updatedProfilImage = ""
//        var isDuplicate = false
//    }
//
//    enum Action {
//        case getUpdatedUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?])
//    }
//
//    @Published var state: State
//
//    init(
//        state: State = .init()
//    ) {
//        self.state = state
//    }
//
//    func action(_ action: Action) async {
//        switch action {
//        case let .getUpdatedUserInfo(body, multipartFile):
//            let response = await UserInfoUpdateService.updateUserInfo(body: ProfileDTO(nickname: body.nickname, description: body.description), multipartFile: multipartFile)
//            // 프로필 수정 후 업데이트 된 유저 정보 얻어오기 위해서
//            let updateUserInfo = await UserInfoService.getUserInfo()
//            if response != nil {
//                await MainActor.run {
//                    state.getUpdatedProfileMainResponse.message = response!.message
//                    if state.getUpdatedProfileMainResponse.message == "사용자 프로필 수정 성공" {
//                        self.state.isDuplicate = false
//                    } else {
//                        self.state.isDuplicate = true
//                    }
//                    if let updateUserInfo = updateUserInfo {
//                        state.updatedNickName = updateUserInfo.data.nickname
//                        state.updatedDescription = updateUserInfo.data.description
//                        state.updatedProfilImage = updateUserInfo.data.profileImage.originUrl
//                    }
//
//
//
//                }
//            }
//        }
//    }
//}


class ProfileUpdateViewModel: ObservableObject {
    struct State {
        var isUploadComplete = false
        var errorMessage: String?
        var isDuplicate = false
        var isBasicProfile = false
        var basicProfileName: String?
    }
    
    enum Action {
        case updateProfile(nickname: String, description: String, profileImage: Data?)
    }
    
    @Published var state: State
    
    init(state: State = .init()) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .updateProfile(nickname, description, profileImage):
            var fileKey: String?

            if self.state.isBasicProfile {
                fileKey = "default/\(self.state.basicProfileName ?? "Gray").png"
            } else {
                if let imageData = profileImage {
                    // 1. 파일 업로드 초기화 요청
                    guard let initResponse = await PreSignedUploadService.initializeFileUpload(
                        fileName: "profile_image.jpg",
                        fileSize: imageData.count,
                        fileCategory: "MEMBER_PROFILE",
                        partCount: 1
                    ) else {
                        await MainActor.run {
                            self.state.errorMessage = "파일 업로드 초기화에 실패했습니다."
                        }
                        return
                    }

                    guard let preSignedUrlInfo = initResponse.data?.presignedUrlInfos.first else {
                        await MainActor.run {
                            self.state.errorMessage = "PreSigned URL 정보를 가져오지 못했습니다."
                        }
                        return
                    }

                    // 2. PreSigned URL로 파일 전송 및 ETag 수집
                    guard let eTag = await PreSignedUploadService.uploadFileToPreSignedURL(
                        preSignedUrl: preSignedUrlInfo.preSignedUrl,
                        fileData: imageData
                    ) else {
                        await MainActor.run {
                            self.state.errorMessage = "파일 업로드에 실패했습니다."
                        }
                        return
                    }

                    // 3. 업로드 완료 요청
                    let completeResponse = await PreSignedUploadService.completeFileUpload(
                        uploadId: initResponse.data!.uploadId,
                        fileKey: initResponse.data!.fileKey,
                        parts: [FileUploadPart(partNumber: preSignedUrlInfo.partNumber, eTag: eTag)]
                    )

                    if completeResponse == nil {
                        await MainActor.run {
                            self.state.errorMessage = "업로드 완료 요청에 실패했습니다."
                        }
                        return
                    }

                    fileKey = initResponse.data?.fileKey
                }
            }

            // 4. 프로필 업데이트 요청
            let updateProfileResponse = await UserInfoUpdateService.updateUserProfile(
                nickname: nickname,
                description: description,
                fileKey: fileKey // fileKey가 nil일 수 있음
            )

            if updateProfileResponse?.status != 200 {
                await MainActor.run {
                    self.state.errorMessage = "프로필 업데이트에 실패했습니다."
                }
                return
            }

            await MainActor.run {
                self.state.isDuplicate = false
                self.state.isUploadComplete = true
            }

            print("프로필 업데이트 성공!")
        }
    }
}
