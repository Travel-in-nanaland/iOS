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
    case getMyReviewData // 마이페이지 리뷰
    case getAllReviewData(page: Int, size: Int) // 마이페이지 리뷰
    case getPreviewData(memberId: Int64) // 다른 유저 프로필 후기 프리뷰 조회
    case getUserAllReviewData(memberId: Int64, page: Int, size: Int) // 타 유저 모든 리뷰 보기
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
        case .getMyReviewData:
            return "/preview"
        case .getAllReviewData(let page, let size):
            return "/list"
        case .getPreviewData:
            return "/preview"
        case .getUserAllReviewData(let memberId, let page, let size):
            return "/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createReview:
            return .post
        case .getReviewData:
            return .get
        case .getMyReviewData:
            return .get
        case .getAllReviewData:
            return .get
        case .getPreviewData:
            return .get
        case .getUserAllReviewData:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .createReview:
            return ["Content-Type": "multipart/form-data"]
        case .getReviewData:
            return ["Content-Type": "application/json"]
        case .getMyReviewData:
            return ["Content-Type": "application/json"]
        case .getAllReviewData:
            return ["Content-Type": "application/json"]
        case .getPreviewData:
            return ["Content-Type": "application/json"]
        case .getUserAllReviewData:
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
        case let .getMyReviewData:
            return .requestPlain
        case let .getAllReviewData(page, size):
            let param = ["page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        case let .getPreviewData(memberId):
            let param = ["memberId": memberId]
            return .requestParameters(parameters: param)
        case let .getUserAllReviewData(memberId, page, size):
            let param = ["memberId": memberId, "page": page, "size": size] as [String : Any]
            return .requestParameters(parameters: param)
        }
    }
}
