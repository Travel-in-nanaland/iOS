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
    case getReviewData(id: Int64, category: String, page: Int, size: Int) // 후기 조회
    case getPreviewData(memberId: Int64) // 다른 유저 프로필 후기 프리뷰 조회
}

extension ReviewEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/review"
    }
    
    var path: String {
        switch self {
        case .createReview(let id, let category, let body, let multipartFile):
            return "/\(id)"
        case .getReviewData(let id, let category, let page, let size):
            return "/list/\(id)"
        case .getPreviewData:
            return "/preview"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        case .getReviewData:
            return .get
        case .getPreviewData:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .createReview:
            return ["Content-Type": "multipart/form-data"]
        case .getReviewData:
            return ["Content-Type": "application/json"]
        case .getPreviewData:
            return ["Content-Type": "application/json"]
        }
       
    }
    
    var task: APITask {
        switch self {
        case let .createReview(id, category, body, multipartFile):
            let param = ["category": category]
            return .requestJSONWithImageWithParam(multipartFile: multipartFile, body: body, parameters: param)
        case let .getReviewData(id, category, page, size):
            let param = ["category": category, "page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        case let .getPreviewData(memberId):
            let param = ["memberId": memberId]
            return .requestParameters(parameters: param)
        }
    }
}
