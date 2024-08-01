//
//  RestaurantDetailModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
struct RestaurantDetailModel: Codable {
    let id: Int64
    let title: String
    let content: String
    let address: String
    let addressTag: String
    let contact: String?
    let homepage: String?
    let instagram: String?
    let time: String?
    let service: String?
    let menus: [Menu]
    let keywords: [String]?
    let images: [RestaurantDetailImagesList]
    var favorite: Bool
}

struct RestaurantDetailImagesList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}

struct Menu: Codable {
    let menuName: String
    let price: String
    let firstImage: RestaurantDetailImagesList
}
