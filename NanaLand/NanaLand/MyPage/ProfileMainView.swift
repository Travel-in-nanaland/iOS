//
//  ProfileMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import Kingfisher

struct ProfileMainView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = ProfileMainViewModel()
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                NanaNavigationBar(title: "나의나나")
                    .padding(.bottom, 16)
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
            
            VStack(spacing: 0) {
                ZStack {
                    KFImage(URL(string: (appState.userInfo.profileImageUrl)))
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                    VStack(spacing: 0) {
                        Spacer()
                        Text("Lv." + "\(viewModel.state.getProfileMainResponse.level)")
                            .font(.caption01)
                            .padding(.leading, 12)
                            .padding(.trailing, 12)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.main)
                            )
                            .foregroundStyle(Color.white)
                        
                    }
                    .frame(height: 108)
                    
                }
                
                Text("\(appState.userInfo.nickname)")
                    .font(.largeTitle02)
            }
            .padding(.bottom, 56)
            HStack(spacing: 0) {
                Text("여행 유형")
                    .font(.body_bold)
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Text("\(appState.userInfo.travelType)")
                    .font(.title02_bold)
                    .padding(.leading, 16)
                    .foregroundStyle(Color.main)
                Spacer()
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 8) {
                // 해시태그는 항상 3개 고정
                ForEach(0...2, id: \.self) { index in
                    Text("#\(appState.userInfo.hashtags[index])")
                        .font(.body02)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .padding(.top, 7)
                        .padding(.bottom, 7)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.main10P)
                        )
                        .foregroundStyle(Color.main)
                }
                Spacer()
                
            }
            .padding(.leading, 16)
            .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("테스트 다시하기")
                })
                .padding(.leading, 16)
                Spacer()
            }
            .padding(.bottom, 48)
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("소개")
                        .font(.body_bold)
                        .padding(.leading, 16)
                    Spacer()
                }
                .padding(.bottom, 8)
                HStack(spacing: 0) {
                    Text("\(appState.userInfo.description)")
                        .font(.body02)
                        .padding()
                    Spacer()
                }
                
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: 0xF2F2F2))
                        .frame(minWidth: Constants.screenWidth - 32, minHeight: 70)
                    
                )
                .padding(16) // 전체 뷰의 여백
                
            }
            .padding(.bottom, 59)
            
            Spacer()
            NavigationLink(destination: ProfileUpdateView()) {
                Text("프로필 수정")
                    .font(.body_bold)
                    .frame(width: Constants.screenWidth - 32, height: 48)
                    .foregroundColor(.main) // 텍스트 색상 설정
                    .overlay(
                        RoundedRectangle(cornerRadius: 50) // 둥근 테두리 설정
                            .stroke(.main, lineWidth: 1) // 테두리 색상과 두께 설정
                            .frame(width: Constants.screenWidth - 32, height: 48) // 테두리의 크기 설정
                    )
            }
            .padding(.bottom, 24)
        }
        .navigationDestination(for: MyPageViewType.self) { viewType in
            
            switch viewType {
            case .setting:
                SettingView()
            case .update:
                ProfileUpdateView()
            }
        }
        
    }
    
    func getUserInfo() async {
        await viewModel.action(.getUserInfo)
    }
}
enum MyPageViewType {
    case setting
    case update
}

#Preview {
    ProfileMainView()
}
