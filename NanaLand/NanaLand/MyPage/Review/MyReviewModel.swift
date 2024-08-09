//
//  ProfileReviewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/29/24.
//

import Foundation

struct MyReviewModel: Codable {
    var totalElements: Int64
    var data: [myReivew]?
}

struct myReivew: Codable {
    let id: Int64
    let postId: Int64
    let category: String
    let placeName: String
    let createdAt: String
    let heartCount: Int64
    let imageFileDto: ReviewDetailImagesList?
}

struct ReviewDetailImagesList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}

