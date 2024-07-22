//
//  ReviewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/7/24.
//

import Foundation

struct ReviewWriteModel: Codable {
    let id: Int64
    var originUrl: String
    var title: String
    var address: String
    var rating: Int
    var content: String
    var imgCnt: Int
    //이미지 데이터 추가
}
