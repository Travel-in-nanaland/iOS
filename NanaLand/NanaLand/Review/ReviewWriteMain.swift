//
//  ReviewWriteMain.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import SwiftUI
import PhotosUI
import Kingfisher
import UIKit
import CustomAlert
import Alamofire

struct ReviewWriteMain: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = ReviewWriteViewModel()
    @State var showAlert = false //뒤로가기 alert 여부
    var reviewAddress: String = ""
    var reviewImageUrl: String = ""
    @Environment(\.dismiss) private var dismiss
    var reviewTitle: String = ""
    var reviewId: Int64 = 0
    var reviewCategory: String = ""
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 0) {
                ZStack {
                    NanaNavigationBar(title: .review, showBackButton: false)
                        .padding(.bottom, 16)
                    HStack(spacing: 0) {
                        Button(action: {
                            withAnimation(nil) {
                                showAlert = true
                            }
                            
                        }, label: {
                            Image("icLeft")
                                .renderingMode(.template)
                                .foregroundStyle(Color.black)
                        })
                        .customAlert(LocalizedKey.reviewBackAlertTitle.localized(for: localizationManager.language), isPresented: $showAlert) {
                            Text(.reviewBackAlertMessage)
                                .font(.body01)
                                .foregroundStyle(Color.gray1)
                                .padding(.top, 5)
                        } actions: {
                            MultiButton {
                                Button {
                                    withAnimation(nil) {
                                        dismiss()
                                        showAlert = false
                                    }
                                    
                                } label: {
                                    Text(.yes)
                                        .font(.title02_bold)
                                        .foregroundStyle(Color.black)
                                }
                                
                                Button {
                                    withAnimation(nil) {
                                        showAlert = false
                                    }
                                } label: {
                                    Text(.no)
                                        .font(.title02_bold)
                                        .foregroundStyle(Color.main)
                                }
                            }
                        }
                        .padding(.leading, 16)
                        Spacer()
                    }
                    .padding(.bottom, 12)
                }
               
                ReviewMainGridView(viewModel: viewModel, reviewItemAddress: reviewAddress, reviewItemImageUrl: reviewImageUrl, reviewTitle: reviewTitle, reviewId: reviewId, reviewCategory: reviewCategory)
            }
        }
        .toolbar(.hidden)
    }
}

struct ReviewMainGridView: View {
    
    @ObservedObject var viewModel: ReviewWriteViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []
    @State private var reviewContent: String = ""
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var uploadButtonFlag = false
    @State private var isLoading = false
    @State private var fileKeys = []
    @FocusState private var isTextEditorFocused: Bool
    var reviewItemAddress: String = ""
    var reviewItemImageUrl: String = ""
    var reviewTitle: String = ""
    var reviewId: Int64 = 0
    var reviewCategory: String = ""
    
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    KFImage(URL(string: reviewItemImageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .padding()
                    
                    Text(reviewTitle)
                        .font(.body_bold)
                        .padding(.bottom, 5)
                    Text(reviewItemAddress)
                        .font(.body02)
                        .padding(.bottom, 24)
                    
                    Rectangle()
                        .fill(Color.gray2)
                        .frame(width: 64, height: 1)
                        .padding(.bottom, 26)
                    
                    
                    if localizationManager.language == .korean {
                        let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.main) + Text(.selectRating2).font(.body_bold).foregroundColor(.black) + Text(.selectRating3).font(.body_bold).foregroundColor(.main) + Text(.selectRating4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        selectRating
                    } else if localizationManager.language == .english {
                        let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.black) + Text(.selectRating2).font(.body_bold).foregroundColor(.main) + Text(.selectRating3).font(.body_bold).foregroundColor(.black) + Text(.selectRating4).font(.body_bold).foregroundColor(.main) +
                            Text("!").font(.body_bold).foregroundColor(.black)
                        
                        selectRating
                    } else if localizationManager.language == .chinese {
                        let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.black) + Text(.selectRating2).font(.body_bold).foregroundColor(.main) + Text(.selectRating3).font(.body_bold).foregroundColor(.black) + Text(.selectRating4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        selectRating
                    } else if localizationManager.language == .malaysia {
                        let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.black) + Text(.selectRating2).font(.body_bold).foregroundColor(.main) + Text(.selectRating3).font(.body_bold).foregroundColor(.black) + Text(.selectRating4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        selectRating
                    } else {
                        let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.black) + Text(.selectRating2).font(.body_bold).foregroundColor(.main) + Text(.selectRating3).font(.body_bold).foregroundColor(.black) + Text(.selectRating4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        selectRating
                    }
                    
                    
                    HStack {
                        ForEach(1...5, id: \.self) { number in
                            Image(number <= viewModel.state.getReviewWriteResponse.rating ? "icStarFill" : "icStar")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36)
                                .onTapGesture {
                                    viewModel.updateRating(number)
                                    viewModel.state.reviewDTO.rating = number
                                }
                        }
                    }
                    .padding(.bottom, 24)
                    
