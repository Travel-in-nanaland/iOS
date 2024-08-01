//
//  NoticeEndpoint.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation
import Alamofire

enum NoticeEndPoint {
    case getNoticeMainItem(page: Int, size: Int) // 메인 아이템 조회
    case getNoticeDetailItem(id: Int64) // 상세 조회
}

extension NoticeEndPoint: EndPoint {
    var baseURL: String {
        // MVP2 테스트용 포트번호 8083
        return "http://13.125.110.80:8083/notice"
    }
    
    var path: String {
        switch self {
        case .getNoticeMainItem:
            return "/list"
        case .getNoticeDetailItem(let id):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNoticeMainItem:
            return .get
        case .getNoticeDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNoticeMainItem(page, size):
            let param = ["page": page, "size": size] as [String: Any]
            return .requestParameters(parameters: param)
            
        case let .getNoticeDetailItem(_):
            return .requestPlain
        }
    }
}

