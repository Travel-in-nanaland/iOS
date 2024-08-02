//
//  NaNaPickModel.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

struct NaNaPickModel: Codable {
//    let status: Int
    var data: [ImageInfo]
}

struct ImageInfo: Codable{
    let id: Int64
    let firstImage: NanaPickImageList
    let version: String
    let subHeading: String
    let heading: String
    let newest: Bool
}

struct NanaPickImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
