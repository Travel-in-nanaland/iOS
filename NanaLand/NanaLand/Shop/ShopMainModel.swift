//
//  ShopMainModel.swift
//  NanaLand
//
//  Created by jun on 4/26/24.
//

import Foundation

struct ShopMainModel: Codable {
    var totalElements: Int64
    var data: [ShopModelInfo]
}

struct ShopModelInfo: Codable {
    let id: Int64
    let title: String
    let thumbnailUrl: String
    let addressTag: String
    var favorite: Bool
}
