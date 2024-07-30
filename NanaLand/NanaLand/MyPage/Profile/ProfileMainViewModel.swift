//
//  ProfileMainViewModel.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation

class ProfileMainViewModel: ObservableObject {
    struct State {
        var getProfileMainResponse = ProfileMainModel(consentItems: [], email: "", provider: "", profileImageUrl: "", nickname: "", description: "", level: 0, travelType: "", hashtags: [""], reviews: [ProfileMainModel.Review(id: 1, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트 내용입니다.", createdAt: "2024-06-12", heartCount: 4, images: ["" : ""], reviewTypeKeywords: [""]), ProfileMainModel.Review(id: 2, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트 내용입니다.", createdAt: "2024-06-12", heartCount: 4, images: ["" : ""], reviewTypeKeywords: [""]), ProfileMainModel.Review(id: 3, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트 내용입니다.", createdAt: "2024-06-12", heartCount: 4, images: ["" : ""], reviewTypeKeywords: [""])], notices: [ProfileMainModel.Notice(id: 1, type: "공지사항", imageUrl: "https://github.com/user-attachments/assets/05bf3472-2745-44f8-a9bc-1480595e806a", title: "6월 4주차 공지", date: "2024.06.12", content: "내용입니다."), ProfileMainModel.Notice(id: 2, type: "공지사항", imageUrl: "", title: "6월 4주차 공지", date: "2024.06.12", content: "내용입니다."), ProfileMainModel.Notice(id: 3, type: "공지사항", imageUrl: "https://github.com/user-attachments/assets/05bf3472-2745-44f8-a9bc-1480595e806a", title: "6월 4주차 공지", date: "2024.06.12", content: "내용입니다.")])
        
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
                    state.getProfileMainResponse = response!.data
                }
            }
        }
    }
}
