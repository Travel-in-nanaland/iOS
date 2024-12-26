//
//  ReportWriteViewModel.swift
//  NanaLand
//
//  Created by juni on 8/25/24.
//

import Foundation

class ReportWriteViewModel: ObservableObject {
    
    struct State {
        var imgCnt = 0
        var getReportResponse = ReportModel(status: 0, message: "")
        var reportDTO = ReportDTO(id: nil, reportType: "REVIEW", claimType: nil, content: nil, email: "duthd3@naver.com", fileKeys: [])
    }
    
    enum Action {
        case postReport(body: ReportDTO, multipartFile: [Foundation.Data?])
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func updateImageCount(_ count: Int) {
        state.imgCnt = count
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .postReport(body, multipartFile):
            
            var eTags: [FileUploadPart] = []
            var uploadIdAndFileKeys: [(uploadId: String, fileKey: String)] = []
            
            // nil이 아닌 데이터만 필터링
            let validImages = multipartFile.compactMap { $0 }
            if !validImages.isEmpty {
                for (index, imageData) in validImages.enumerated(){
                    // 1. 파일 업로드 초기화 요청
                    guard let initResponse = await PreSignedUploadService.initializeFileUpload(
                        fileName: "report_image_\(index).jpg",
                        fileSize: imageData.count,
                        fileCategory: "CLAIM_REPORT",
                        partCount: 1)
                    else{
                        await MainActor.run{
                            self.state.getReportResponse.message = "파일 업로드 초기화에 실패했습니다."
                        }
                        return
                    }
                    
                    guard let preSignedUrlInfo = initResponse.data?.presignedUrlInfos.first,
                          let uploadId = initResponse.data?.uploadId,
                          let fileKey = initResponse.data?.fileKey else {
                        await MainActor.run {
                            self.state.getReportResponse.message = "PreSigned URL 정보를 가져오지 못했습니다."
                        }
                        return
                    }
                    // 메인 스레드에서 fileKey 추가
                    await MainActor.run {
                        self.state.reportDTO.fileKeys.append(fileKey)
                    }
                    uploadIdAndFileKeys.append((uploadId: uploadId, fileKey: fileKey))
                    
                    // 2. 파일 업로드
                    guard let eTag = await PreSignedUploadService.uploadFileToPreSignedURL(
                        preSignedUrl: preSignedUrlInfo.preSignedUrl,
                        fileData: imageData)
                    else {
                        await MainActor.run {
                            self.state.getReportResponse.message = "파일 업로드에 실패했습니다."
                        }
                        return
                    }
                    
                    // 3. eTag와 partNumber 저장
                    eTags.append(FileUploadPart(partNumber: preSignedUrlInfo.partNumber, eTag: eTag))
                }
                
                // 4. 모든 파일 업로드 완료 후 업로드 완료 요청
                for (index, uploadInfo) in uploadIdAndFileKeys.enumerated() {
                    let parts = [eTags[index]]
                    
                    guard let completeResponse = await PreSignedUploadService.completeFileUpload(
                        uploadId: uploadInfo.uploadId,
                        fileKey: uploadInfo.fileKey,
                        parts: parts)
                    else {
                        await MainActor.run{
                            self.state.getReportResponse.message = "업로드 완료 요청에 실패했습니다."
                        }
                        return
                    }
                }
                
                print("모든 파일 업로드 완료!")
            }
            
            let response = await ReportService.postReport(body: body)
            if response != nil {
                await MainActor.run {
                    state.getReportResponse.status = response!.status
                    print(response!.message)
                }
            }
        }
    }
}
