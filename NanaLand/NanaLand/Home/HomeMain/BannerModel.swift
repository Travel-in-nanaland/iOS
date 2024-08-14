//
//  BannerModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation

struct BannerModel: Codable {
    var id: Int64
    var firstImage: ImageList
    var version: String
    var subHeading: String
    var heading: String
    var newest: Bool
}

struct ImageData: Codable {
    var id: Int64
    var thumbnailUrl: String
    var version: String
    var subHeading: String
    var heading: String
}
