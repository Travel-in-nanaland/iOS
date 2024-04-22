//
//  BannerModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation

struct BannerModel: Codable {
    var message: String
    var data: [ImageData]
}

struct ImageData: Codable {
    var id: Int64
    var thumbnailUrl: String
}
