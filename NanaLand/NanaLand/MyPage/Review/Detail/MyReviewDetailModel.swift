//
//  MyReviewDetailModel.swift
//  NanaLand
//
//  Created by wodnd on 8/11/24.
//

import Foundation
// 공통 리뷰 모델
struct MyReviewDetailModel: Codable {
    let id: Int
    let firstImage: ImageList
    let title: String
    let address: String
    var rating: Int
    var content: String
    var images: [MyReviewDetailImage]?
    var reviewKeywords: [String]
}

struct MyReviewDetailImage: Codable {
    var id: Int
    var originUrl: String
    var thumbnailUrl: String
}


struct ReviewModifyModel: Codable {
    var status: Int?
    var message: String?
    var data: ReviewModifyData?
}

struct ReviewModifyData: Codable {
    var reviewKeywords: String?
    var rating: String?
    var content: String?
}

struct EditReviewDto: Codable {
    var rating: Int
    var content: String
    var reviewKeywords: [String]
    var editImageInfoList: [EditImageInfoDto]
}
