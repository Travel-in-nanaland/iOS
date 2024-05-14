//
//  RecommendModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation

struct RecommendModel: Codable, Hashable {
    var message: String
    var data: [RecommendData]
}

struct RecommendData: Codable, Hashable {
    var id: Int
    var category: String
    var thumbnailUrl: String
    var title: String
    var intro: String
}
