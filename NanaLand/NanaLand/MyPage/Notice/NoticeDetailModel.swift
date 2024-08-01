//
//  NoticeDetailModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation
struct NoticeDetailModel: Codable {
    let title: String
    let createdAt: String
    let noticeContents: [Notice]?
}

struct NoticeDetailImagesList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}

struct Notice: Codable {
    let image: NoticeDetailImagesList?
    let content: String?
}
