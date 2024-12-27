//
//  MyReviewViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/29/24.
//
import Foundation

class MyReviewViewModel: ObservableObject {
    struct State {
        var getMyReviewResponse = MyReviewModel(totalElements: 0, data: [])
        var deleteMyReviewResponse = EmptyResponseModel()
        var memberId = 0
    }
    
    enum Action {
        case getMyReviewItem
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
        case let .getMyReviewItem:
            // TODO - 공지사항 API 호출
            let response = await ReviewService.getMyReviewItem()
            if response != nil {
                await MainActor.run {
                    print(response)
                    state.getMyReviewResponse.totalElements = response!.data?.totalElements ?? 0
                    state.getMyReviewResponse.data = response!.data?.data
                    print(state.getMyReviewResponse.totalElements)
                }
            } else {
                print("Error")
            }
        case let .deleteMyReview(id):
            // TODO - 공지사항 API 호출
            let response = await ReviewService.deleteMyReview(id: id)
            print("삭제: \(response)")
        }
    }
}
