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
    @State private var isAPICalled = false
    @AppStorage("provider") var provider: String = ""
    @State private var reportModal = false // 신고하기 모달창
    var memberId: Int64 = 1
    var body: some View {
        VStack(spacing: 0) {
            ZStack() {
                NanaNavigationBar(title: .emptyString, showBackButton: true)
                HStack(spacing: 0) {
                    Spacer()
                    Button {
                        reportModal = true
                    } label: {
                        Image("icPointBtn")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding(.trailing, 14)
                    }
                }
            }
            .sheet(isPresented: $reportModal) {
                ReportModalView()
                    .presentationDetents([.height(Constants.screenWidth * (103 / Constants.screenWidth))])
            }
            if isAPICalled {
                GeometryReader { geo in
                    ScrollView {
                        VStack(spacing: 0) {
                            profileAndNickname
                                .padding(.bottom, 24)
                            if viewModel.state.getUserPreviewResponse.totalElements >= 1 {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("후기")
                                            .font(.body_bold)
                                        Spacer()
                                        Text("\(viewModel.state.getUserPreviewResponse.totalElements)")
                                            .foregroundStyle(Color.main)
                                            .padding(.trailing, 8)
                                        Button {
                                            AppState.shared.navigationPath.append(UserProfileViewType.reviewAll(id: memberId))
                                        } label: {
                                            HStack(spacing: 0) {
                                                Text("모두 보기")
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
                                    Divider()
                                        .padding(.bottom, 16)
                                    
                                    MasonryVStack(columns: 2) {
                                        ForEach(0...viewModel.state.getUserPreviewResponse.data.count - 1, id: \.self) { index in
                                            if index <= 5 {
                                                Button {
                                                    
                                                } label: {
                                                    
                                                    VStack(alignment:.leading, spacing: 0) {
                                                        if viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil {
                                                            KFImage(URL(string: viewModel.state.getUserPreviewResponse.data[index].imageFileDto!.thumbnailUrl))
                                                                .resizable()
                                                                .frame(width: (Constants.screenWidth - 40) / 2, height: 136)
                                                                .cornerRadius(8, corners: [.topLeft, .topRight])
                                                        }
                                                        HStack(spacing: 0) {
                                                            Text("\(viewModel.state.getUserPreviewResponse.data[index].placeName)")
                                                                .font(.body02_bold)
                                                                .lineLimit(1)
                                                                .padding(.leading, 8)
                                                                .padding(.top, 8)
                                                            Spacer()
                                                        }
                                                        Spacer()
                                                        HStack(spacing: 0) {
                                                            Text("\(viewModel.state.getUserPreviewResponse.data[index].createdAt)")
                                                                .font(.caption01)
                                                                .padding(.leading, 8)
                                                            Spacer()
                                                            Image("icHeartFillMain")
                                                                .resizable()
                                                                .frame(width: 20, height: 20)
                                                            Text("\(viewModel.state.getUserPreviewResponse.data[index].heartCount)")
                                                                .font(.caption01)
                                                                .padding(.trailing, 8)
                                                        }
                                                        .padding(.bottom, 8)
                                                      
                                                        
                                            
                                                    }
                                                    .frame(width: (Constants.screenWidth - 40) / 2, height: viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil ? 196 : 90)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color.white)
                                                            .frame(minWidth: (Constants.screenWidth - 40) / 2, minHeight: viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil ? 196 : 90)
                                                            .shadow(color: Color.gray, radius: 1, x: 0, y: 0)
                                                    )
                                                    .padding(.horizontal, 16)
                                                    
                                                }
                                                .frame(width: (Constants.screenWidth - 40) / 2, height: viewModel.state.getUserPreviewResponse.data[index].imageFileDto != nil ? 196 : 90)
                                            }
                                            
                                            
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                   
                                }
                                .background(Color.white)
                                
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
                    KFImage(URL(string: (viewModel.state.getUserProfileInfoResponse.profileImage.thumbnailUrl)))
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
                                Text("\(viewModel.state.getUserProfileInfoResponse.nickname)")
                                    .font(.largeTitle02)
                            }
                        }
                        
                      
                        
                        Spacer()
                    }
                    
                    HStack{
                        if let travelType = viewModel.state.getUserProfileInfoResponse.travelType {
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
                            Text("\(viewModel.state.getUserProfileInfoResponse.description)")
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
                                ForEach(viewModel.state.getUserProfileInfoResponse.hashtags, id: \.self) { hashtag in
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
    
    func getUserPreview(memberId: Int64) async {
        await viewModel.action(.getUserPreviewResponse(memberId: memberId))
    }
    func getUserProfileInfo(id: Int64) async {
        await viewModel.action(.getUserProfileInfo(id: id))
    }
}

enum UserProfileViewType: Hashable {
    case reviewAll(id: Int64)
}

#Preview {
    UserProfileMainView(memberId: 2)
}