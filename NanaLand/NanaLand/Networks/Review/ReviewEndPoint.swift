//
//  ReviewEndPoint.swift
//  NanaLand
//
//  Created by juni on 7/22/24.
//

import Foundation
import Alamofire

enum ReviewEndPoint {
    case createReview(id: Int64, category: String, body: ReviewDTO, multipartFile: [Foundation.Data?])
}

extension ReviewEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/review"
    }
    
    var path: String {
        switch self {
        case .createReview(let id, let category, let body, let multipartFile):
            return "/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "multipart/form-data"]
    }
    
    var task: APITask {
        switch self {
        case let .createReview(id, category, body, multipartFile):
            let param = ["category": category]
            return .requestJSONWithImageWithParam(multipartFile: multipartFile, body: body, parameters: param)
            
        }
    }
}
