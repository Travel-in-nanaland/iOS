//
//  RestaurantModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

struct RestaurantMainModel: Codable {
    var totalElements: Int64
    var data: [RestaurantData]
}

struct RestaurantData: Codable {
    let id: Int64
    let firstImage: RestaurantImageList
    let title: String
    let addressTag: String
    let ratingAvg: Double
    var favorite: Bool
}

struct RestaurantImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}

