//
//  ReviewAllDetailMainViewModel.swift
//  NanaLand
//
//  Created by juni on 8/5/24.
//

import Foundation

class ReviewAllDetailMainViewModel: ObservableObject {
    struct State {
        var getReviewDataResponse = ReviewModel(totalElements: 0, totalAvgRating: 0.0, data: [ReviewData(id: 0, memberId: 0, nickname: "", profileImage: ImageList(originUrl: "", thumbnailUrl: ""), memberReviewCount: 0, rating: 0, content: "", createdAt: "", heartCount: 0, images: [], reviewTypeKeywords: [], reviewHeart: false)])
    }
    
    enum Action {
        case getReviewData(id: Int64, category: String, page: Int, size: Int)
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
        }
    }
}
