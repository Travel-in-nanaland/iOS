//
//  ExperienceDetailModel.swift
//  NanaLand
//
//  Created by juni on 7/19/24.
//

import Foundation

struct ExperienceDetailModel: Codable {
    let id: Int64?
    let title: String?
    let content: String?
    let address: String?
    let addressTag: String?
    let contact: String?
    let homepage: String?
    let time: String?
    let amenity: String?
    let details: String?
    let keywords: [String]?
    let images: [DetailImagesList]?
    var favorite: Bool?
    var intro: String?
}

struct DetailImagesList: Codable {
    let originUrl: String?
    let thumbnailUrl: String?
}
