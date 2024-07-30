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
    @StateObject var appState = AppState.shared
    @AppStorage("provider") var provider: String = ""
    @State private var selectedNotice: ProfileMainModel.Notice? = nil
    
    var body: some View {
        
        VStack(spacing: 0) {
            navigationBar
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        profileAndNickname
                            .padding(.bottom, 24)
                        
                        ProfileList(selectedNotice: $selectedNotice)
                            .frame(minHeight: geo.size.height)
                    }
                }
            }
        }
        .onAppear {
            viewModel.state.getProfileMainResponse.nickname = AppState.shared.userInfo.nickname
            viewModel.state.getProfileMainResponse.profileImageUrl = AppState.shared.userInfo.profileImageUrl
            viewModel.state.getProfileMainResponse.description = AppState.shared.userInfo.description
        }
        .navigationDestination(for: MyPageViewType.self) { viewType in
            
            switch viewType {
            case .setting:
                SettingView()
            case .update:
                ProfileUpdateView()
            case .test:
                TypeTestProfileView(nickname: AppState.shared.userInfo.nickname)
                    .environmentObject(TypeTestViewModel())
            case .allReview:
                MyReviewView(viewModel: viewModel)
                    .environmentObject(LocalizationManager())
            case .allNotice:
                NoticeMainView(viewModel: viewModel)
                    .environmentObject(LocalizationManager())
            case .detailReview:
                Text("test")
            case .detailNotice:
                if let selectedNotice = selectedNotice {
                    NoticeDetailView(notice: selectedNotice)
                        .environmentObject(LocalizationManager())
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        
    }
    
    private var navigationBar: some View {
        ZStack {
            NanaNavigationBar(title: .mynana)
            
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
                    KFImage(URL(string: (AppState.shared.userInfo.profileImageUrl)))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
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
                                    .font(.largeTitle02)
                            } else {
                                Text("\(AppState.shared.userInfo.nickname)")
                                    .font(.largeTitle02)
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
                                AppState.shared.navigationPath.append(MyPageViewType.test)
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
                                                    .stroke(Color.main, lineWidth: 2.0)
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
    @Binding var selectedNotice: ProfileMainModel.Notice?
    @State var tabIndex = 0
    
    var body: some View {
        VStack {
            ProfileTabBarView(currentTab: $tabIndex)
                .padding(.top, 20)
            
            switch tabIndex {
            case 0:
                reviewTabView()
            case 1:
                noticeTabView(selectedNotice: $selectedNotice)
            default:
                reviewTabView()
            }
        }
        .background(
            Rectangle()
                .fill(Color.white)
                .cornerRadius(50, corners: [.topLeft, .topRight])
                .shadow(radius: 1)
        )
    }
}

struct ProfileTabBarView: View {
    @Binding var currentTab: Int
    var tabBarOptions: [String] = [LocalizedKey.review.localized(for: LocalizationManager().language), LocalizedKey.notice.localized(for: LocalizationManager().language)]
    @Namespace var namespace
    var body: some View {
        HStack {
            ForEach(tabBarOptions.indices, id: \.self) { index in
                let title = tabBarOptions[index]
                ProfileTabBarItem(currentTab: $currentTab, namespace: namespace,
                                  title: title,
                                  tab: index)
                .font(.gothicNeo(.medium, size: 12))
            }
        }
        .frame(height: 32)
        .padding(.horizontal)
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
                    .font(currentTab == tab ? .body02_semibold : .body02)
                if currentTab == tab {
                    Color.main
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct reviewTabView: View {
    @StateObject var viewModel = ProfileMainViewModel()
    
    var layout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    
                    Button(action: {
                        AppState.shared.navigationPath.append(MyPageViewType.allReview)
                    }, label: {
                        
                        Text("\(viewModel.state.getProfileMainResponse.reviews.count)")
                            .font(.body02_semibold)
                            .foregroundColor(.main)
                        
                        +
                        Text(" 모두 보기 >")
                            .font(.body02_semibold)
                            .foregroundColor(.black)
                    })
                    
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        HStack{
                            Image("icPencilMain")
                            
                            Text("리뷰 작성하기")
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
                
                if viewModel.state.getProfileMainResponse.reviews.count != 0 {
                    MasonryVStack(columns: 2) {
                        ForEach(viewModel.state.getProfileMainResponse.reviews, id: \.id) { review in
                            Button(action: {
                                
                            }, label: {
                                ReviewArticleItemView(review: review)
                                .padding(.top, 17)
                            })
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.top, -20)
                } else {
                    Text(.noReview)
                        .font(.body01)
                        .foregroundColor(.gray1)
                        .padding(.top, 100)
                }
                
                Spacer()
            }
            
        }
    }
}

struct noticeTabView: View {
    @StateObject var viewModel = ProfileMainViewModel()
    @Binding var selectedNotice: ProfileMainModel.Notice?
    
    let layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack{
                
                HStack{
                    
                    Button(action: {
                        AppState.shared.navigationPath.append(MyPageViewType.allNotice)
                    }, label: {
                        
                        Text("\(viewModel.state.getProfileMainResponse.notices.count)")
                            .font(.body02_semibold)
                            .foregroundColor(.main)
                        
                        +
                        Text(" 모두 보기 >")
                            .font(.body02_semibold)
                            .foregroundColor(.black)
                    })
                    
                    Spacer()
                }
                .padding(.top, 9)
                .padding()
                
                if viewModel.state.getProfileMainResponse.notices.count != 0 {
                    LazyVGrid(columns: layout, content: {
                        ForEach(viewModel.state.getProfileMainResponse.notices, id: \.id) { notice in
                            Button(action: {
                                selectedNotice = notice
                                AppState.shared.navigationPath.append(MyPageViewType.detailNotice)
                            }, label: {
                                NoticeArticleItemView(title: notice.title, type: notice.type, date: notice.date)
                                    .padding(.bottom, 10)
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

enum MyPageViewType {
    case setting
    case update
    case test
    case allReview
    case allNotice
    case detailReview
    case detailNotice
}

#Preview {
    ProfileMainView()
}

