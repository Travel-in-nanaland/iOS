//
//  NatureMainModel.swift
//  NanaLand
//
//  Created by jun on 4/30/24.
//

import Foundation

struct NatureMainModel: Codable {
    var totalElements: Int64
    var data: [NatureModelInfo]
}

struct NatureModelInfo: Codable {
    let id: Int64
    let title: String
    let firstImage: ImageList
    let addressTag: String
    var favorite: Bool
}
