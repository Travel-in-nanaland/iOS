//
//  FestivalModel.swift
//  NanaLand
//
//  Created by jun on 5/5/24.
//

import Foundation

struct FestivalModel: Codable {
    let totalElements: Int64
    var data: [FestivalData]
}

struct FestivalData: Codable {
    let id: Int64
    let title: String
    let thumbnailUrl: String
    let addressTag: String
    let period: String
    let favorite: Bool
}
