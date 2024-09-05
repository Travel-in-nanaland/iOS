//
//  RecommendModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation

struct RecommendModel: Codable, Hashable {
    var id: Int64
    var category: String
    var title: String
    var introduction: String?
    var firstImage: ImageList
}
