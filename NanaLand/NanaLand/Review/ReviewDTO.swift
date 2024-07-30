//
//  ReviewDTO.swift
//  NanaLand
//
//  Created by juni on 7/25/24.
//

import Foundation

struct ReviewDTO: Codable {
    var rating: Int
    var content: String
    var reviewKeywords: [String]
}
