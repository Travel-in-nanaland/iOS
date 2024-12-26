//
//  FileService.swift
//  NanaLand
//
//  Created by juni on 12/10/24.
//

import Foundation


struct FileService {
    static func postFileUpload(body: ReviewS3UploadDTO) async -> BaseResponse<ReviewS3UploadModel>? {
        return await NetworkManager.shared.request(FileEndPoint.postFileUpload(body: body))
    }
    
    static func completeFileUpload(body: ReviewS3UploadCompleteDTO) async -> BaseResponse<ReviewS3UploadCompleteModel>? {
        return await NetworkManager.shared.request(FileEndPoint.completeFileUpload(body: body))
    }
    
    static func uploadImageToS3(presignedURL: URL, imageData: Data, mimeType: String) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(FileEndPoint.uploadImageToS3(presignedURL: presignedURL, imageData: imageData, mimeType: mimeType))
        
    }
}
