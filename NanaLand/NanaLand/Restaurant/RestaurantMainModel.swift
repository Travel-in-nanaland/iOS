//
//  RestaurantModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
struct RestaurantMainModel: Codable {
    var totalElements: Int64
    var data: [RestaurantModelInfo]
}

struct RestaurantModelInfo: Codable {
    let id: Int64
    let title: String
    let thumbnailUrl: String
    let addressTag: String
    var favorite: Bool
}
