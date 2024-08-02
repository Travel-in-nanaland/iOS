//
//  NaNaPickDetailModel.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation

struct NaNaPickDetailModel: Codable {
    let subHeading: String
    let heading: String
    let version: String
    let firstImage: NanaPickDetailImageList
    let notice: String?
    let nanaDetails: [DetailInfo]
    let favorite: Bool
}

struct DetailInfo: Codable {
    let number: Int32
    let subTitle: String
    let title: String
    let images: [NanaPickDetailImageList]
    let content: String
    let additionalInfoList: [AdditionalInfo]
    let hashtags: [String]
}

struct AdditionalInfo: Codable {
    let infoEmoji: String
    let infoKey: String
    let infoValue: String
}

struct NanaPickDetailImageList: Codable {
    let originUrl: String
    let thumbnailUrl: String
}
