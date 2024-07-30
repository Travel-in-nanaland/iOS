//
//  MyReviewViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/29/24.
//

import Foundation
class MyReviewViewModel: ObservableObject{
    struct State {
        var getMyReviewResponse = MyReviewModel(reviews: [MyReviewModel.Review(id: 1, postId: 1, category: "", placeName: "", rating: 3, content: "", createdAt: "", heartCount: 1, images: ["" : ""], reviewTypeKeywords: [""])])
        
    }
    
    enum Action {
        case getUserInfo
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case .getUserInfo:
            let response = await UserInfoService.getUserInfo()
            if response != nil {
                await MainActor.run {
//                    state.getProfileMainResponse = response!.data
                }
            }
        }
    }
}
