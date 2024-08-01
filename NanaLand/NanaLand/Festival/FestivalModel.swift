//
//  FestivalModel.swift
//  NanaLand
//
//  Created by jun on 5/5/24.
//

import Foundation

struct FestivalModel: Codable {
    var totalElements: Int64
    var data: [FestivalData]
}

struct FestivalData: Codable {
    let id: Int64
    let title: String
    let firstImage: ImageList
    let addressTag: String
    let period: String
    var favorite: Bool
}
