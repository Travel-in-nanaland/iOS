//
//  ReviewModel.swift
//  NanaLand
//
//  Created by juni on 7/30/24.
//

import Foundation
// 공통 리뷰 모델
struct ReviewModel: Codable {
    var totalElements: Int
    let totalAvgRating: Double
    var data: [ReviewData]
}

struct ReviewData: Codable {
    let id: Int64
    let memberId: Int?
    let nickname: String?
    let profileImage: ImageList?
    let memberReviewCount: Int?
    let rating: Double?
    let content: String?
    let createdAt: String?
    var heartCount: Int
    let images: [ImageList]?
    let reviewTypeKeywords: [String]?
    var reviewHeart: Bool
    let myReview: Bool
}
