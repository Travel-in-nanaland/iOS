//
//  PreSignedUploadEndPoint.swift
//  NanaLand
//
//  Created by wodnd on 12/26/24.
//

import Foundation
import Alamofire

enum PreSignedUploadEndPoint {
    case uploadToPreSignedURL(preSignedUrl: String, fileData: Data)
    case initializeUpload(fileName: String, fileSize: Int, fileCategory: String, partCount: Int)
    case completeUpload(uploadId: String, fileKey: String, parts: [FileUploadPart])
}

extension PreSignedUploadEndPoint: EndPoint {
    var baseURL: String {
        switch self {
        case .uploadToPreSignedURL:
            return "" // PreSigned URL은 외부 URL이므로 baseURL 필요 없음
        case .initializeUpload, .completeUpload:
            return "\(Secrets.baseUrl)/file"
        }
    }
    
    var path: String {
        switch self {
        case .uploadToPreSignedURL:
            return "" // PreSigned URL은 path가 필요 없음
        case .initializeUpload:
            return "/upload-init"
        case .completeUpload:
            return "/upload-complete"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .uploadToPreSignedURL:
            return .put
        case .initializeUpload, .completeUpload:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .uploadToPreSignedURL:
            return ["Content-Type": "application/octet-stream"]
        case .initializeUpload, .completeUpload:
            return ["Content-Type": "application/json;charset=UTF-8"]
        }
    }
    
    var task: APITask {
        switch self {
        case let .uploadToPreSignedURL(preSignedUrl, fileData):
            return .requestRawData(preSignedUrl: preSignedUrl, fileData: fileData)
        case let .initializeUpload(fileName, fileSize, fileCategory, partCount):
            let body = InitializeUploadRequest(
                originalFileName: fileName,
                fileSize: fileSize,
                fileCategory: fileCategory,
                partCount: partCount
            )
            return .requestJSONEncodable(body: body)
        case let .completeUpload(uploadId, fileKey, parts):
            let body = CompleteUploadRequest(
                uploadId: uploadId,
                fileKey: fileKey,
                parts: parts
            )
            return .requestJSONEncodable(body: body)
        }
    }
}

