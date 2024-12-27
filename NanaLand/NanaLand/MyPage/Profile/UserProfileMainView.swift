//
//  UserProfileMainView.swift
//  NanaLand
//
//  Created by juni on 8/1/24.
//

import SwiftUI
import Kingfisher
import MasonryStack
// 타 유저 프로필 뷰
struct UserProfileMainView: View {
    @StateObject var appState = AppState.shared
    @StateObject var viewModel = UserProfileMainViewModel()
    @State private var reportReasonViewFlag = false // 신고하기로 네비게이션 하기 위한 플래그(신고 모달이 sheet 형태라 navigation stack에 포함 안됨)
    @State private var isAPICalled = false
    @State private var id: Int64 = 0 // 유저 id 저장
    @AppStorage("provider") var provider: String = ""
    @State private var reportModal = false // 신고하기 모달창
    @State private var isReport = false
    var memberId: Int64 = 1
    
    struct TypeItem {
        let korean: String
        let english: String
        let chinese: String
        let malay: String
        let vietnamese: String
        let imageName: String
    }
    
    // 데이터 매핑
    let typeItems: [TypeItem] = [
        TypeItem(korean: "감귤아이스크림", english: "Tangerine Ice Cream", chinese: "柑橘冰淇淋", malay: "Ais Krim Mandarin", vietnamese: "Kem quýt", imageName: "GAMGYUL_ICECREAM"),
        TypeItem(korean: "감귤 찹쌀떡", english: "Tangerine Rice Cake", chinese: "柑橘糯米糕", malay: "Mochi Mandarin", vietnamese: "Bánh gạo nếp quýt", imageName: "GAMGYUL_RICECAKE"),
        TypeItem(korean: "감귤", english: "Tangerine", chinese: "柑橘", malay: "Mandarin", vietnamese: "Quýt", imageName: "GAMGYUL"),
        TypeItem(korean: "감귤사이다", english: "Tangerine Soda", chinese: "柑橘雪碧", malay: "Sida Mandarin", vietnamese: "Nước táo quýt", imageName: "GAMGYUL_CIDER"),
        TypeItem(korean: "감귤 아포가토", english: "Tangerine Affogato", chinese: "柑橘阿芙佳朵", malay: "Jenis Affogato Mandarin", vietnamese: "Affogato quýt", imageName: "GAMGYUL_AFFOKATO"),
        TypeItem(korean: "감귤한과", english: "Tangerine Traditional Sweets", chinese: "柑橘油炸蜜果", malay: "Kuih Tradisional Mandarin", vietnamese: "Bánh truyền thống quýt (Hangwa)", imageName: "GAMGYUL_HANGWA"),
        TypeItem(korean: "감귤주스", english: "Tangerine Juice", chinese: "柑橘果汁", malay: "Jus Mandarin", vietnamese: "Nước ép quýt", imageName: "GAMGYUL_JUICE"),
        TypeItem(korean: "감귤 초콜릿", english: "Tangerine Chocolate", chinese: "柑橘巧克力", malay: "Coklat Mandarin", vietnamese: "Sô-cô-la quýt", imageName: "GAMGYUL_CHOCOLATE"),
        TypeItem(korean: "감귤 칵테일", english: "Tangerine Cocktail", chinese: "柑橘鸡尾酒", malay: "Koktel Mandarin", vietnamese: "Cocktail quýt", imageName: "GAMGYUL_COCKTAIL"),
        TypeItem(korean: "귤피차", english: "Tangerine Peel Tea", chinese: "橘皮茶", malay: "Teh Kulit Mandarin", vietnamese: "Trà vỏ quýt", imageName: "TANGERINE_PEEL_TEA"),
        TypeItem(korean: "감귤 요거트", english: "Tangerine Yogurt", chinese: "柑橘酸奶", malay: "Yogurt Mandarin", vietnamese: "Sữa chua quýt", imageName: "GAMGYUL_YOGURT"),
        TypeItem(korean: "감귤 플랫치노", english: "Tangerine Frappuccino", chinese: "柑橘冰沙", malay: "Frappuccino Mandarin", vietnamese: "Flatccino quýt", imageName: "GAMGYUL_FLATCCINO"),
        TypeItem(korean: "감귤 라떼", english: "Tangerine Latte", chinese: "柑橘拿铁", malay: "Latte Mandarin", vietnamese: "Latte quýt", imageName: "GAMGYUL_LATTE"),
        TypeItem(korean: "감귤식혜", english: "Tangerine Shikhye", chinese: "柑橘甜米露", malay: "Sikhye Mandarin", vietnamese: "Sikhye quýt (nước gạo ngọt)", imageName: "GAMGYUL_SIKHYE"),
        TypeItem(korean: "감귤에이드", english: "Tangerine Ade", chinese: "柑橘汽水", malay: "Aid Mandarin", vietnamese: "Nước Ade quýt", imageName: "GAMGYUL_ADE"),
        TypeItem(korean: "감귤 버블티", english: "Tapioca Tangerine Tea", chinese: "柑橘珍珠奶茶", malay: "Bubble Tea Mandarin", vietnamese: "Trà sữa trân châu quýt", imageName: "GAMGYUL_BUBBLE_TEA")
    ]
    
