//
//  NotificationService.swift
//  NanaLand
//
//  Created by juni on 8/28/24.
//

import Foundation

struct NotificationService {
    static func getNotification(page: Int, size: Int) async -> BaseResponse<NotificationModel>? {
        return await NetworkManager.shared.request(NotificationEndPoint.getNotification(page: page, size: size))
    }
}
