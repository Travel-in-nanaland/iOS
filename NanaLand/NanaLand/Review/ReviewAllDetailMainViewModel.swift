//
//  ReviewAllDetailMainViewModel.swift
//  NanaLand
//
//  Created by juni on 8/5/24.
//

import Foundation

class ReviewAllDetailMainViewModel: ObservableObject {
    struct State {
        var getReviewDataResponse = ReviewModel(totalElements: 0, totalAvgRating: 0.0, data: [ReviewData(id: 0, memberId: 0, nickname: "", profileImage: ImageList(originUrl: "", thumbnailUrl: ""), memberReviewCount: 0, rating: 0, content: "", createdAt: "", heartCount: 0, images: [], reviewTypeKeywords: [], reviewHeart: false, myReview: false)])
        var deleteMyReviewResponse = EmptyResponseModel()
    }
    
    enum Action {
        case getReviewData(id: Int64, category: String, page: Int, size: Int)
        case reviewFavorite(id: Int64)
        case deleteMyReview(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getReviewData(id, category, page, size):
            let response = await ReviewService.getReviewData(id: id, category: category, page: page, size: size)
            if response != nil {
                await MainActor.run {
                    state.getReviewDataResponse = response!.data!
                    print(state.getReviewDataResponse.data.count)
                }
            }
        case let .reviewFavorite(id):
            let response = await ReviewService.reviewFavorite(id: id)
            if let responseData = response?.data {
                await MainActor.run {
                    if let index = state.getReviewDataResponse.data.firstIndex(where: { $0.id == id }) {
                        state.getReviewDataResponse.data[index].reviewHeart = responseData.reviewHeart
                        if responseData.reviewHeart {
                            state.getReviewDataResponse.data[index].heartCount += 1
                        } else {
                            state.getReviewDataResponse.data[index].heartCount -= 1
                        }
                        print("Updated reviewHeart for review with id: \(id)")
                    } else {
                        print("Review with id: \(id) not found")
                    }
                }
            } else {
                print("Response data is nil")
            }
            
        case let .deleteMyReview(id):
            let response = await ReviewService.deleteMyReview(id: id)
            if response != nil {
                await MainActor.run {
                    if let index = state.getReviewDataResponse.data.firstIndex(where: { $0.id == id }) {
                        state.getReviewDataResponse.totalElements -= 1
                    }
                }
            } else {
                print("Error")
            }
        }
    }
}
