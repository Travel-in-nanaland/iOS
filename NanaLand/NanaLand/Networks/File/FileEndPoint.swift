//
//  FileEndPoint.swift
//  NanaLand
//
//  Created by juni on 12/10/24.
//

import Foundation
import Alamofire

enum FileEndPoint {
    case postFileUpload(body: ReviewS3UploadDTO)
    case completeFileUpload(body: ReviewS3UploadCompleteDTO)
    case uploadImageToS3(presignedURL: URL, imageData: Data, mimeType: String)
}

extension FileEndPoint: EndPoint {
    var baseURL: String {
        return "\(Secrets.baseUrl)/file"
    }
    
    var path: String {
        switch self {
        case .uploadImageToS3(let presignedURL, let imageData, let mimeType):
            return "\(presignedURL)"
        case .postFileUpload(let body):
            return "/upload-init"
        case .completeFileUpload(let body):
            return "/upload-complete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadImageToS3:
            return .put
        case .postFileUpload:
            return .post
        case .completeFileUpload:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .uploadImageToS3(let presignedURL, let imageData, let mimeType):
            return ["Content-Type": "\(mimeType)"]
        case .postFileUpload(body: let body):
            return ["Content-Type": "application/json"]
        case .completeFileUpload(body: let body):
            return ["Content-Type": "application/json"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .uploadImageToS3(presignedURL, imageData, mimeType):
            return .requestImageToS3(presignedURL: presignedURL, imageData: imageData, mimeType: mimeType)// 추후 수정 필요
        case let .postFileUpload(body):
            return .requestJSONEncodable(body: body)
        case let .completeFileUpload(body):
            return .requestJSONEncodable(body: body)
        }
    }
}
