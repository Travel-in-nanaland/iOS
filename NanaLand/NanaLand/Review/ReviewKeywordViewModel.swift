//
//  ReviewKeywordViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewKeywordViewModel: ObservableObject {
    @Published var keywords: [ReviewKeywordModel] = [
        ReviewKeywordModel(text: .ANNIVERSARY, tag: "ANNIVERSARY"),
        ReviewKeywordModel(text: .CUTE, tag: "CUTE"),
        ReviewKeywordModel(text: .LUXURY, tag: "LUXURY"),
        ReviewKeywordModel(text: .SCENERY, tag: "SCENERY"),
        ReviewKeywordModel(text: .KIND, tag: "KIND"),
        ReviewKeywordModel(text: .CHILDREN, tag: "CHILDREN"),
        ReviewKeywordModel(text: .FRIEND, tag: "FRIEND"),
        ReviewKeywordModel(text: .PARENTS, tag: "PARENTS"),
        ReviewKeywordModel(text: .ALONE, tag: "ALONE"),
        ReviewKeywordModel(text: .HALF, tag: "HALF"),
        ReviewKeywordModel(text: .RELATIVE, tag: "RELATIVE"),
        ReviewKeywordModel(text: .PET, tag: "PET"),
        ReviewKeywordModel(text: .OUTLET, tag: "OUTLET"),
        ReviewKeywordModel(text: .LARGE, tag: "LARGE"),
        ReviewKeywordModel(text: .PARK, tag: "PARK"),
        ReviewKeywordModel(text: .BATHROOM, tag: "BATHROOM")
    ]
    
    @Published var selectKeywords: Set<ReviewKeywordModel> = []
    @Published var showAlert = false
    weak var reviewWriteViewModel: ReviewWriteViewModel?
    weak var reviewDetailWriteViewModel: MyReviewDetailViewModel?
    
    // 초기화 시 선택된 키워드를 받아 초기화
    init(selectedKeywords: [ReviewKeywordModel] = []) {
        updateSelectedKeywords(selectedKeywords)
    }
    
    func updateSelectedKeywords(_ keywords: [ReviewKeywordModel]) {
            // 기존 선택된 키워드에 서버에서 받아온 키워드를 추가
            selectKeywords = Set(keywords.filter { keyword in
                // keywords 리스트에서 태그가 동일한 키워드를 찾아 selectKeywords에 추가
                return self.keywords.contains(where: { $0.tag == keyword.tag })
            })
        }
    
    func toggleKeywordSelection(_ keyword: ReviewKeywordModel) {
        if selectKeywords.contains(keyword) {
            selectKeywords.remove(keyword)
        } else {
            if selectKeywords.count < 6 {
                selectKeywords.insert(keyword)
            } else {
                showAlert = true
            }
        }
        reviewWriteViewModel?.updateSelectedKeywords(Array(selectKeywords))
        reviewDetailWriteViewModel?.updateSelectedKeywords(Array(selectKeywords))
    }
}
