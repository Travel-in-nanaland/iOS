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
            if response != nil {
                await MainActor.run {
                    state.getReviewAllMainResponse.totalElements = response!.data!.totalElements
                    state.getReviewAllMainResponse.data = response!.data!.data
                    print("\(state.getReviewAllMainResponse.data)")
                }
            } else {
                print("Error")
            }
        }
    }
}
