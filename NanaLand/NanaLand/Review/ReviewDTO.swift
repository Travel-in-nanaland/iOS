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

struct ReviewPostModel: Codable {
    var status: Int?
    var message: String?
    var data: ReviewPostData?
}

struct ReviewPostData: Codable {
    var reviewKeywords: String?
    var rating: String?
    var content: String?
}

struct PreviewReviewModel: Codable {
    let totalElements: Int
    var data: [PreviewData]
}

struct PreviewData: Codable {
    let id: Int
    let postId: Int
    let category: String
    let placeName: String
    let createdAt: String
    let heartCount: Int
    let imageFileDto: ImageList?
}

struct ReviewFavoriteResponse: Codable {
    let reviewHeart: Bool
}