    @State var isShowingReport = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack{
                NanaNavigationBar(title: .emptyString, showBackButton: true)
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        reportModal = true
                        // TODO: report할 유저의 ID 저장 하기
                        id = memberId
                    } label: {
                        Image("icPointBtn")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(.trailing, 14)
                    }
                }
            }
            
            if isAPICalled {
                ZStack{
                    GeometryReader { geo in
                        ScrollView {
                            VStack(spacing: 0) {
                                profileAndNickname
                                    .padding(.bottom, 24)
                                
                                if viewModel.state.getUserPreviewResponse.totalElements >= 1 {
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Text(.review)
                                                .font(.body_bold)
                                            Spacer()
                                            Text("\(viewModel.state.getUserPreviewResponse.totalElements)")
                                                .foregroundStyle(Color.main)
                                                .padding(.trailing, 8)
                                            Button {
                                                AppState.shared.navigationPath.append(UserProfileViewType.reviewAll(id: memberId))
                                            } label: {
                                                HStack(spacing: 0) {
                                                    Text(.seeAll)
                                                        .font(.body02)
                                                    Image("icRight")
                                                        .resizable()
                                                        .frame(width: 12, height: 12)
                                                }
                                            }
                                        }
                                        .padding(.top, 18)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        .padding(.bottom, 18)
                                        
                                        MasonryVStack(columns: 2) {
                                            ForEach(0...viewModel.state.getUserPreviewResponse.data.count - 1, id: \.self) { index in
                                                if index <= 5 {
                                                    ZStack{
                                                        VStack(alignment:.leading, spacing: 0) {
                                                            if viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil {
                                                                KFImage(URL(string: viewModel.state.getUserPreviewResponse.data[index].imageFileDto!.thumbnailUrl))
                                                                    .resizable()
                                                                    .frame(width: Constants.screenWidth * (160 / 360), height: Constants.screenWidth * (136 / 360))
                                                                    .cornerRadius(8, corners: [.topLeft, .topRight])
                                                                
                                                                HStack(spacing: 0){
                                                                    Text(getLocalizedCategory(for: viewModel.state.getUserPreviewResponse.data[index].category))
                                                                        .font(.caption02)
                                                                        .foregroundColor(.main)
                                                                        .padding(EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6))
                                                                        .background(){
                                                                            RoundedRectangle(cornerRadius: 30)
                                                                                .foregroundColor(.main10P)
                                                                        }
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Button {
                                                                        isShowingReport.toggle()
                                                                    } label: {
                                                                        Image("ReviewModifyDot")
                                                                            .resizable()
                                                                            .frame(width: Constants.screenWidth * (20 / 360), height: Constants.screenWidth * (20 / 360))
                                                                    }
                                                                    .padding(.trailing, -Constants.screenWidth * (10/360))
                                                                    
                                                                }
                                                                .padding(.top, 5)
                                                                .padding(.leading)
                                                                .padding(.trailing)
                                                                
                                                                Button(action: {
                                                                    AppState.shared.navigationPath.append(UserProfileViewType.selectReview(id: memberId))
                                                                }, label: {
                                                                    HStack(spacing: 0) {
                                                                        Text("\(viewModel.state.getUserPreviewResponse.data[index].placeName)")
                                                                            .font(.body02_semibold)
                                                                            .lineLimit(3)
                                                                            .padding(.top, 8)
                                                                        Spacer()
                                                                    }
                                                                    .padding(.leading)
                                                                })
                                                                
                                                                Spacer()
                                                                HStack(spacing: 0) {
                                                                    Text("\(viewModel.state.getUserPreviewResponse.data[index].createdAt)")
                                                                        .font(.caption01)
                                                                    Spacer()
                                                                    Image("icHeartFillMain")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("\(viewModel.state.getUserPreviewResponse.data[index].heartCount)")
                                                                        .font(.caption01)
                                                                }
                                                                .padding(.trailing)
                                                                .padding(.leading)
                                                                .padding(.bottom, 8)
                                                            } else {
                                                                HStack(spacing: 0){
                                                                    Text(getLocalizedCategory(for: viewModel.state.getUserPreviewResponse.data[index].category))
                                                                        .font(.caption02)
                                                                        .foregroundColor(.main)
                                                                        .padding(EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6))
                                                                        .background(){
                                                                            RoundedRectangle(cornerRadius: 30)
                                                                                .foregroundColor(.main10P)
                                                                        }
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Button {
                                                                        isShowingReport.toggle()
                                                                    } label: {
                                                                        Image("ReviewModifyDot")
                                                                            .resizable()
                                                                            .frame(width: Constants.screenWidth * (20 / 360), height: Constants.screenWidth * (20 / 360))
                                                                    }
                                                                    .padding(.trailing, -Constants.screenWidth * (10/360))
                                                                    
                                                                }
                                                                .padding(.top, 5)
                                                                .padding(.leading)
                                                                .padding(.trailing)
                                                                
                                                                Button(action: {
                                                                    AppState.shared.navigationPath.append(UserProfileViewType.selectReview(id: memberId))
                                                                }, label: {
                                                                    HStack(spacing: 0) {
                                                                        Text("\(viewModel.state.getUserPreviewResponse.data[index].placeName)")
                                                                            .font(.body02_semibold)
                                                                            .lineLimit(3)
                                                                            .padding(.top, 8)
                                                                        Spacer()
                                                                    }
                                                                    .padding(.leading)
                                                                })
                                                                
                                                                Spacer()
                                                                HStack(spacing: 0) {
                                                                    Text("\(viewModel.state.getUserPreviewResponse.data[index].createdAt)")
                                                                        .font(.caption01)
                                                                    Spacer()
                                                                    Image("icHeartFillMain")
                                                                        .resizable()
                                                                        .frame(width: 20, height: 20)
                                                                    Text("\(viewModel.state.getUserPreviewResponse.data[index].heartCount)")
                                                                        .font(.caption01)
                                                                }
                                                                .padding(.trailing)
                                                                .padding(.leading)
                                                                .padding(.bottom, 8)
                                                            }
                                                            
                                                        }
                                                        .frame(width: Constants.screenWidth * (160 / 360), height: viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil ? Constants.screenWidth * (214 / 360) : Constants.screenWidth * (103 / 360))
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(Color.white)
                                                                .frame(width: Constants.screenWidth * (160 / 360), height: viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil ? Constants.screenWidth * (214 / 360) : Constants.screenWidth * (103 / 360))
                                                                .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                                        )
                                                    }
                                                    .sheet(isPresented: $isShowingReport) {
                                                        UserProfileReportModal(id: Int64(viewModel.state.getUserPreviewResponse.data[index].id), isShowingReport: $isShowingReport)
                                                            .presentationDetents([.height(Constants.screenWidth * (136 / 360))])
                                                    }
                                                }
                                                
                                                
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.bottom, 16)
                                        
                                        Spacer()
                                    }
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(minHeight: Constants.screenWidth * (460 / 360))
                                            .cornerRadius(30, corners: [.topLeft, .topRight])
                                            .shadow(radius: 1)
                                    )
                                    .padding(.top, Constants.screenWidth * (100 / 360))
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationDestination(for: UserProfileViewType.self) { viewType in
            switch viewType {
            case let .reviewAll(id):
                ReviewAllMainView(memberId: id)
            case let .selectReview(id):
                ReviewAllMainView(memberId: id, selectedReviewId: id)
            case let .report(id, isReport):
                ReportReasonView(id: id, isReport: $isReport, isUserReport: true)
            case let .reportReview(id, isReport):
                ReportReasonView(id: id, isReport: $isReport, isUserReport: false)
            }
        }
        .onAppear {
            print("\(memberId)")
            print("\(appState.userInfo)")
            Task {
                await getUserPreview(memberId: memberId)
                await getUserProfileInfo(id: memberId)
                isAPICalled = true
            }
        }
        .toolbar(.hidden)
        .sheet(isPresented: $reportModal, onDismiss: {
            if reportReasonViewFlag {
                AppState.shared.navigationPath.append(UserProfileViewType.report(id: memberId, isReport: isReport))
            }
        }) {
            ReportModalView(reportReasonViewFlag: $reportReasonViewFlag)
                .presentationDetents([.height(Constants.screenWidth * (103 / Constants.screenWidth))])
        }
        .overlay(
            Toast(message: LocalizedKey.reportResult.localized(for: LocalizationManager.shared.language), isShowing: $isReport, isAnimating: true)
        )
    }
    /// 서버에서 받아온 `category`를 번역된 텍스트로 반환
    func getLocalizedCategory(for category: String) -> String {
        if let localizedKey = LocalizedKey(rawValue: category) {
            return localizedKey.localized(for: LocalizationManager.shared.language)
        } else {
            return category // 매핑되지 않는 경우 기본값 반환
        }
    }
    
    private var profileAndNickname: some View {
        
        VStack(spacing: 0) {
            HStack{
                VStack{
                    if provider == "GUEST" {
                        HStack{
                            Button(action: {
                                AppState.shared.showRegisterInduction = true
                            }, label: {
                                HStack(spacing: 0) {
                                    Text(.loginRequired)
                                        .font(.title01_bold)
                                    
                                    Image(.icRight)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                }
                            })
                            .tint(.baseBlack)
                        }
                        .padding(.bottom, 20)
                    } else {
                        HStack{
                            if viewModel.state.getUserProfileInfoResponse.nickname == "" {
                                Text("닉네임 없음")
                                    .font(.title02_bold)
                            } else {
                                Text("\(viewModel.state.getUserProfileInfoResponse.nickname)")
                                    .font(.title02_bold)
                            }
                            
                            Spacer()
                        }
                    }
                    
                    if provider != "GUEST" {
                        if viewModel.state.getUserProfileInfoResponse.description.isEmpty {
                            HStack(spacing: 0){
                                Text(.noDescription)
                                    .font(.body02)
                                    .foregroundColor(.gray2)
                                
                                Spacer()
                            }
                        } else {
                            HStack(spacing: 0) {
                                Text("\(viewModel.state.getUserProfileInfoResponse.description)")
                                    .font(.body02)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(3)
                                
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                if provider == "GUEST" {
                    Image(.guestProfile)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .background(.blue)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                        .padding(.leading, 15)
                } else {
                    KFImage(URL(string: viewModel.state.getUserProfileInfoResponse.profileImage.originUrl))
                        .placeholder {
                            Image(.guestProfile) // 로드 전 표시될 이미지
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .background(.blue)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                        .padding(.leading, 15)
                }
            }
            .padding(.leading)
            .padding(.trailing)
            
            RoundedRectangle(cornerRadius: 12)
                .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (76 / 360))
                .foregroundColor(.white)
                .shadow(radius: 1)
                .overlay{
                    if provider != "GUEST" {
                        HStack(spacing: 12){
                            
                            if let travelType = viewModel.state.getUserProfileInfoResponse.travelType {
                                Image(getImageName(for: travelType))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: Constants.screenWidth * (52 / 360), height: Constants.screenWidth * (52 / 360))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .clipped()
                                
                                VStack(spacing: 8){
                                    HStack(spacing: 0){
                                        Button(action: {
                                            AppState.shared.navigationPath.append(MyPageViewType.test(type: travelType, nickname: viewModel.state.getUserProfileInfoResponse.nickname))
                                        }, label: {
                                            Text("\(travelType)")
                                                .font(.caption01)
                                                .foregroundStyle(Color.main)
                                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                                .background(){
                                                    Rectangle()
                                                        .cornerRadius(30)
                                                        .foregroundColor(.white)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 30)
                                                                .stroke(Color.main, lineWidth: 1.0)
                                                        )
                                                }
                                        })
                                        
                                        Spacer()
                                    }
                                    
                                    if !viewModel.state.getUserProfileInfoResponse.hashtags.isEmpty {
                                        HStack(spacing: 8) {
                                            ForEach(viewModel.state.getUserProfileInfoResponse.hashtags, id: \.self) { hashtag in
                                                Text("#\(hashtag)")
                                                    .font(.caption01)
                                                    .foregroundStyle(Color.main)
                                            }
                                            Spacer()
                                            
                                        }
                                    }
                                }
                                
                            } else {
                                VStack(alignment: .leading, spacing: 10){
                                    Text(.none)
                                        .font(.caption01)
                                        .foregroundStyle(Color.main)
                                        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                                        .background(){
                                            Rectangle()
                                                .cornerRadius(30)
                                                .foregroundColor(.white)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(Color.main, lineWidth: 2.0)
                                                )
                                        }
                                    
                                }
                                
                                Spacer()
                            }
                            
                        }
                        .padding(.leading)
                        .padding(.trailing)
                        
                        
                        
                        Spacer()
                    }
                }
        }
        .frame(width: Constants.screenWidth)
        .padding(.top, 40)
        .background(alignment: .top) {
            Rectangle()
                .fill(Color.main.opacity(0.1))
                .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        }
        
    }
    
    func getUserPreview(memberId: Int64) async {
        await viewModel.action(.getUserPreviewResponse(memberId: memberId))
    }
    func getUserProfileInfo(id: Int64) async {
        await viewModel.action(.getUserProfileInfo(id: id))
    }
    
    func getImageName(for travelType: String) -> String {
        typeItems.first(where: {
            $0.korean == travelType ||
            $0.english == travelType ||
            $0.chinese == travelType ||
            $0.malay == travelType ||
            $0.vietnamese == travelType
        })?.imageName ?? "default_image"
    }
}

enum UserProfileViewType: Hashable {
    case reviewAll(id: Int64)
    case selectReview(id: Int64)
    case report(id: Int64, isReport: Bool) // 신고하기
    case reportReview(id: Int64, isReport: Bool) // 신고하기
}

//#Preview {
//    UserProfileMainView(memberId: 2)
//        .environmentObject(LocalizationManager())
//}

