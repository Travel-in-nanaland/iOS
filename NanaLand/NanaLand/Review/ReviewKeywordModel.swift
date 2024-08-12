//
//  ReviewKeywordModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

struct ReviewKeywordModel: Identifiable, Hashable {
    let id = UUID()
    let text: LocalizedKey
    let tag: String
    
    static func == (lhs: ReviewKeywordModel, rhs: ReviewKeywordModel) -> Bool {
        return lhs.tag == rhs.tag
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(tag)
    }
}
