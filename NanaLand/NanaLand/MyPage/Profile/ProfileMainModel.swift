//
//  ProfileMainModel.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation

struct ProfileMainModel: Codable {
    let email: String
    let provider: String
    var profileImageUrl: String
    var nickname: String
    var description: String
    let level: Int
    let travelType: String
    let hashtags: [String]
}
