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
                    NanaNavigationBar(title: .reviewModify, showBackButton: false)
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
                                        showAlert = false
                                        dismiss()
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
                    .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: Constants.screenWidth * (64 / 360), height: 1)
                    .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                if localizationManager.language == .korean {
                    let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.main) + Text(.selectRating2).font(.body_bold).foregroundColor(.black) + Text(.selectRating3).font(.body_bold).foregroundColor(.main) + Text(.selectRating4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        selectRating
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                } else {
                    let selectRating = Text(.selectRating1).font(.body_bold).foregroundColor(.black) + Text(.selectRating2).font(.body_bold).foregroundColor(.main) + Text(.selectRating3).font(.body_bold).foregroundColor(.black) + Text(.selectRating4).font(.body_bold).foregroundColor(.main) +
                        Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        selectRating
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                            
                        
                }
                
                HStack {
                    ForEach(1...5, id: \.self) { number in
                        Image(number <= detailViewModel.state.editReviewDto.rating ? "icStarFill" : "icStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: Constants.screenWidth * (25 / 360))
                            .onTapGesture {
                                detailViewModel.state.editReviewDto.rating = number
                            }
                    }
                }
                .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: Constants.screenWidth * (64 / 360), height: 1)
                    .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                if localizationManager.language == .korean {
                    let addKeyword = Text(.addKeyword1).font(.body_bold).foregroundColor(.main) + Text(.addKeyword2).font(.body_bold).foregroundColor(.black) + Text(.addKeyword3).font(.body_bold).foregroundColor(.main) + Text(.addKeyword4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        addKeyword
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                } else {
                    let addKeyword = Text(.addKeyword1).font(.body_bold).foregroundColor(.black) + Text(.addKeyword2).font(.body_bold).foregroundColor(.main) + Text(.addKeyword3).font(.body_bold).foregroundColor(.black) + Text(.addKeyword4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        addKeyword
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        
                        if detailViewModel.selectedKeyword.count == 0 {
                            Spacer()
                        }
                        
                        NavigationLink {
                            MyReviewDetailKeywordView(viewModel: detailViewModel)
                        } label: {
                            HStack {
                                Text(.addKeyword)
                                    .font(.body02)
                                Image(systemName: "plus")
                            }
                            .padding(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                            .background(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.main, lineWidth: 1)
                            )
                            .foregroundColor(.main)
                        }
                        
                        if detailViewModel.selectedKeyword.count != 0 {
                            ReviewDetailTagView(tags: Array(detailViewModel.selectedKeyword.prefix(1)), keywordViewModel: detailViewModel, localizationManager: _localizationManager)
                        }
                        
                        Spacer()
                    }
                    ReviewDetailTagView(tags: Array(detailViewModel.selectedKeyword.dropFirst()), keywordViewModel: detailViewModel, localizationManager: _localizationManager)
                        .padding(.leading, -5)
                }
                .padding(.leading, Constants.screenWidth * (16 / 360))
                .padding(.trailing, Constants.screenWidth * (16 / 360))
                .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: Constants.screenWidth * (64 / 360), height: 1)
                    .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                
                if localizationManager.language == .korean {
                    let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.main) + Text(.visitReview2).font(.body_bold).foregroundColor(.black) + Text(.visitReview3).font(.body_bold).foregroundColor(.main) + Text(.visitReview4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        visitReview
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                } else {
                    let visitReview = Text(.visitReview1).font(.body_bold).foregroundColor(.black) + Text(.visitReview2).font(.body_bold).foregroundColor(.main) + Text(.visitReview3).font(.body_bold).foregroundColor(.black) + Text(.visitReview4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        visitReview
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                }
                
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
                }.padding(.bottom, Constants.screenWidth * (24 / 360))
                
                HStack {
                    Spacer()
                    Text("(\(reviewContent.count) / 200)")
                        .font(.body02)
                        .foregroundColor(.gray1)
                        .padding(.top, Constants.screenWidth * (-60 / 360))
                        .padding(.trailing, 30)
                }
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: Constants.screenWidth * (64 / 360), height: 1)
                    .padding(.bottom, Constants.screenWidth * (24 / 360))
                
                if localizationManager.language == .korean {
                    let addPhoto = Text(.addPhoto1).font(.body_bold).foregroundColor(.main) + Text(.addPhoto2).font(.body_bold).foregroundColor(.black) + Text(.addPhoto3).font(.body_bold).foregroundColor(.main) + Text(.addPhoto4).font(.body_bold).foregroundColor(.black) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        addPhoto
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                    
                } else {
                    let addPhoto = Text(.addPhoto1).font(.body_bold).foregroundColor(.black) + Text(.addPhoto2).font(.body_bold).foregroundColor(.main) + Text(.addPhoto3).font(.body_bold).foregroundColor(.black) + Text(.addPhoto4).font(.body_bold).foregroundColor(.main) + Text("!").font(.body_bold).foregroundColor(.black)
                    
                    HStack {
                        addPhoto
                        
                        Text("*")
                            .font(.body_bold)
                            .foregroundColor(.main)
                            .padding(.bottom, 8)
                            .padding(.leading, -4)
                    }
                }
                
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray2)
                            .frame(width: Constants.screenWidth * (80 / 360), height: Constants.screenWidth * (80 / 360))
                            .cornerRadius(8)
                        
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 5,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            if detailViewModel.state.getReviewModifyResponse.imgCnt == 5{
                                Button { // 사진이 5장인 상태(최대상태) 에서 또 클릭 할 시 토스트 메시지 띄우기
                                    toastMessage = LocalizedKey.photoMax.localized(for: localizationManager.language)
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
                .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (16 / 360), bottom: Constants.screenWidth * (24 / 360), trailing: Constants.screenWidth * (16 / 360)))
                
                ZStack {
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
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor((detailViewModel.selectedKeyword.count < 3 || detailViewModel.state.editReviewDto.content.count == 0 || detailViewModel.state.editReviewDto.rating == 0) ? .main10P : .main)
                            .frame(width: 360, height: 50)
                            .overlay {
                                Text(.upload)
                                    .font(.body_bold)
                                    .foregroundStyle(.white)
                                    .frame(width: Constants.screenWidth - 40, height: 50)
                            }
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
