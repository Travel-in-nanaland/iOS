//
//  ReviewDetailKeywordModel.swift
//  NanaLand
//
//  Created by wodnd on 8/11/24.
//

import Foundation

struct ReviewDetailKeywordModel: Identifiable, Hashable {
    let id = UUID()
    let text: LocalizedKey
    let tag: String
}
