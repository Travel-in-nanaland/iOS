//
//  NewNanaPickDetailModel.swift
//  NanaLand
//
//  Created by wodnd on 8/22/24.
//

import Foundation
struct NewNanaPickDetailModel: Codable {
    let id: Int64
    let subHeading: String
    let heading: String
    let version: String
    let firstImage: NewNanaPickDetailImageList
    let notice: String?
    let nanaDetails: [NewDetailInfo]
    var favorite: Bool
}

struct NewDetailInfo: Codable {
    let number: Int32
    let subTitle: String
    let title: String
    let images: [NewNanaPickDetailImageList]
    let content: String
    let additionalInfoList: [NewAdditionalInfo]
    let hashtags: [String]
}

struct NewAdditionalInfo: Codable {
    let infoEmoji: String
    let infoKey: String
    let infoValue: String
}

struct NewNanaPickDetailImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
