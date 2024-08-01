//
//  MyAllReviewViewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//
import Foundation

class MyAllReviewViewModel: ObservableObject {
    struct State {
        var getMyAllReviewResponse = MyAllReviewModel(totalElements: 0, data: [])
    }
    
    enum Action {
        case getMyAllReviewItem(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getMyAllReviewItem(page, size):
            // TODO - 공지사항 API 호출
            let response = await ReviewService.getMyAllReviewItem(page: page, size: size)
            if response != nil {
                await MainActor.run {
                    print(response)
                    state.getMyAllReviewResponse.totalElements = response!.data?.totalElements ?? 0
                    state.getMyAllReviewResponse.data = response!.data?.data
                    print(state.getMyAllReviewResponse.totalElements)
                }
            } else {
                print("Error")
            }
        }
    }
}
