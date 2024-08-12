//
//  MyReviewDetailViewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/11/24.
//

import Foundation

class MyReviewDetailViewModel: ObservableObject {
    struct State {
        // 리뷰 쓰기위해서 페이지 들어왔을때 필요한 응답
        var getReviewModifyResponse = ReviewWriteModel(id: 1, originUrl: "", title: "월정 투명카약", address: "제주특별자치도 제주시 구좌읍 월정리 1400-33", rating: 0, content: "", imgCnt: 0)
        // 리뷰 올렸을 때 오는 응답(status는 필요할듯)
        var modifyMyReviewResponse = ReviewModifyModel(status: 0, message: "", data: ReviewModifyData(reviewKeywords: "", rating: "", content: ""))
        var editReviewDto = EditReviewDto(rating: 0, content: "", reviewKeywords: [], editImageInfoList: [EditImageInfoDto(id: 0, newImage: true)])
        var getReviewDetailResponse = MyReviewDetailModel(id: 0, firstImage: ImageList(originUrl: "", thumbnailUrl: ""), title: "", address: "", rating: 0, content: "", images: [MyReviewDetailImage(id: 0, originUrl: "", thumbnailUrl: "")], reviewKeywords: [""])
    }
    
    enum Action {
        case getReviewDetail(id: Int64)
        case modifyMyReview(id: Int64, body: EditReviewDto, multipartFile: [Foundation.Data?])
    }
    
    @Published var state: State
    @Published var selectedKeyword: [ReviewKeywordModel] = []
    @Published var keywordViewModel: ReviewKeywordViewModel
    
    init(state: State = .init()) {
        self.state = state
        self.keywordViewModel = ReviewKeywordViewModel()
        self.keywordViewModel.reviewDetailWriteViewModel = self
    }
    
    func updateRating(_ rating: Int) {
        state.editReviewDto.rating = rating
    }
    
    func updateImageCount(_ count: Int) {
        state.getReviewModifyResponse.imgCnt = count
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
        case let .getReviewDetail(id):
            let response = await ReviewService.getMyReviewDetail(id: id)
            if response != nil {
                if let responseData = response?.data {
                    await MainActor.run {
                        state.getReviewDetailResponse = responseData
                        print(responseData)
                        
                        // 서버로부터 받은 키워드를 selectedKeyword에 저장
                        let keywords = responseData.reviewKeywords.map { keyword in
                            ReviewKeywordModel(text: LocalizedKey(rawValue: keyword) ?? .keyword, tag: keyword)
                        }
                        updateSelectedKeywords(keywords)
                        updateRating(responseData.rating)
                    }
                }
            }
        case let .modifyMyReview(id, body, multipartFile):
            let response = await ReviewService.modifyMyReview(id: id, body: body, multipartFile: multipartFile)
            print(response)
            if response != nil {
                if let responseData = response?.data {
                    await MainActor.run {
                        state.modifyMyReviewResponse.status = response!.status
                        
                    }
                }
            }
        }
    }
}


