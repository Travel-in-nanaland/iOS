//
//  NewNanapickMainModel.swift
//  NanaLand
//
//  Created by wodnd on 8/21/24.
//

import Foundation

struct NewNanaPickMainModel: Codable {
    let id: Int64
    let firstImage: NewNanaPickImageList
    let version: String
    let subHeading: String
    let heading: String
    let newest: Bool
}

struct NewNanaPickImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}

struct NewNanaPickGridModel: Codable {
    var totalElements: Int
    var data: [NewNanaPickMainModel]
}
