//
//  NotificationModel.swift
//  NanaLand
//
//  Created by juni on 8/28/24.
//

import Foundation

struct NotificationModel: Codable {
    let totalElements: Int64?
    let data: [NotificationItem]?
}

struct NotificationItem: Codable {
    let notificationId: Int64
    let clickEvent: String
    let category: String
    let contentId: Int64
    let title: String
    let content: String
    let createdAt: String
}
