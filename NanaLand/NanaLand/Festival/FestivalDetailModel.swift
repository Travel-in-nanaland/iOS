//
//  FestivalDetailModel.swift
//  NanaLand
//
//  Created by jun on 5/16/24.
//

import Foundation

struct FestivalDetailModel: Codable {
    let id: Int64
    let originUrl: String
    let addressTag: String
    let title: String
    let content: String
    let address: String
    let contact: String
    let time: String
    let fee: String
    let homepage: String
    let period: String
    var favorite: Bool
}
