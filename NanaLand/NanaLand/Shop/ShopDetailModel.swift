//
//  ShopDetailModel.swift
//  NanaLand
//
//  Created by jun on 4/29/24.
//

import Foundation

struct ShopDetailModel: Codable {
    
    let id: Int64
    let title: String
    let images: [DetailImagesList]
    let content: String
    let address: String
    let addressTag: String
    let contact: String
    let homepage: String
    let time: String
    let amenity: String
    var favorite: Bool
}

