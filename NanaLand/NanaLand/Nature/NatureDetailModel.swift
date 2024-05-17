//
//  NatureDetailModel.swift
//  NanaLand
//
//  Created by jun on 5/3/24.
//

import Foundation

struct NatureDetailModel: Codable {
    let id: Int64
    let title: String
    let originUrl: String
    let content: String
    let address: String
    let addressTag: String
    let contact: String
    let time: String
    let fee: String
    let details: String
    let amenity: String
    var favorite: Bool
    let intro: String
}
