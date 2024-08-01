//
//  ReviewWriteViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewWriteViewModel: ObservableObject {
    struct State {
        // 리뷰 쓰기위해서 페이지 들어왔을때 필요한 응답
        var getReviewWriteResponse = ReviewWriteModel(id: 1, originUrl: "", title: "월정 투명카약", address: "제주특별자치도 제주시 구좌읍 월정리 1400-33", rating: 0, content: "", imgCnt: 0)
        // 리뷰 올렸을 때 오는 응답(status는 필요할듯)
        var getReviewPostResponse = ReviewPostModel(status: 0, message: "", data: ReviewPostData(reviewKeywords: "", rating: "", content: ""))
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
                await MainActor.run {
                    state.getReviewPostResponse.status = response!.status
                }
  
            }
        }
    }
}
