//
//  FestivalEndPoint.swift
//  NanaLand
//
//  Created by jun on 5/5/24.
//

import Foundation
import Alamofire

enum FestivalEndPoint {
    case thisMonthFestival(page: Int32, size: Int32, filterName: String, startDate: String, endDate: String)
    case seasonFestival(page: Int32, size: Int32, season: String)
    case pastFestival(page: Int32, size: Int32, filterName: String)
}

extension FestivalEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/festival"
    }
    
    var path: String {
        switch self {
        case .thisMonthFestival:
            return "/this-month"
        case .seasonFestival:
            return "/season"
        case .pastFestival:
            return "/past"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .thisMonthFestival, .seasonFestival, .pastFestival:
            return .get
        }
    }
    
    var task: APITask {
        switch self {
        case let .thisMonthFestival(page, size, filterName, startDate, endDate):
            // addressFilterList는 "ㅁㅁ,ㅁㅁ,ㅁㅁ" 형태로 전달
            let param = ["page": page, "size": size, "addressFilterList": filterName , "startDate": startDate, "endDate": endDate] as [String : Any]
            print(param)
            return .requestParameters(parameters: param)
            
        case let .seasonFestival(page, size, season):
            let param = ["page": page, "size": size, "season": season] as [String: Any]
            return .requestParameters(parameters: param)
            
        case let .pastFestival(page, size, filterName):
            let param = ["page": page, "size": size, "addressFilterList": filterName] as [String: Any]
            return .requestParameters(parameters: param)
        }
    }
}
