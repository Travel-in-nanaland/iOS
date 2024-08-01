//
//  UserProfileMainViewModel.swift
//  NanaLand
//
//  Created by juni on 8/1/24.
//

import Foundation

class UserProfileMainViewModel: ObservableObject {
    struct State {
        var getUserPreviewResponse = PreviewReviewModel(totalElements: 0, data: [PreviewData(id: 0, postId: 0, category: "", placeName: "", createdAt: "", heartCount: 0, imageFileDto: nil)])
    }
    
    enum Action {
        case getUserPreviewResponse(memberId: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getUserPreviewResponse(memberId):
            let response = await ReviewService.getPreviewData(memberId: memberId)
            if response != nil {
                await MainActor.run {
                    state.getUserPreviewResponse = response!.data!
                    print("\(state.getUserPreviewResponse.data)")
                    print("\(state.getUserPreviewResponse.totalElements)")
                }
            }
        }
    }
}
