//
//  ReviewS3UploadCompleteDTO.swift
//  NanaLand
//
//  Created by juni on 12/10/24.
//

import Foundation

struct ReviewS3UploadCompleteDTO: Codable {
    var uploadId: String
    var fileKey: String
    var parts: [eTagData]
}

struct eTagData: Codable {
    var partNumber: Int
    var etag: String
}
