//
//  ReviewAllMainViewModel.swift
//  NanaLand
//
//  Created by juni on 8/4/24.
//

import Foundation

class ReviewAllMainViewModel: ObservableObject {
    struct State {
        var getReviewAllMainResponse = MyAllReviewModel(totalElements: 0, data: [])
    }
    
    enum Action {
        case getUserAllReviewItem(memberId: Int64, page: Int, size: Int)
        case reviewFavorite(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getUserAllReviewItem(memberId, page, size):
            let response = await ReviewService.getUserAllReviewData(memberId: memberId, page: page, size: size)
            if let responseData = response!.data {
                await MainActor.run {
                    print(response)
                    state.getReviewAllMainResponse.totalElements = responseData.totalElements
                    state.getReviewAllMainResponse.data!.append(contentsOf: response!.data?.data ?? [])
                    print(state.getReviewAllMainResponse.totalElements)
                }
            } else {
                print("Error")
            }
        case let .reviewFavorite(id):
            let response = await ReviewService.reviewFavorite(id: id)
            if let responseData = response?.data {
                await MainActor.run {
                    if let index = state.getReviewAllMainResponse.data!.firstIndex(where: { $0.id == id }) {
                        state.getReviewAllMainResponse.data![index].reviewHeart = responseData.reviewHeart
                        if responseData.reviewHeart {
                            state.getReviewAllMainResponse.data![index].heartCount += 1
                        } else {
                            state.getReviewAllMainResponse.data![index].heartCount -= 1
                        }
                        print("Updated reviewHeart for review with id: \(id)")
                    } else {
                        print("Review with id: \(id) not found")
                    }
                }
            } else {
                print("Response data is nil")
            }
        }
    }
}

