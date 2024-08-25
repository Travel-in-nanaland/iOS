//
//  ReportDTO.swift
//  NanaLand
//
//  Created by juni on 8/25/24.
//

import Foundation

struct ReportDTO: Codable {
    var id: Int?
    var reportType: String?
    var claimType: String?
    var content: String?
    var email: String?
}
