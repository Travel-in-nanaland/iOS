//
//  ReportEndPoint.swift
//  NanaLand
//
//  Created by juni on 8/25/24.
//

import Foundation
import Alamofire

enum ReportEndPoint {
    case postReport(body: ReportDTO, multipartFile: [Foundation.Data?])
}


extension ReportEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/report"
    }
    
    var path: String {
        switch self {
        case .postReport(let body, let multipartFile):
            return "/claim"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postReport:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .postReport:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .postReport(body, multipartFile):
            return .requestJSONWithImageList(multipartFile: multipartFile, body: body, withInterceptor: true)
        }
    }
}
