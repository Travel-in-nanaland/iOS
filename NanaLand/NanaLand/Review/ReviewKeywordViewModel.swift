//
//  ReviewKeywordViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewKeywordViewModel: ObservableObject {
    @Published var keywords: [ReviewKeywordModel] = [
        ReviewKeywordModel(text: .anniversary),
        ReviewKeywordModel(text: .cute),
        ReviewKeywordModel(text: .luxurious),
        ReviewKeywordModel(text: .beautiful),
        ReviewKeywordModel(text: .kind),
        ReviewKeywordModel(text: .descendant),
        ReviewKeywordModel(text: .friend),
        ReviewKeywordModel(text: .parent),
        ReviewKeywordModel(text: .alone),
        ReviewKeywordModel(text: .spouse),
        ReviewKeywordModel(text: .relative),
        ReviewKeywordModel(text: .animal),
        ReviewKeywordModel(text: .socket),
        ReviewKeywordModel(text: .largeSpace),
        ReviewKeywordModel(text: .parking),
        ReviewKeywordModel(text: .cleanBathroom)
    ]
    
    @Published var selectKeywords: Set<ReviewKeywordModel> = []
    @Published var showAlert = false
    weak var reviewWriteViewModel: ReviewWriteViewModel?
    
    func updateSelectedKeywords(_ keywords: [ReviewKeywordModel]) {
        self.selectKeywords = Set(keywords)
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
    }
}
