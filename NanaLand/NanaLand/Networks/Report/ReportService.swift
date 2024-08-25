//
//  ReportService.swift
//  NanaLand
//
//  Created by juni on 8/25/24.
//

import Foundation

struct ReportService {
    static func postReport(body: ReportDTO, multipartFile: [Foundation.Data?]) async -> BaseResponse<ReportModel>? {
        return await NetworkManager.shared.request(ReportEndPoint.postReport(body: body, multipartFile: multipartFile))
    }
}
