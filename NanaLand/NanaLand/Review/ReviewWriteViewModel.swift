//
//  ReviewWriteViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewWriteViewModel: ObservableObject {
    struct State {
        var getReviewWriteResponse = ReviewWriteModel(id: 1, originUrl: "", title: "월정 투명카약", address: "제주특별자치도 제주시 구좌읍 월정리 1400-33", rating: 0, content: "", imgCnt: 0)
        var getReviewPostResponse = EmptyResponseModel()
        var reviewDTO = ReviewDTO(rating: 0, content: "", reviewKeywords: [])
    }
    
    enum Action {
        case postReview(id: Int64, category: String, body: ReviewDTO, multipartFile: [Foundation.Data?])
    }
    
    @Published var state: State
    @Published var selectedKeyword: [ReviewKeywordModel] = []
    @Published var keywordViewModel: ReviewKeywordViewModel
    
    init(state: State = .init()) {
        self.state = state
        self.keywordViewModel = ReviewKeywordViewModel()
        self.keywordViewModel.reviewWriteViewModel = self
    }
    
    func updateRating(_ rating: Int) {
        state.getReviewWriteResponse.rating = rating
    }
    
    func updateImageCount(_ count: Int) {
        state.getReviewWriteResponse.imgCnt = count
    }
    
    func updateSelectedKeywords(_ keywords: [ReviewKeywordModel]) {
        self.selectedKeyword = keywords
        keywordViewModel.updateSelectedKeywords(keywords)
    }
    
    func removeKeyword(_ keyword: ReviewKeywordModel) {
        if let index = selectedKeyword.firstIndex(of: keyword) {
            selectedKeyword.remove(at: index)
            updateSelectedKeywords(selectedKeyword)
        }
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .postReview(id, category, body, multipartFile):
            let response = await ReviewService.getReviewItem(id: id, category: category, body: body, multipartFile: multipartFile)
            if response != nil {
                print(response!.message)
                print(response!.status)
            }
        }
    }
}
