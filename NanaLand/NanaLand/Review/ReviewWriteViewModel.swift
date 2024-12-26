//
//  ReviewWriteViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import Foundation

class ReviewWriteViewModel: ObservableObject {
    struct State {
        // 리뷰 쓰기위해서 페이지 들어왔을때 필요한 응답
        var getReviewWriteResponse = ReviewWriteModel(id: 1, originUrl: "", title: "월정 투명카약", address: "제주특별자치도 제주시 구좌읍 월정리 1400-33", rating: 0, content: "", imgCnt: 0)
        // 리뷰 올렸을 때 오는 응답(status는 필요할듯)
        var getReviewPostResponse = ReviewPostModel(status: 0, message: "", data: ReviewPostData(reviewKeywords: "", rating: "", content: ""))
        var reviewDTO = ReviewDTO(rating: 0, content: "", reviewKeywords: [], fileKeys: [])
        var getReviewS3Response = ReviewS3UploadModel()
        var reviewS3UploadDTO = ReviewS3UploadDTO(originalFileName: "", fileSize: 0, fileCategory: "", partCount: 0)
        var reviewS3UploadCompleteDTO = ReviewS3UploadCompleteDTO(uploadId: "", fileKey: "", parts: [eTagData(partNumber: 0, etag: "")])
    }
    
    enum Action {
        case postReview(id: Int64, category: String, body: ReviewDTO)
        case uploadInit(body: ReviewS3UploadDTO)
        case uploadComplete(body: ReviewS3UploadCompleteDTO)
        case uploadImageToS3(presignedURL: URL, imageData: Data, mimeType: String)
    }
    
    @Published var state: State
    @Published var selectedKeyword: [ReviewKeywordModel] = []
    @Published var keywordViewModel: ReviewKeywordViewModel
    
    init(state: State = .init()) {
        self.state = state
        self.keywordViewModel = ReviewKeywordViewModel()
        self.keywordViewModel.reviewWriteViewModel = self
    }
    
    func updateRating(_ rating: Int) {
        state.getReviewWriteResponse.rating = rating
    }
    
    func updateImageCount(_ count: Int) {
        state.getReviewWriteResponse.imgCnt = count
    }
    
    func updateSelectedKeywords(_ keywords: [ReviewKeywordModel]) {
        self.selectedKeyword = keywords
        keywordViewModel.updateSelectedKeywords(keywords)
    }
    
    func removeKeyword(_ keyword: ReviewKeywordModel) {
        if let index = selectedKeyword.firstIndex(of: keyword) {
            selectedKeyword.remove(at: index)
            updateSelectedKeywords(selectedKeyword)
        }
    }
    
    func splitImageIntoChunks(data: Data, chunkSize: Int) -> [Data] {
        // 청크 데이터 배열 생성
        var chunks: [Data] = []
        let totalSize = data.count
        
        var offset = 0
        while offset < totalSize {
            let length = min(chunkSize, totalSize - offset)
            let chunk = data.subdata(in: offset..<(offset + length))
            chunks.append(chunk)
            offset += length
        }
        
        return chunks
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .postReview(id, category, body):
            let response = await ReviewService.getReviewItem(id: id, category: category, body: body)
            if response != nil {
                await MainActor.run {
                    state.getReviewPostResponse.status = response!.status
                }
                
            }
        case let .uploadInit(body):
            let response = await FileService.postFileUpload(body: body)
            if response != nil {
                await MainActor.run {
                    state.getReviewS3Response = response!.data!
                    print("----------------------결과")
                    print(state.getReviewS3Response)
                }
            }
        case let .uploadComplete(body):
            let response = await FileService.completeFileUpload(body: body)
            if response != nil {
                print(response!.message)
            }
        case let .uploadImageToS3(presignedURL, imageData, mimeType): // 요청후 Header에 있는 ETag 응답 받기
            let response = await FileService.uploadImageToS3(presignedURL: presignedURL, imageData: imageData, mimeType: mimeType)
            if response != nil {
                print("uploadImageToS32----------\(response?.status)------------")
            }
        }
    }
}

