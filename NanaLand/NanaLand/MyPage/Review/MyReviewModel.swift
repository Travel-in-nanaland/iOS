//
//  ProfileReviewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/29/24.
//

import Foundation
struct MyReviewModel: Codable {
    let reviews: [Review]
    
    init(
        reviews: [Review] = [Review(id: 1, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트입니다.", createdAt: "2024-06-12", heartCount: 3, images: ["" : ""], reviewTypeKeywords: [])]
    ) {
        self.reviews = reviews
    }
    
    
    struct Review: Codable {
        let id: Int64
        let postId: Int64
        let category: String
        let placeName: String
        let rating: Int
        let content: String
        let createdAt: String
        let heartCount: Int
        let images: [String: String]
        let reviewTypeKeywords: [String]
    }
}
