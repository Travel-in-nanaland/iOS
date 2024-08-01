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
    let originUrl: String
    let content: String
    let address: String
    let addressTag: String
    let contact: String
    let homepage: String
    let time: String
    let amenity: String
    var favorite: Bool
    let menu: [Menu]
        
    struct Menu: Codable {
        let name: String
        let price: String
        let imageUrl: String
    }

}
