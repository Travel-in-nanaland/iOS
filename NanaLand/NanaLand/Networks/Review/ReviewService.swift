//
//  ReviewService.swift
//  NanaLand
//
//  Created by juni on 7/22/24.
//

import Foundation

struct ReviewService {
    // 리뷰 작성 할 아이템 정보 조회
    static func getReviewItem(id: Int64, category: String, body: ReviewDTO, multipartFile: [Foundation.Data?]) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.createReview(id: id, category: category, body: body, multipartFile: multipartFile))
    }
}
