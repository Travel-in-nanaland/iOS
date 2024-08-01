//
//  NoticeModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation
struct NoticeMainModel: Codable {
    var totalElements: Int64
    var data: [NoticeData]
}

struct NoticeData: Codable {
    let id: Int64
    let noticeCategory: String
    let title: String
    let createdAt: String
}

