//
//  ReviewS3UploadModel.swift
//  NanaLand
//
//  Created by juni on 12/9/24.
//

import Foundation

struct ReviewS3UploadModel: Codable {
    var uploadId: String
    var fileKey: String
    var presignedUrlInfos: [UrlInfo]
    
    init(uploadId: String = "", fileKey: String = "", presignedUrlInfos: [UrlInfo] = []) {
        self.uploadId = uploadId
        self.fileKey = fileKey
        self.presignedUrlInfos = presignedUrlInfos
    }
}

struct UrlInfo: Codable {
    var partNumber: Int
    var preSignedUrl: String
}
