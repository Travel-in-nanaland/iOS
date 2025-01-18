//
//  ReportInfoViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import Foundation

@MainActor
class ReportInfoViewModel: ObservableObject {
    struct State {
        var postId: Int64 = 0
        var category: Category = .activity
        var fixType: ReportInfoType = .priceInfo
        var fileKeys: [String] = []
        var showEmailErrorMessage: Bool = false
        
        var isLoading: Bool = false
    }
    
    enum Action {
        case onTapReportItem(type: ReportInfoType)
        case onTapSendButton(image: [Foundation.Data?], content: String, email: String)
        case onTapGoToContentButton
        case onTapReportAgainButton
    }
    
    @Published var state: State
    @Published var imageCnt: Int = 0
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func updateImageCount(_ count: Int) {
        imageCnt = count
    }
    
    func action(_ action: Action) async {
        switch action {
        case .onTapReportItem(let type):
            reportItemTapped(type: type)
        case let .onTapSendButton(image, content, email):
            //			await sendButtonTapped(image: image, content: content, email: email)
            var eTags: [FileUploadPart] = []
            var uploadIdAndFileKeys: [(uploadId: String, fileKey: String)] = []
            
            // nil이 아닌 데이터만 필터링
            let validImages = image.compactMap { $0 }
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
                            print("파일 업로드 초기화에 실패했습니다.")
                        }
                        return
                    }
                    
                    guard let preSignedUrlInfo = initResponse.data?.presignedUrlInfos.first,
                          let uploadId = initResponse.data?.uploadId,
                          let fileKey = initResponse.data?.fileKey else {
                        await MainActor.run {
                            print("PreSigned URL 정보를 가져오지 못했습니다.")
                        }
                        return
                    }
                    // 메인 스레드에서 fileKey 추가
                    await MainActor.run {
                        self.state.fileKeys.append(fileKey)
                    }
                    uploadIdAndFileKeys.append((uploadId: uploadId, fileKey: fileKey))
                    
                    // 2. 파일 업로드
                    guard let eTag = await PreSignedUploadService.uploadFileToPreSignedURL(
                        preSignedUrl: preSignedUrlInfo.preSignedUrl,
                        fileData: imageData)
                    else {
                        await MainActor.run {
                            print("파일 업로드에 실패했습니다.")
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
                            print("업로드 완료 요청에 실패했습니다.")
                        }
                        return
                    }
                }
                
                print("모든 파일 업로드 완료!")
            }
            
            let request = ReportInfoRequest(
                postId: state.postId,
                fixType: state.fixType.name,
                category: {
                    switch state.category {
                    case .activity:
                        return "EXPERIENCE"
                    case .cultureAndArts:
                        return "EXPERIENCE"
                    default:
                        return state.category.uppercase
                    }
                }(),
                content: content,
                email: email,
                fileKeys: state.fileKeys
            )
            
            let response = await ReportInfoService.postInfoFixReport(body: request)
            if response != nil {
                await MainActor.run {
                    print(response!.message)
                }
            }
        case .onTapGoToContentButton:
            gotoContentButtonTapped()
        case .onTapReportAgainButton:
            reportAgainButtonTapped()
        }
    }
    
    func reportItemTapped(type: ReportInfoType) {
        state.fixType = type
        AppState.shared.navigationPath.append(ReportInfoViewType.reportWriting)
    }
    
    //	func sendButtonTapped(image: [Foundation.Data?], content: String, email: String) async {
    //		state.showEmailErrorMessage = false
    //		guard email.isValidEmail() else {
    //			state.showEmailErrorMessage = true
    //			return
    //		}
    //		let request = ReportInfoRequest(
    //			postId: state.postId,
    //			fixType: state.fixType.name,
    //			category: state.category.uppercase,
    //			content: content,
    //			email: email
    //		)
    //		state.isLoading = true
    //		let result = await ReportInfoService.postInfoFixReport(body: request, image: image)
    //		state.isLoading = false
    //
    //		if result?.status == 200 {
    //			AppState.shared.navigationPath.append(ReportInfoViewType.reportResult)
    //		} else if result?.status == 400 {
    //			state.showEmailErrorMessage = true
    //		}
    //	}
    
    func gotoContentButtonTapped() {
        AppState.shared.navigationPath.removeLast(3)
    }
    
    func reportAgainButtonTapped() {
        state.showEmailErrorMessage = false
        AppState.shared.navigationPath.removeLast(2)
    }
}
