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

struct ImageInfo: Codable, Hashable, Identifiable{
    let id: Int64
    let thumbnailUrl: String
}
