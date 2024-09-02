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

struct ProfileMainView: View {
    @StateObject var viewModel = ProfileMainViewModel()
    @StateObject var noticeViewModel = NoticeMainViewModel()
    @StateObject var appState = AppState.shared
    @AppStorage("provider") var provider: String = ""
    
    var body: some View {
        
        VStack(spacing: 0) {
            navigationBar
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
            case .detailReview:
                Text("test")
            case let .detailNotice(id):
                NoticeDetailView(id: id)
                    .environmentObject(LocalizationManager())
            case let .selectReview(id):
                MyAllReviewView(viewModel: MyAllReviewViewModel(), selectedReviewId: id)
            case let .writeReview:
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
                
                if provider == "GUEST" {
                    Image(.guestProfile)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                        .padding(.leading, 15)
                } else {
                    KFImage(URL(string: AppState.shared.userInfo.profileImage.originUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .background(.blue)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                        .padding(.leading, 15)
                }
                
                VStack{
                    HStack{
                        if provider == "GUEST" {
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
                            
                        } else {
                            if AppState.shared.userInfo.nickname == "" {
                                Text("닉네임 없음")
                                    .font(.title02_bold)
                            } else {
                                Text("\(AppState.shared.userInfo.nickname)")
                                    .font(.title02_bold)
                            }
                        }
                        
                        Button(action: {
                            AppState.shared.navigationPath.append(MyPageViewType.update)
                        }, label: {
                            Image("icPencil")
                        })
                        .padding(.leading, -5)
                        
                        Spacer()
                    }
                    
                    HStack{
                        if let travelType = appState.userInfo.travelType {
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
                            
                        } else {
                            Text(.none)
                                .font(.caption01)
                                .foregroundStyle(Color.main)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
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
                    .padding(.top, -10)
                    
                    HStack{
                        if !AppState.shared.userInfo.hashtags.isEmpty {
                            HStack(spacing: 8) {
                                ForEach(AppState.shared.userInfo.hashtags, id: \.self) { hashtag in
                                    Text("#\(hashtag)")
                                        .font(.caption01)
                                        .foregroundStyle(Color.main)
                                }
                                Spacer()
                                
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 3)
                    .padding(.top, 3)
                    
                    HStack(spacing: 0) {
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
                        })
                        .tint(.baseBlack)
                        Spacer()
                    }
                    .padding(.leading, 3)
                    
                    Spacer()
                }
                
                Spacer()
            }
            
            if AppState.shared.userInfo.description.isEmpty {
                HStack(spacing: 0) {
                    VStack{
                        Text(.noDescription)
                            .font(.body02)
                            .foregroundColor(.gray2)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 30, trailing: 20))
                        Spacer()
                    }
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(minWidth: Constants.screenWidth - 32, minHeight: 88)
                        .shadow(radius: 1)
                    
                )
                .padding(.top, 6)
                .padding(16)
            } else {
                HStack(spacing: 0) {
                    VStack{
                        Text("\(AppState.shared.userInfo.description)")
                            .font(.body02)
                            .padding()
                        
                        Spacer()
                    }
                    Spacer()
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .frame(minWidth: Constants.screenWidth - 32, minHeight: 88)
                        .shadow(radius: 1)
                    
                )
                .padding(.top, 6)
                .padding(16)
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
}

struct ProfileList: View {
    @State var tabIndex = 0
    @AppStorage("provider") var provider: String = ""
    
    var body: some View {
        VStack {
            ProfileTabBarView(currentTab: $tabIndex)
                .padding(.top, 20)
            
            if provider == "GUEST" {
                guestTabView()
            } else {            
                switch tabIndex {
                case 0:
                    reviewTabView()
                case 1:
                    noticeTabView()
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

struct ProfileTabBarView: View {
    @Binding var currentTab: Int
    var tabBarOptions: [String] = [LocalizedKey.review.localized(for: LocalizationManager().language), LocalizedKey.notice.localized(for: LocalizationManager().language)]
    
    @Namespace var namespace
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabBarOptions.indices, id: \.self) { index in
                let title = tabBarOptions[index]
                ProfileTabBarItem(currentTab: $currentTab, namespace: namespace,
                                  title: title,
                                  tab: index)
                .font(.gothicNeo(.medium, size: 12))
            }
        }
        .frame(height: 32)
//        .padding(.horizontal)
    }
}

struct ProfileTabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var title: String
    var tab: Int
    
    var body: some View {
        Button {
            withAnimation(nil) {
                currentTab = tab
            }
        } label: {
            VStack {
                Spacer()
                Text(title)
                    .font(currentTab == tab ? .body02 : .body02)
                if currentTab == tab {
                    Color.main
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self)
                } else {
                    Color.gray.frame(height: 2)
                }
            }
            .animation(.default, value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct guestTabView: View {
    
    var body: some View {
        ZStack{
            VStack{
                
                Text("로그인하여 나만의 경험을 기록해보세요!")
                    .font(.body01)
                    .foregroundColor(.gray1)
                    .padding(.top, 100)
                
                Spacer()
            }
        }
    }
}

struct reviewTabView: View {
    @StateObject var viewModel = MyReviewViewModel()
    @State private var isAPICalled = false
    
    var layout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ScrollView {
            if isAPICalled {
                ZStack {
                    VStack{
                        HStack{
                            
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
                            
                            
                            Spacer()
                            
                            Button(action: {
                                AppState.shared.navigationPath.append(MyPageViewType.writeReview) // 후기 작성 페이지로 이도
                            }, label: {
                                HStack{
                                    Image("icPencilMain")
                                    
                                    Text(.writeReview)
                                        .font(.caption01_semibold)
                                        .foregroundColor(.black)
                                        .padding(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 3))
                                }
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 50)
                                        .stroke(Color.main.opacity(0.9), lineWidth: 1)
                                        .foregroundColor(Color.main.opacity(0.1))
                                )
                            })
                        }
                        .padding()
                        
                        if let data = viewModel.state.getMyReviewResponse.data {
                            if data.count != 0 {
                                MasonryVStack(columns: 2) {
                                    ForEach(data, id: \.id) { review in
                                        Button(action: {
                                            AppState.shared.navigationPath.append(MyPageViewType.selectReview(id: review.id))
                                        }, label: {
                                            ReviewArticleItemView(placeName: review.placeName, createdAt: review.createdAt, heartCount: review.heartCount, imageFileDto: review.imageFileDto?.originUrl ?? "")
                                            .padding(.top, 17)
                                        })
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
}

struct noticeTabView: View {
    @StateObject var viewModel = NoticeMainViewModel()
    @State private var isAPICalled = false
    
    let layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            if isAPICalled {
                ZStack {
                    VStack{
                        
                        HStack{
                            
                            Button(action: {
                                AppState.shared.navigationPath.append(MyPageViewType.allNotice)
                            }, label: {
                                
                                Text("\(viewModel.state.getNoticeMainResponse.totalElements)")
                                    .font(.body02_semibold)
                                    .foregroundColor(.main)
                                
                                +
                                Text(" \(LocalizedKey.seeAll.localized(for: LocalizationManager().language))")
                                    .font(.body02_semibold)
                                    .foregroundColor(.black)
                                
                                Image("icPreviewRight")
                                    .padding(.top, 2)
                            })
                            
                            Spacer()
                        }
                        .padding(.top, 9)
                        .padding()
                        
                        if viewModel.state.getNoticeMainResponse.data.count != 0 {
                            LazyVGrid(columns: layout, content: {
                                ForEach(viewModel.state.getNoticeMainResponse.data, id: \.id) { notice in
                                    Button(action: {

                                        AppState.shared.navigationPath.append(MyPageViewType.detailNotice(id: notice.id))
                                    }, label: {
                                        NoticeArticleItemView(title: notice.title, type: notice.noticeCategory, date: notice.createdAt)
                                            .padding(.bottom, 35)
                                    })
                                }
                            })
                            .padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 15))
                        } else {
                            Text(.noNotice)
                                .font(.body01)
                                .foregroundColor(.gray1)
                                .padding(.top, 100)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getNoticeMainItem(page: 0, size: 12)
                isAPICalled = true
            }
        }
    }
    
    func getNoticeMainItem(page: Int, size: Int) async {
        await viewModel.action(.getNoticeMainItem(page: page, size: size))
    }
}

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
    case detailReview
    case detailNotice(id: Int64)
    case writeReview
}

#Preview {
    ProfileMainView()
}

