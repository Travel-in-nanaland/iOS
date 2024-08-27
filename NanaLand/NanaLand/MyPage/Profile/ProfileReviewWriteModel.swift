//
//  ProfileReviewWriteModel.swift
//  NanaLand
//
//  Created by juni on 8/27/24.
//

import Foundation

struct ProfileReviewWriteModel: Codable {
    let id: Int64?
    let category: String?
    let categoryValue: String?
    let title: String?
    let firstImage: ImageList?
    let address: String?
}
