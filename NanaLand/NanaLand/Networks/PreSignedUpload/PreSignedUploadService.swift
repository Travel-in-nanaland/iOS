//
//  PreSignedUploadService.swift
//  NanaLand
//
//  Created by wodnd on 12/26/24.
//

import Foundation

struct FileUploadInitResponseModel: Codable {
    let uploadId: String
    let fileKey: String
    let presignedUrlInfos: [PreSignedUrlInfo]
}

struct PreSignedUrlInfo: Codable {
    let partNumber: Int
    let preSignedUrl: String
}

struct FileUploadPart: Codable {
    let partNumber: Int
    let eTag: String
}

struct PreSignedUploadService{
    // 1. 파일 업로드 초기화 요청
    static func initializeFileUpload(fileName: String, fileSize: Int, fileCategory: String, partCount: Int) async -> BaseResponse<FileUploadInitResponseModel>? {
        return await NetworkManager.shared.request(PreSignedUploadEndPoint.initializeUpload(fileName: fileName, fileSize: fileSize, fileCategory: fileCategory, partCount: partCount))
    }
    
    // 2. PreSigned URL 파일 전송 및 ETag 반환
    static func uploadFileToPreSignedURL(preSignedUrl: String, fileData: Data) async -> String? {
        let endPoint = PreSignedUploadEndPoint.uploadToPreSignedURL(preSignedUrl: preSignedUrl, fileData: fileData)
        let request = NetworkManager.shared.makeDataRequest(endPoint)

        do {
            // Alamofire의 serializingData() 메서드를 사용하여 AFDataResponse를 반환받습니다.
            let response = try await request.serializingData().response
            
            if let httpResponse = response.response,
               httpResponse.statusCode == 200,
               let eTag = httpResponse.headers.value(for: "ETag") {
                return eTag
            } else {
                print("HTTP 응답 상태 코드가 200이 아닙니다.")
                return nil
            }
        } catch {
            print("파일 업로드 오류: \(error.localizedDescription)")
            return nil
        }
    }
    
    // 3. 업로드 완료 요청
    static func completeFileUpload(uploadId: String, fileKey: String, parts: [FileUploadPart]) async -> BaseResponse<EmptyResponseModel>? {
        return await NetworkManager.shared.request(PreSignedUploadEndPoint.completeUpload(uploadId: uploadId, fileKey: fileKey, parts: parts))
    }
}
