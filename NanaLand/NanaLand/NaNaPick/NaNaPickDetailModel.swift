//
//  NaNaPickDetailModel.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation

struct NaNaPickDetailModel: Codable {
    let originUrl: String
    let notice: String?
    let nanaDetails: [DetailInfo]
}

struct DetailInfo: Codable {
    let number: Int32
    let subTitle: String
    let title: String
    let imageUrl: String
    let content: String
    let additionalInfoList: [AdditionalInfo]
    let hashtags: [String]
}

struct AdditionalInfo: Codable {
    let infoKey: String
    let infoValue: String
}

