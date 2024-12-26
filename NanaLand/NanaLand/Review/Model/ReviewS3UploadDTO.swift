//
//  ReviewS3UploadDTO.swift
//  NanaLand
//
//  Created by juni on 12/9/24.
//

import Foundation

struct ReviewS3UploadDTO: Codable {
    var originalFileName: String
    var fileSize: Int
    var fileCategory: String
    var partCount: Int
}
