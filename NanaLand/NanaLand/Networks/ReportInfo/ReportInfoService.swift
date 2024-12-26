//
//  ReportInfoService.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import Foundation
import Alamofire

struct ReportInfoService {
	static func postInfoFixReport(body: ReportInfoRequest) async -> BaseResponse<ReportInfoResponse>? {
		return await NetworkManager.shared.request(ReportInfoEndPoint.postInfoFixReport(body: body))
	}
}
