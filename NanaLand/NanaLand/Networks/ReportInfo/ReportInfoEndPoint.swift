//
//  ReportInfoEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import Foundation
import Alamofire

enum ReportInfoEndPoint {
	case postInfoFixReport(body: ReportInfoRequest, image: [Foundation.Data?])
}

extension ReportInfoEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/report"
	}
	
	var path: String {
		switch self {
		case .postInfoFixReport:
			return "/info-fix"
		}
	}
	
	var method: Alamofire.HTTPMethod {
		switch self {
		case .postInfoFixReport:
			return .post
		}
	}
	
	var task: APITask {
		switch self {
		case .postInfoFixReport(let body, let image):
			return .requestJSONWithImage(multipartFile: image, body: body)
		}
	}
	
	var headers: HTTPHeaders? {
		switch self {
		case .postInfoFixReport:
			return ["Content-Type": "multipart/form-data"]
		}
	}
	
	
}
