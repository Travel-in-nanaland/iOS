//
//  UserInfoModel.swift
//  NanaLand
//
//  Created by wodnd on 12/23/24.
//

import Foundation
struct InitializeUploadRequest: Encodable {
    let originalFileName: String
    let fileSize: Int
    let fileCategory: String
    let partCount: Int
}

struct CompleteUploadRequest: Encodable {
    let uploadId: String
    let fileKey: String
    let parts: [FileUploadPart]
}

struct UpdateUserProfileRequest: Encodable {
    let nickname: String
    let description: String
}
