//
//  NoticeService.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation

struct NoticeService {
    static func getNoticeMainItem(page: Int, size: Int) async -> BaseResponse<NoticeMainModel>? {
        return await NetworkManager.shared.request(NoticeEndPoint.getNoticeMainItem(page: page, size: size))
    }
    
    static func getNoticeDetailItem(id: Int64) async -> BaseResponse<NoticeDetailModel>? {
        return await
        NetworkManager.shared.request(NoticeEndPoint.getNoticeDetailItem(id: id))
    }
}