                    Rectangle()
                        .fill(Color.gray2)
                        .frame(width: 64, height: 1)
                        .padding(.bottom, 26)
                    
                    if localizationManager.language == .korean {
                        let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.main) + Text(.visitReview2).font(.body_bold).foregroundColor(.black) + Text(.visitReview3).font(.body_bold).foregroundColor(.main) + Text(.visitReview4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        visitReview
                    } else if localizationManager.language == .english {
                        let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.black) + Text(.visitReview2).font(.body_bold).foregroundColor(.main) + Text(.visitReview3).font(.body_bold).foregroundColor(.black) + Text(.visitReview4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        visitReview
                    } else if localizationManager.language == .chinese {
                        let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.black) + Text(.visitReview2).font(.body_bold).foregroundColor(.main) + Text(.visitReview3).font(.body_bold).foregroundColor(.black) + Text(.visitReview4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        visitReview
                    } else if localizationManager.language == .malaysia {
                        let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.black) + Text(.visitReview2).font(.body_bold).foregroundColor(.main) + Text(.visitReview3).font(.body_bold).foregroundColor(.black) + Text(.visitReview4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        visitReview
                    } else {
                        let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.black) + Text(.visitReview2).font(.body_bold).foregroundColor(.main) + Text(.visitReview3).font(.body_bold).foregroundColor(.black) + Text(.visitReview4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                        
                        visitReview
                    }
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.gray2)
                                .frame(width: 80, height: 80)
                                .cornerRadius(8)
                                .padding(.leading, -5)
                            
                            PhotosPicker(
                                selection: $selectedItems,
                                maxSelectionCount: 5,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                if viewModel.state.getReviewWriteResponse.imgCnt == 5{
                                    Button { // 사진이 5장인 상태(최대상태) 에서 또 클릭 할 시 토스트 메시지 띄우기
                                        toastMessage = LocalizedKey.photoMax.localized(for: localizationManager.language)
                                        showToast = true
                                    } label: {
                                        VStack {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 26)
                                            Text("\(viewModel.state.getReviewWriteResponse.imgCnt) / 5")
                                                .font(.gothicNeo(.light, size: 15))
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                                else {
                                    VStack {
                                        Image(systemName: "camera")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 26)
                                        Text("\(viewModel.state.getReviewWriteResponse.imgCnt) / 5")
                                            .font(.gothicNeo(.light, size: 15))
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            .padding(.leading, -5)
                        }
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(Array(selectedImageData.enumerated()), id: \.element) { index, imageData in
                                    if let uiImage = UIImage(data: imageData) {
                                        ZStack(alignment: .topTrailing) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                            
                                            Button(action: {
                                                selectedImageData.remove(at: index)
                                                selectedItems.remove(at: index)
                                                viewModel.updateImageCount(selectedImageData.count)
                                            }) {
                                                Image("icRemovePhoto")
                                                    .padding(.trailing, 2)
                                                    .padding(.top, 2)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                    
                    ZStack(alignment: .topLeading) {
                        
                        TextEditor(text: $reviewContent)
                            .font(.body02)
                            .foregroundColor(.black)
                            .padding(4)
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray2, lineWidth: 1)
                            )
                            .frame(height: 190)
                            .onChange(of: reviewContent) { newValue in
                                viewModel.state.reviewDTO.content = newValue
                                print("\(newValue)")
                                for i in 0..<viewModel.selectedKeyword.count {
                                    print(viewModel.selectedKeyword[i].tag)
                                }
                                if newValue.count > 200 {
                                    
                                    reviewContent = String(newValue.prefix(200))
                                    toastMessage = LocalizedKey.content200.localized(for: localizationManager.language)
                                    showToast = true
                                    print("200자 초과")
                                }
                            }
                            .padding(.horizontal)
                            .focused($isTextEditorFocused)
                        
                        if reviewContent == "" {
                            Text(.writeContent)
                                .font(.body02)
                                .foregroundColor(.gray1)
                                .padding(4)
                                .padding(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 0))
                                .onTapGesture {
                                    isTextEditorFocused = true
                                }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Text("(\(reviewContent.count) / 200)")
                            .font(.body02)
                            .foregroundColor(.gray)
                            .padding(.top, -40)
                            .padding(.trailing, 30)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            NavigationLink {
                                ReviewKeywordView(viewModel: viewModel)
                            } label: {
                                HStack {
                                    Text(.addKeyword)
                                        .font(.body02)
                                    Image(systemName: "plus")
                                }
                                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .background(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.main, lineWidth: 1)
                                )
                                .foregroundColor(.main)
                            }
                            
                            MainTagView(tags: Array(viewModel.selectedKeyword.prefix(1)), keywordViewModel: viewModel, localizationManager: _localizationManager)
                            
                            Spacer()
                        }
                        MainTagView(tags: Array(viewModel.selectedKeyword.dropFirst()), keywordViewModel: viewModel, localizationManager: _localizationManager)
                            .padding(.leading, -5)
                    }
                    .padding()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor((viewModel.selectedKeyword.count < 1 || reviewContent.count == 0 || viewModel.state.getReviewWriteResponse.rating == 0) ? .main10P : .main)
                            .frame(height: 50)
                        Button {
                            Task {
                                isLoading = true // 로딩창 on
                                for i in 0..<viewModel.selectedKeyword.count {
                                    viewModel.state.reviewDTO.reviewKeywords.append(viewModel.selectedKeyword[i].tag)
                                }

                                // MARK: - Presigned Url을 통한 이미지 Upload 로직
                                // 1. 이미지 청크 파일로 분할하기(최대 5MB)
                                // 2. upload-init api 호출
                                if selectedItems.count >= 1 {
                                    for i in 0...(selectedItems.count - 1) {
                                        // 청크 파일 생성(각 청크파일 용량 최대 5MB) -> 현재는 일단 청크로 나눠서 업로드 하지는 않음.(추후 수정 필요)
                                        let chunks = viewModel.splitImageIntoChunks(data: selectedImageData[i], chunkSize: 1024 * 5000)
                                        // 확장자명 얻어오기(지원가능한 확장자명임)
                                        let extensionName = selectedItems[i].supportedContentTypes[0].identifier
                                        // 확장자명만 떼오기(원래는 "public.jpeg" 이런식 -> jpeg만 얻어오게 하기 위해서)
                                        if let range = extensionName.range(of: ".") {
                                            let substring = extensionName[range.upperBound...]
                                            print(ReviewS3UploadDTO(originalFileName: "\(selectedItems[i].itemIdentifier ?? "").\(String(substring))", fileSize: selectedImageData[i].count, fileCategory: "REVIEW", partCount: chunks.count))
                                            viewModel.state.reviewS3UploadDTO.originalFileName = "\(selectedItems[i].itemIdentifier ?? "").\(String(substring))"
                                            viewModel.state.reviewS3UploadDTO.fileCategory = "REVIEW"
                                            viewModel.state.reviewS3UploadDTO.fileSize = selectedImageData[i].count
                                            viewModel.state.reviewS3UploadDTO.partCount = chunks.count
                                            
                                            await uploadImage(body: viewModel.state.reviewS3UploadDTO)
                                           // await uploadImageToS32(presignedURL: URL(string: viewModel.state.getReviewS3Response.presignedUrlInfos[0].preSignedUrl)!, imageData: selectedImageData[i], mimeType: "image/\(String(substring))") (리팩토링 필요~~)
                                            await uploadImageToS3(presignedURL: URL(string: viewModel.state.getReviewS3Response.presignedUrlInfos[0].preSignedUrl)!, imageData: selectedImageData[i], mimeType: "image/\(String(substring))", uploadId: viewModel.state.getReviewS3Response.uploadId, fileKey: viewModel.state.getReviewS3Response.fileKey) { success, eTag, uploadId, fileKey, error in
                                                if success {
                                                    Task { // await 함수 task에 안넣으면 compiler type check 오류가 발생.
                                                        await uploadComplete(body: ReviewS3UploadCompleteDTO(uploadId: uploadId!, fileKey: fileKey!, parts: [eTagData(partNumber: 1, etag: eTag!)]))
                                                        viewModel.state.reviewDTO.fileKeys.append(fileKey ?? "")
                                                        fileKeys.append(fileKey!)
                                                        if fileKeys.count == selectedItems.count {
                                                            await postReview(id: reviewId, category: reviewCategory, body: viewModel.state.reviewDTO)
                                                            isLoading = false // 리뷰 통신이 끝나면 로딩창 off
                                                            AppState.shared.navigationPath.append(ReviewViewType.complete)
                                                        }
                                                    }
                                                } else {
                                                    print("이미지 업로드 실패")
                                                }
                                            }
                                        } else {
                                            
                                        }
                                    }
                                } else {
                                    isLoading = false
                                    await postReview(id: reviewId, category: reviewCategory, body: viewModel.state.reviewDTO) // 이미지 없이 리뷰 올리기
                                    AppState.shared.navigationPath.append(ReviewViewType.complete)
                                }
                               
                            }
                        } label: {
                            Text(.upload)
                                .font(.body_bold)
                                .foregroundStyle(.white)
                        }
                        .disabled((viewModel.selectedKeyword.count < 1 || reviewContent.count == 0 || viewModel.state.getReviewWriteResponse.rating == 0) ? true : false)
                    }
                    .padding(.bottom, 20)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            
                }
            }
            .onChange(of: selectedItems) { newItems in
                Task {
                    
                    selectedImageData.removeAll()
                    for newItem in newItems {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            if selectedImageData.count < 5 {
                                selectedImageData.append(data) // 선택된 이미지 추가
                            }
                        }
            
                    }
                    viewModel.updateImageCount(selectedImageData.count)
                }
            }
            .overlay(
                Toast(message: toastMessage, isShowing: $showToast, isAnimating: true)
            )
            .navigationDestination(for: ReviewViewType.self) { viewType in
                switch viewType {
                case .complete:
                    ReviewCompleteView(title: reviewCategory)
                }
            }
            if isLoading {
                LottieView(jsonName: "loading", loopMode: .loop)
                    .frame(width: Constants.screenWidth, height: Constants.screenHeight)
                    .background(Color.black.opacity(0.3))
                    .edgesIgnoringSafeArea(.all)
            }
        }
       
    }
    
    func postReview(id: Int64, category: String, body: ReviewDTO) async {
        await viewModel.action(.postReview(id: id, category: category, body: body))
    }
    
    func uploadImage(body: ReviewS3UploadDTO) async {
        await viewModel.action(.uploadInit(body: body))
    }
    
    func uploadComplete(body: ReviewS3UploadCompleteDTO) async {
        await viewModel.action(.uploadComplete(body: body))
    }
    
    func uploadImageToS32(presignedURL: URL, imageData: Data, mimeType: String) async {
        await viewModel.action(.uploadImageToS3(presignedURL: presignedURL, imageData: imageData, mimeType: mimeType))
    }
    
    // S3에 이미지 업로드 하는 함수(추후 리팩토링 필요)
    func uploadImageToS3(presignedURL: URL, imageData: Data, mimeType: String, uploadId: String, fileKey: String, completion: @escaping (Bool, String?, String?, String?, Error?) -> Void) async {

        AF.upload(imageData, to: presignedURL, method: .put, headers: [
            "Content-Type": mimeType
        ]).validate().response { response in
            switch response.result {
            case .success:
                if let headers = response.response?.headers, let eTag = headers["ETag"] {
                    completion(true, eTag, uploadId, fileKey,nil)
                } else {
                    completion(true, nil, nil, nil, nil)
                }
            case .failure(let error):
                completion(false, nil, nil, nil, error)
            }
        }
    }
}

enum ReviewViewType {
    case complete
}

struct MainTagView: View {
    var tags: [ReviewKeywordModel]
    @ObservedObject var keywordViewModel: ReviewWriteViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if tag == tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for tag: ReviewKeywordModel) -> some View {
        HStack {
            Text(tag.text.localized(for: localizationManager.language))
                .font(.body02)
            Image(systemName: "multiply")
                .onTapGesture {
                    keywordViewModel.removeKeyword(tag)
                }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .foregroundColor(keywordViewModel.selectedKeyword.contains(tag) ? .main : .gray)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(keywordViewModel.selectedKeyword.contains(tag) ? Color.main.opacity(0.1) : Color.gray2.opacity(0.1))
        )
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

#Preview {
    ReviewWriteMain()
        .environmentObject(LocalizationManager())
}
