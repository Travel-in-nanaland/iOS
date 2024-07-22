//
//  ExperienceEndPoint.swift
//  NanaLand
//
//  Created by juni on 7/16/24.
//

import Foundation
import Alamofire

enum ExperienceEndPoint {
    case getExperienceMainItem(experienceType: String, keyword: String, address: String, page: Int, size: Int) // 메인 아이템 조회
    case getExperienceDetailItem(id: Int64, isSearch: Bool) // 상세 조회
}

extension ExperienceEndPoint: EndPoint {
    var baseURL: String {
        // MVP2 테스트용 포트번호 8083
        return "http://13.125.110.80:8083/experience"
    }
    
    var path: String {
        switch self {
        case .getExperienceMainItem:
            return "/list"
        case .getExperienceDetailItem(let id, _):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getExperienceMainItem:
            return .get
        case .getExperienceDetailItem:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .getExperienceMainItem(experienceType, keyword, address, page, size):
            let param = ["experienceType": experienceType, "keywordFilterList": keyword, "addressFilterList": address, "page": page, "size": size] as [String: Any]
            return .requestParameters(parameters: param)
            
        case let .getExperienceDetailItem(_, isSearch):
            let param = ["isSearch": isSearch] as [String: Any]
            return .requestParameters(parameters: param)
        }
    }
}

