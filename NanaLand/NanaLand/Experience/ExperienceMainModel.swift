//
//  ExperienceMainModel.swift
//  NanaLand
//
//  Created by juni on 7/15/24.
//

import Foundation

struct ExperienceMainModel: Codable {
    var totalElements: Int64
    var data: [ExperienceData]
}

struct ExperienceData: Codable {
    let id: Int64
    let firstImage: ImageList
    let title: String
    let addressTag: String
    let ratingAvg: Double
    var favorite: Bool
}

struct ImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
