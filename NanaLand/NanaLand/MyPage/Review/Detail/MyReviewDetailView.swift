//
//  MyReviewDetailView.swift
//  NanaLand
//
//  Created by wodnd on 8/11/24.
//
import SwiftUI
import PhotosUI
import Kingfisher
import UIKit
import CustomAlert

// editImageInfo를 위한 구조체 정의
struct EditImageInfoDto: Codable {
    let id: Int64
    let newImage: Bool
}

struct MyReviewDetailView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = ReviewWriteViewModel()
    @StateObject var detailViewModel = MyReviewDetailViewModel()
    @State var showAlert = false //뒤로가기 alert 여부
    @Environment(\.dismiss) private var dismiss
    var reviewId: Int64 = 0
    var reviewCategory: String = ""
    @State var apiCall: Int = 0
    
    @State private var reviewContent: String = ""
    @State private var serverImageData: [Data] = [] // 서버에서 받은 이미지 데이터
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 0) {
                ZStack {
                    NanaNavigationBar(title: .modify, showBackButton: false)
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
                        .customAlert("정말 나가시겠습니까?", isPresented: $showAlert) {
                            Text("지금 나가시면,\n작성 중인 내용이 삭제됩니다.")
                                .font(.body01)
                                .foregroundStyle(Color.gray1)
                                .padding(.top, 5)
                        } actions: {
                            MultiButton {
                                Button {
                                    withAnimation(nil) {
                                        showAlert = false
                                        dismiss()
                                    }
                                    
                                } label: {
                                    Text("네")
                                        .font(.title02_bold)
                                        .foregroundStyle(Color.black)
                                }
                                Button {
                                    withAnimation(nil) {
                                        showAlert = false
                                    }
                                } label: {
                                    Text("아니오")
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
                
                MyDetailReviewMainGridView(viewModel: viewModel, 
                                           detailViewModel: detailViewModel,
                                           serverImageData: $serverImageData, reviewContent: $reviewContent, 
                                           reviewItemAddress: detailViewModel.state.getReviewDetailResponse.address,
                                           reviewItemImageUrl: detailViewModel.state.getReviewDetailResponse.firstImage.thumbnailUrl,
                                           reviewTitle: detailViewModel.state.getReviewDetailResponse.title,
                                           reviewId: reviewId,
                                           reviewCategory: reviewCategory)
            }
            .toolbar(.hidden)
        }
        .toolbar(.hidden)
        .onAppear(){
            Task{
                await getMyReviewDetail(id: reviewId)
            }
        }
    }
    
    func getMyReviewDetail(id: Int64) async {
        if apiCall == 0{
            await detailViewModel.action(.getReviewDetail(id: id))
            reviewContent = detailViewModel.state.getReviewDetailResponse.content
            if let images = detailViewModel.state.getReviewDetailResponse.images {
                // 서버에서 받은 이미지 데이터를 서버 이미지 데이터 배열에 추가
                serverImageData = images.compactMap { try? Data(contentsOf: URL(string: $0.thumbnailUrl)!) }
//                serverImageData = images.compactMap { image in
//                                let urlString = image.thumbnailUrl
//                                if let url = URL(string: urlString) {
//                                    return try? Data(contentsOf: url)
//                                } else {
//                                    print("Invalid URL: \(urlString)")
//                                    return nil
//                                }
//                            }
            }
            apiCall += 1
        }
    }
}

struct MyDetailReviewMainGridView: View {
    
    @ObservedObject var viewModel: ReviewWriteViewModel
    @ObservedObject var detailViewModel: MyReviewDetailViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var serverImageData: [Data]
    @State private var selectedImageData: [Data] = []
    @Binding var reviewContent: String
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var uploadButtonFlag = false
    @FocusState private var isTextEditorFocused: Bool
    var reviewItemAddress: String = ""
    var reviewItemImageUrl: String = ""
    var reviewTitle: String = ""
    var reviewId: Int64 = 0
    var reviewCategory: String = ""
    
    var body: some View {
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
                
                let selectRating1 = Text(.selectRating1).font(.body_bold).foregroundColor(.main)
                let selectRating2 = Text(.selectRating2).font(.body_bold).foregroundColor(.black)
                let selectRating3 = Text(.selectRating3).font(.body_bold).foregroundColor(.main)
                let selectRating4 = Text(.selectRating4).font(.body_bold).foregroundColor(.black)
                let selectRating = selectRating1 + selectRating2 + selectRating3 + selectRating4
                
                selectRating
                
                HStack {
                    ForEach(1...5, id: \.self) { number in
                        Image(number <= detailViewModel.state.editReviewDto.rating ? "icStarFill" : "icStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36)
                            .onTapGesture {
                                detailViewModel.state.editReviewDto.rating = number
                            }
                    }
                }
                .padding(.bottom, 24)
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: 64, height: 1)
                    .padding(.bottom, 26)
                
                let visitReview1 = Text(.visitReview1).font(.body_bold).foregroundColor(.main)
                let visitReview2 = Text(.visitReview2).font(.body_bold).foregroundColor(.black)
                let visitReview3 = Text(.visitReview3).font(.body_bold).foregroundColor(.main)
                let visitReview4 = Text(.visitReview4).font(.body_bold).foregroundColor(.black)
                let visitReview = visitReview1 + visitReview2 + visitReview3 + visitReview4
                
                visitReview
                
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray2)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                        
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 5,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if detailViewModel.state.getReviewModifyResponse.imgCnt == 5{
                                Button { // 사진이 5장인 상태(최대상태) 에서 또 클릭 할 시 토스트 메시지 띄우기
                                    toastMessage = "사진은 최대 5장까지 선택 가능합니다"
                                    showToast = true
                                } label: {
                                    VStack {
                                        Image(systemName: "camera")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 26)
                                        Text("\(detailViewModel.state.getReviewModifyResponse.imgCnt) / 5")
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
                                    Text("\(detailViewModel.state.getReviewModifyResponse.imgCnt) / 5")
                                        .font(.gothicNeo(.light, size: 15))
                                }
                                .foregroundColor(.white)
                            }
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            // 서버에서 받은 이미지 표시
                            ForEach(Array(serverImageData.enumerated()), id: \.offset) { index, imageData in
                                if let uiImage = UIImage(data: imageData) {
                                    ZStack(alignment: .topTrailing){
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                        Button(action: {
                                            detailViewModel.state.getReviewDetailResponse.images?.remove(at: index)
                                            serverImageData.remove(at: index)
                                            detailViewModel.updateImageCount(selectedImageData.count)
                                        }) {
                                            Image("icRemovePhoto")
                                                .padding(.trailing, 2)
                                                .padding(.top, 2)
                                        }
                                    }
                                }
                            }
                            // 사용자 선택 이미지 표시
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
                                            detailViewModel.updateImageCount(selectedImageData.count)
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
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(height: 190)
                        .onChange(of: reviewContent) { newValue in
                            detailViewModel.state.editReviewDto.content = newValue
                            print("\(newValue)")
                            if newValue.count > 200 {
                                reviewContent = String(newValue.prefix(200))
                                toastMessage = "내용은 200자 이내로 작성 가능합니다"
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
                        .padding(.trailing, 16)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        NavigationLink {
                            MyReviewDetailKeywordView(viewModel: detailViewModel)
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
                        
                        ReviewDetailTagView(tags: Array(detailViewModel.selectedKeyword.prefix(1)), keywordViewModel: detailViewModel, localizationManager: _localizationManager)
                        
                        Spacer()
                    }
                    ReviewDetailTagView(tags: Array(detailViewModel.selectedKeyword.dropFirst()), keywordViewModel: detailViewModel, localizationManager: _localizationManager)
                        .padding(.leading, -5)
                }
                .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor((detailViewModel.selectedKeyword.count < 3 || detailViewModel.state.editReviewDto.content.count == 0 || detailViewModel.state.editReviewDto.rating == 0) ? .main10P : .main)
                        .frame(width: 360, height: 50)
                    Button {
                        Task {
                            detailViewModel.state.editReviewDto.editImageInfoList = prepareEditImageInfo()
                            
                            for i in 0..<detailViewModel.selectedKeyword.count {
                                detailViewModel.state.editReviewDto.reviewKeywords.append(detailViewModel.selectedKeyword[i].tag)
                            }
                            
                            await modifyReview(id: reviewId, body: detailViewModel.state.editReviewDto, multipartFile: selectedImageData)
                            
                            AppState.shared.navigationPath.removeLast()
                        }
                        
                        
                    } label: {
                        Text(.upload)
                            .font(.body_bold)
                            .foregroundStyle(.white)
                    }
                    .disabled((detailViewModel.selectedKeyword.count < 3 || detailViewModel.state.editReviewDto.content.count == 0 || detailViewModel.state.editReviewDto.rating == 0) ? true : false)
                    
                    
                }
                .padding(.bottom, 20)
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
                detailViewModel.updateImageCount(selectedImageData.count)
            }
        }
        .overlay(
            Toast(message: toastMessage, isShowing: $showToast, isAnimating: true)
        )
    }
    
    // editImageInfoList 준비 함수
    func prepareEditImageInfo() -> [EditImageInfoDto] {
        var editImageInfoList: [EditImageInfoDto] = []
        
        // 서버에서 받은 이미지
        if let images = detailViewModel.state.getReviewDetailResponse.images {
            for image in images {
                editImageInfoList.append(EditImageInfoDto(id: Int64(image.id), newImage: false))
            }
        }
        
        // 새로 추가된 이미지
        for _ in selectedImageData {
            editImageInfoList.append(EditImageInfoDto(id: -1, newImage: true))
        }
        
        return editImageInfoList
    }
    
    func modifyReview(id: Int64, body: EditReviewDto, multipartFile: [Foundation.Data?]) async {
        await detailViewModel.action(.modifyMyReview(id: id, body: body, multipartFile: multipartFile))
    }
}


struct ReviewDetailTagView: View {
    var tags: [ReviewKeywordModel]
    @ObservedObject var keywordViewModel: MyReviewDetailViewModel
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
    MyReviewDetailView()
        .environmentObject(LocalizationManager())
}
