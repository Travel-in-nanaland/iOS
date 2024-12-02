//
//  HotModel.swift
//  NanaLand
//
//  Created by juni on 11/21/24.
//

import Foundation

struct HotModel: Codable {
    let id: Int64
    let title: String
    let address: String
    let category: String
    let firstImage: ImageList
    let viewCount: Int
    var favorite: Bool
}
