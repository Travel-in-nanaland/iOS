//
//  ReviewKeywordModel.swift
//  NanaLand
//
//  Created by wodnd on 7/9/24.
//

import Foundation

struct ReviewKeywordModel: Identifiable, Hashable {
    let id = UUID()
    let text: LocalizedKey
}

