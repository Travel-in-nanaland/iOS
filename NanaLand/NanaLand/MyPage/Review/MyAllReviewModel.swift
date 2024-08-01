//
//  MyAllReviewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation

struct MyAllReviewModel: Codable {
    var totalElements: Int64
    var data: [allReview]?
}

struct allReview: Codable {
    let id: Int64
    let postId: Int64
    let category: String
    let placeName: String
    let rating: Int64
    let content: String
    let createdAt: String
    let heartCount: Int64
    let images: [AllReviewDetailImagesList]?
    let reviewTypeKeywords: [String]
}

struct AllReviewDetailImagesList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
