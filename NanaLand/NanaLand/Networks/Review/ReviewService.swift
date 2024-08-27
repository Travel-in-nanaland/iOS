//
//  ReviewService.swift
//  NanaLand
//
//  Created by juni on 7/22/24.
//

import Foundation

struct ReviewService {
    // 리뷰 작성 할 아이템 정보 조회
    static func getReviewItem(id: Int64, category: String, body: ReviewDTO, multipartFile: [Foundation.Data?]) async -> BaseResponse<ReviewPostModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.createReview(id: id, category: category, body: body, multipartFile: multipartFile))
    }
    // 상세 아이템 후기 조회
    static func getReviewData(id: Int64, category: String, page: Int, size: Int) async -> BaseResponse<ReviewModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getReviewData(id: id, category: category, page: page, size: size))
    }
    
    // 마이페이지 후기 프리뷰 조회
    static func getMyReviewItem() async -> BaseResponse<MyReviewModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getMyReviewData)
    }
    
    // 마이페이지 모두 보기 리뷰 조회
    static func getMyAllReviewItem(page: Int, size: Int) async -> BaseResponse<MyAllReviewModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getAllReviewData(page: page, size: size))
    }
  
    // 다른 유저 프로필 후기 프리뷰 조회
    static func getPreviewData(memberId: Int64) async -> BaseResponse<PreviewReviewModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getPreviewData(memberId: memberId))
    }
    // 타 유저 모든 리뷰 조회
    static func getUserAllReviewData(memberId: Int64, page: Int, size: Int) async -> BaseResponse<MyAllReviewModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getUserAllReviewData(memberId: memberId, page: page, size: size))
    }
    
    // 내가 작성한 후기 삭제
    static func deleteMyReview(id: Int64) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.deleteMyReview(id: id))
    }
    
    //내가 작성한 후기 상세 조회
    static func getMyReviewDetail(id: Int64) async -> BaseResponse<MyReviewDetailModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.getMyReviewDetail(id: id))
    }
    
    //내가 작성한 후기 수정
    static func modifyMyReview(id: Int64, body: EditReviewDto, multipartFile: [Foundation.Data?]) async -> BaseResponse<ReviewModifyModel>? {
        return await NetworkManager.shared.request(ReviewEndPoint.modifyMyReview(id: id, body: body, multipartFile: multipartFile))
    }
    
    //후기 좋아요
    static func reviewFavorite(id: Int64) async -> BaseResponse<ReviewFavoriteResponse>? {
        return await NetworkManager.shared.request(ReviewEndPoint.reviewFavorite(id: id))
    }
    
    //후기 위한 게시글 검색 자동완성
    static func profileReview(keyword: String) async -> BaseResponse<[ProfileReviewWriteModel]>? {
        return await NetworkManager.shared.request(ReviewEndPoint.profileReview(keyword: keyword))
    }
}
