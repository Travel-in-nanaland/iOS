////
////  ProfileMainView.swift
////  NanaLand
////
////  Created by 정현우 on 4/13/24.
////
//
import SwiftUI
import Kingfisher
import MasonryStack
import CustomAlert

struct ProfileMainView: View {
    @StateObject var viewModel = ProfileMainViewModel()
    @StateObject var noticeViewModel = NoticeMainViewModel()
    @StateObject var appState = AppState.shared
    @AppStorage("provider") var provider: String = ""
    
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
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ZStack{
                GeometryReader { geo in
                    ScrollView {
                        VStack(spacing: 0) {
                            profileAndNickname
                                .padding(.bottom, 24)
                            
                            ProfileList()
                                .frame(minHeight: geo.size.height)
                        }
                    }
                }
                
                HStack(spacing: 0){
                    Spacer()
                    
                    Button(action: {
                        AppState.shared.navigationPath.append(MyPageViewType.writeReview) // 후기 작성 페이지로 이도
                    }, label: {
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: Constants.screenWidth * (81 / 360), height: Constants.screenWidth * (35 / 360))
                            .foregroundColor(.main)
                            .overlay{
                                HStack{
                                    Image("icPencilWhite")
                                        .frame(width: Constants.screenWidth * (20 / 360), height: Constants.screenWidth * (20 / 360))
                                        .padding(.leading, 5)
                                    
                                    Text(.writeReview)
                                        .font(.caption01_semibold)
                                        .frame(height: Constants.screenWidth * (20 / 360))
                                        .foregroundColor(.white)
                                        .padding(.trailing, 8)
                                }
                            }
                    })
                    .zIndex(1)
                }
                .padding()
                .padding(.top, Constants.screenWidth * (450 / 360))
            }
        }
        .onAppear {
            Task {
                await getUserInfo()
                
                AppState.shared.userInfo = viewModel.state.getProfileMainResponse
            }
            
            viewModel.state.getProfileMainResponse.nickname = AppState.shared.userInfo.nickname
            viewModel.state.getProfileMainResponse.profileImage = AppState.shared.userInfo.profileImage
            viewModel.state.getProfileMainResponse.description = AppState.shared.userInfo.description
        }
        .navigationDestination(for: MyPageViewType.self) { viewType in
            
            switch viewType {
            case .setting:
                SettingView()
            case .update:
                ProfileUpdateView()
            case let .test(type, nickname):
                TypeTestProfileView(type: type, nickname: nickname)
            case .allReview:
                MyAllReviewView(viewModel: MyAllReviewViewModel())
                    .environmentObject(LocalizationManager())
                Text("")
            case .allNotice:
                NoticeMainView(viewModel: noticeViewModel)
                    .environmentObject(LocalizationManager())
            case let .detailReview(id, category):
                MyReviewDetailView(reviewId: id, reviewCategory: category)
                    .environmentObject(LocalizationManager())
            case let .detailNotice(id):
                NoticeDetailView(id: id)
                    .environmentObject(LocalizationManager())
            case let .selectReview(id):
                MyAllReviewView(viewModel: MyAllReviewViewModel(), selectedReviewId: id)
            case .writeReview:
                ProfileReviewWriteView()
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    func getUserInfo() async {
        await viewModel.action(.getUserInfo)
    }
    
    private var navigationBar: some View {
        ZStack {
            NanaNavigationBar(title: .myNana)
            
            HStack(spacing: 0) {
                Spacer()
                Button(action: {
                    AppState.shared.navigationPath.append(MyPageViewType.setting)
                }, label: {
                    Image("icSetting")
                        .padding(.bottom, 16)
                        .padding(.trailing, 12)
                })
                
            }
            
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
                            if AppState.shared.userInfo.nickname == "" {
                                Text("닉네임 없음")
                                    .font(.title02_bold)
                            } else {
                                Text("\(AppState.shared.userInfo.nickname)")
                                    .font(.title02_bold)
                            }
                            
                            Button(action: {
                                AppState.shared.navigationPath.append(MyPageViewType.update)
                            }, label: {
                                Image("icPencil")
                            })
                            .padding(.leading, -5)
                            
                            Spacer()
                        }
                    }
                    
                    if provider != "GUEST" {
                        if AppState.shared.userInfo.description.isEmpty {
                            HStack(spacing: 0){
                                Text(.noDescription)
                                    .font(.body02)
                                    .foregroundColor(.gray2)
                                
                                Spacer()
                            }
                        } else {
                            HStack(spacing: 0) {
                                Text("\(AppState.shared.userInfo.description)")
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
                    KFImage(URL(string: AppState.shared.userInfo.profileImage.originUrl))
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
                        ZStack{
                            HStack(spacing: 12){
                                
                                if let travelType = appState.userInfo.travelType {
                                    Image(getImageName(for: travelType))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: Constants.screenWidth * (52 / 360), height: Constants.screenWidth * (52 / 360))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .clipped()
                                    
                                    VStack(spacing: 8){
                                        HStack(spacing: 0){
                                            Button(action: {
                                                AppState.shared.navigationPath.append(MyPageViewType.test(type: travelType, nickname: AppState.shared.userInfo.nickname))
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
                                        
                                        if !AppState.shared.userInfo.hashtags.isEmpty {
                                            HStack(spacing: 8) {
                                                ForEach(AppState.shared.userInfo.hashtags, id: \.self) { hashtag in
                                                    Text("#\(hashtag)")
                                                        .lineLimit(1)
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
                            
                            HStack(spacing: 0){
                                Spacer()
                                
                                if let travelType = appState.userInfo.travelType {
                                    
                                    VStack(spacing: 0){
                                        Button(action: {
                                            appState.showTypeTest = true
                                        }, label: {
                                            HStack(spacing: 4) {
                                                Text(AppState.shared.userInfo.hashtags.isEmpty ? .goTest :.retest)
                                                    .font(.gothicNeo(.semibold, size: 12))
                                                
                                                Image(.icRight)
                                                    .resizable()
                                                    .frame(width: 16, height: 16)
                                            }
                                            .frame(height: Constants.screenWidth * (20 / 360))
                                        })
                                        .tint(.baseBlack)
                                        
                                        Spacer()
                                    }
                                    .padding(.top)
                                    .padding(.trailing, 10)
                                } else {
                                    Button(action: {
                                        appState.showTypeTest = true
                                    }, label: {
                                        HStack(spacing: 4) {
                                            Text(AppState.shared.userInfo.hashtags.isEmpty ? .goTest :.retest)
                                                .font(.gothicNeo(.semibold, size: 12))
                                            
                                            Image(.icRight)
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .frame(height: Constants.screenWidth * (20 / 360))
                                    })
                                    .tint(.baseBlack)
                                }
                                
                            }
                        }
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

struct ProfileList: View {
    @State var tabIndex = 0
    @AppStorage("provider") var provider: String = ""
    
    var body: some View {
        VStack {
            
            if provider == "GUEST" {
                guestTabView()
            } else {
                switch tabIndex {
                case 0:
                    reviewTabView()
                default:
                    reviewTabView()
                }
            }
            
        }
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(30, corners: [.topLeft, .topRight])
                .shadow(radius: 1)
        )
    }
}

//struct ProfileTabBarView: View {
//    @Binding var currentTab: Int
//    var tabBarOptions: [String] = [LocalizedKey.review.localized(for: LocalizationManager().language), LocalizedKey.notice.localized(for: LocalizationManager().language)]
//
//    @Namespace var namespace
//    var body: some View {
//        HStack(spacing: 0) {
//            ForEach(tabBarOptions.indices, id: \.self) { index in
//                let title = tabBarOptions[index]
//                ProfileTabBarItem(currentTab: $currentTab, namespace: namespace,
//                                  title: title,
//                                  tab: index)
//                .font(.gothicNeo(.medium, size: 12))
//            }
//        }
//        .frame(height: 32)
//        //        .padding(.horizontal)
//    }
//}

//struct ProfileTabBarItem: View {
//    @Binding var currentTab: Int
//    let namespace: Namespace.ID
//    var title: String
//    var tab: Int
//
//    var body: some View {
//        Button {
//            withAnimation(nil) {
//                currentTab = tab
//            }
//        } label: {
//            VStack {
//                Spacer()
//                Text(title)
//                    .font(currentTab == tab ? .body02 : .body02)
//                if currentTab == tab {
//                    Color.main
//                        .frame(height: 2)
//                        .matchedGeometryEffect(id: "underline",
//                                               in: namespace.self)
//                } else {
//                    Color.gray.frame(height: 2)
//                }
//            }
//            .animation(.default, value: currentTab)
//        }
//        .buttonStyle(.plain)
//    }
//}

struct guestTabView: View {
    
    var body: some View {
        ZStack{
            VStack{
                
                Text(.loginReview)
                    .font(.body01)
                    .foregroundColor(.gray1)
                    .padding(.top, 100)
                
                Spacer()
            }
            .frame(width: Constants.screenWidth)
        }
    }
}

struct reviewTabView: View {
    @StateObject var viewModel = MyReviewViewModel()
    @State private var isAPICalled = false
    @State var isShowingModify = false
    @State var showAlert = false
    @EnvironmentObject var localizationManager: LocalizationManager
    @State var deleteId: Int64 = 0
    
    var layout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            if isAPICalled {
                ZStack {
                    VStack{
                        HStack{
                            
                            Text(.review)
                                .font(.body02)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button(action: {
                                AppState.shared.navigationPath.append(MyPageViewType.allReview)
                            }, label: {
                                
                                Text("\(viewModel.state.getMyReviewResponse.totalElements)")
                                    .font(.body02_semibold)
                                    .foregroundColor(.main)
                                
                                +
                                
                                Text(" \(LocalizedKey.seeAll.localized(for: LocalizationManager().language))")
                                    .font(.body02_semibold)
                                    .foregroundColor(.black)
                                
                                Image("icPreviewRight")
                                    .padding(.top, 2)
                            })
                        }
                        .padding()
                        
                        if let data = viewModel.state.getMyReviewResponse.data {
                            if data.count != 0 {
                                MasonryVStack(columns: 2) {
                                    ForEach(data, id: \.id) { review in
                                        ReviewArticleItemView(
                                            id: review.id,
                                            deleteId: $deleteId,
                                            category: review.category, placeName: review.placeName, createdAt: review.createdAt, heartCount: review.heartCount, imageFileDto: review.imageFileDto?.originUrl ?? "",
                                            isShowingModify: $isShowingModify)
                                        .sheet(isPresented: $isShowingModify) {
                                            ReviewModifyModal(id: review.id, category: review.category, isShowingModify: $isShowingModify, showAlert: $showAlert)
                                                .environmentObject(LocalizationManager())
                                                .presentationDetents([.height(Constants.screenWidth * (184 / 360))]) // 팝업 뷰 height 조절
                                        }
                                        .customAlert(LocalizedKey.reviewDeleteMessage.localized(for: localizationManager.language), isPresented: $showAlert) {
                                            
                                        } actions: {
                                            MultiButton{
                                                Button {
                                                    showAlert = false
                                                    print("삭제 요청: \(deleteId)")
                                                    Task {
                                                        await deleteMyReview(id: deleteId)
                                                        await getMyReviewItem()
                                                    }
                                                } label: {
                                                    Text(.yes)
                                                        .font(.title02_bold)
                                                        .foregroundStyle(Color.black)
                                                }
                                                
                                                Button {
                                                    showAlert = false
                                                } label: {
                                                    Text(.no)
                                                        .font(.title02_bold)
                                                        .foregroundStyle(Color.main)
                                                }
                                                
                                            }
                                        }
                                        .padding(.top, 17)
                                    }
                                }
                                .frame(width: Constants.screenWidth * 0.93)
                                .padding(.leading, 5)
                                .padding(.top, -20)
                                .padding(.bottom, 100)
                            } else {
                                Text(.noReview)
                                    .font(.body01)
                                    .foregroundColor(.gray1)
                                    .padding(.top, 100)
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getMyReviewItem()
                isAPICalled = true
            }
        }
    }
    func getMyReviewItem() async {
        await viewModel.action(.getMyReviewItem)
    }
    func deleteMyReview(id: Int64) async {
        await viewModel.action(.deleteMyReview(id: id))
    }
}

//struct noticeTabView: View {
//    @StateObject var viewModel = NoticeMainViewModel()
//    @State private var isAPICalled = false
//
//    let layout: [GridItem] = [GridItem(.flexible())]
//
//    var body: some View {
//        ScrollView {
//            if isAPICalled {
//                ZStack {
//                    VStack{
//
//                        HStack{
//
//                            Text(.review)
//                                .font(.body02)
//                                .foregroundColor(.black)
//
//                            Spacer()
//
//                            Button(action: {
//                                AppState.shared.navigationPath.append(MyPageViewType.allNotice)
//                            }, label: {
//
//                                Text("\(viewModel.state.getNoticeMainResponse.totalElements)")
//                                    .font(.body02_semibold)
//                                    .foregroundColor(.main)
//
//                                +
//                                Text(" \(LocalizedKey.seeAll.localized(for: LocalizationManager().language))")
//                                    .font(.body02_semibold)
//                                    .foregroundColor(.black)
//
//                                Image("icPreviewRight")
//                                    .padding(.top, 2)
//                            })
//                        }
//                        .padding(.top, 9)
//                        .padding()
//
//                        if viewModel.state.getNoticeMainResponse.data.count != 0 {
//                            LazyVGrid(columns: layout, content: {
//                                ForEach(viewModel.state.getNoticeMainResponse.data, id: \.id) { notice in
//                                    Button(action: {
//
//                                        AppState.shared.navigationPath.append(MyPageViewType.detailNotice(id: notice.id))
//                                    }, label: {
//                                        NoticeArticleItemView(title: notice.title, type: notice.noticeCategory, date: notice.createdAt)
//                                            .padding(.bottom, 35)
//                                    })
//                                }
//                            })
//                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
//                        } else {
//                            Text(.noNotice)
//                                .font(.body01)
//                                .foregroundColor(.gray1)
//                                .padding(.top, 100)
//                        }
//
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .onAppear {
//            Task {
//                await getNoticeMainItem(page: 0, size: 12)
//                isAPICalled = true
//            }
//        }
//    }
//
//    func getNoticeMainItem(page: Int, size: Int) async {
//        await viewModel.action(.getNoticeMainItem(page: page, size: size))
//    }
//}

struct profileUpdateButton: View {
    var body: some View {
        NavigationLink(destination: ProfileUpdateView()) {
            Text(.editProfile)
                .font(.body_bold)
                .frame(width: Constants.screenWidth - 32, height: 48)
                .foregroundColor(.main) // 텍스트 색상 설정
                .overlay(
                    RoundedRectangle(cornerRadius: 50) // 둥근 테두리 설정
                        .stroke(.main, lineWidth: 1) // 테두리 색상과 두께 설정
                        .frame(width: Constants.screenWidth - 32, height: 48) // 테두리의 크기 설정
                )
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

enum MyPageViewType: Hashable {
    case setting
    case update
    case test(type: String, nickname: String)
    case allReview
    case selectReview(id: Int64)
    case allNotice
    case detailNotice(id: Int64)
    case writeReview
    case detailReview(id: Int64, category: String)
}

#Preview {
    ProfileMainView()
}

