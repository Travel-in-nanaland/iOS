//
//  ReviewKeywordViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewKeywordViewModel: ObservableObject {
    @Published var keywords: [ReviewKeywordModel] = [
        ReviewKeywordModel(text: .anniversary, tag: "ANNIVERSARY"),
        ReviewKeywordModel(text: .cute, tag: "CUTE"),
        ReviewKeywordModel(text: .luxurious, tag: "LUXURY"),
        ReviewKeywordModel(text: .beautiful, tag: "SCENERY"),
        ReviewKeywordModel(text: .kind, tag: "KIND"),
        ReviewKeywordModel(text: .descendant, tag: "CHILDREN"),
        ReviewKeywordModel(text: .friend, tag: "FRIEND"),
        ReviewKeywordModel(text: .parent, tag: "PARENTS"),
        ReviewKeywordModel(text: .alone, tag: "ALONE"),
        ReviewKeywordModel(text: .spouse, tag: "HALF"),
        ReviewKeywordModel(text: .relative, tag: "RELATIVE"),
        ReviewKeywordModel(text: .animal, tag: "PET"),
        ReviewKeywordModel(text: .socket, tag: "OUTLET"),
        ReviewKeywordModel(text: .largeSpace, tag: "LARGE"),
        ReviewKeywordModel(text: .parking, tag: "PARK"),
        ReviewKeywordModel(text: .cleanBathroom, tag: "BATHROOM")
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
