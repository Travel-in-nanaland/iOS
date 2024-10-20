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
        var deleteMyReviewResponse = EmptyResponseModel()
        var page = 0
    }
    
    enum Action {
        case getMyAllReviewItem(page: Int, size: Int)
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
        case let .getMyAllReviewItem(page, size):
            // TODO - 공지사항 API 호출
            let response = await ReviewService.getMyAllReviewItem(page: page, size: size)
            if let responseData = response!.data {
                await MainActor.run {
                    print(response)
                    state.getMyAllReviewResponse.totalElements = responseData.totalElements
                    state.getMyAllReviewResponse.data!.append(contentsOf: response!.data?.data ?? [])
                    print(state.getMyAllReviewResponse.totalElements)
                }
            } else {
                print("Error")
            }
            
        case let .deleteMyReview(id):
            // TODO - 공지사항 API 호출
            let response = await ReviewService.deleteMyReview(id: id)
            if response != nil {
                await MainActor.run {
                    if let index = state.getMyAllReviewResponse.data?.firstIndex(where: { $0.id == id }) {
                        state.getMyAllReviewResponse.data?.remove(at: index)
                        state.getMyAllReviewResponse.totalElements -= 1
                    }
                }
            } else {
                print("Error")
            }
        }
    }
}
