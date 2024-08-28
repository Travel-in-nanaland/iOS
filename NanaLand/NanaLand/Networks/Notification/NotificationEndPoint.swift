//
//  NotificationEndPoint.swift
//  NanaLand
//
//  Created by juni on 8/28/24.
//

import Foundation
import Alamofire

enum NotificationEndPoint {
    case getNotification(page: Int, size: Int)
}

extension NotificationEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/notification"
    }
    
    var path: String {
        switch self {
        case .getNotification:
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNotification:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getNotification:
            return ["application": "json"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .getNotification(page, size):
            let param = ["page": page, "size": size]
            return .requestParameters(parameters: param)
        }
    }
}
