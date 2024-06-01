//
//  ProfileMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import Kingfisher

struct ProfileMainView: View {
    @StateObject var viewModel = ProfileMainViewModel()
	@StateObject var appState = AppState.shared
	@AppStorage("provider") var provider: String = ""
	
    var body: some View {
		
        VStack(spacing: 0) {
			navigationBar
            GeometryReader { geometry in
                ScrollView {
					VStack(spacing: 0) {
						profileAndNickname
							.padding(.bottom, 24)
						
						Rectangle()
							.fill(Color.gray3)
							.frame(width: Constants.screenWidth, height: 8)
							.padding(.bottom, 24)
						
						travelTypePart
							.padding(.bottom, 32)
						
						introducePart
							.padding(.bottom, 19)
						
						Spacer(minLength: 0)
						
						if provider != "GUEST" {
							profileUpdateButton
								.padding(.bottom, 24)
						}
                    }
                }
                .frame(height: geometry.size.height)
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
            }
        }
        
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
			ZStack {
				if provider == "GUEST" {
					Image(.guestProfile)
						.resizable()
						.frame(width: 100, height: 100)
						.clipShape(Circle())
						.padding(.bottom, 16)
				} else {
					KFImage(URL(string: (AppState.shared.userInfo.profileImageUrl)))
						.resizable()
						.aspectRatio(contentMode: .fill)
						.frame(width: 100, height: 100)
						.clipShape(Circle())
						.padding(.bottom, 16)
				}
				
				if provider != "GUEST" {
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
				
			}
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
				Text("\(AppState.shared.userInfo.nickname)")
					.font(.largeTitle02)
			}
		}
		.frame(width: Constants.screenWidth)
		.padding(.top, 40)
		.background(alignment: .bottom) {
			Ellipse()
				.fill(Color.baseWhite)
				.frame(width: 461, height: 115)
				.offset(y: 13)
		}
		.background(alignment: .top) {
			Rectangle()
				.fill(Color.main10P)
				.frame(width: Constants.screenWidth, height: 128)
		}
	}
	
	private var travelTypePart: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				Text(.travelType)
					.font(.body_bold)
					.padding(.leading, 16)
				Spacer()
			}
			.padding(.bottom, 16)
			
			HStack(spacing: 0) {
				if let travelType = appState.userInfo.travelType {
					Text("\(travelType)")
					
				} else {
					Text(.none)
				}
				
				Spacer()
			}
			.font(.title02_bold)
			.padding(.leading, 16)
			.padding(.bottom, 8)
			.foregroundStyle(Color.main)
			
			if !AppState.shared.userInfo.hashtags.isEmpty {
				HStack(spacing: 8) {
					// 해시태그는 항상 3개 고정
					ForEach(AppState.shared.userInfo.hashtags, id: \.self) { hashtag in
						Text("#\(hashtag)")
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
				.padding(.bottom, 8)
			}
			
			HStack(spacing: 0) {
				Button(action: {
					appState.showRegisterInduction = true
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
				.padding(.leading, 16)
				Spacer()
			}
			.padding(.top, 8)
		}
	}
	
	private var introducePart: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				Text(.introduction)
					.font(.body_bold)
					.padding(.leading, 16)
				Spacer()
			}
			.padding(.bottom, 8)
			HStack(spacing: 0) {
				Text("\(AppState.shared.userInfo.description)")
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
	}
	
	private var profileUpdateButton: some View {
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
enum MyPageViewType {
    case setting
    case update
}

#Preview {
    ProfileMainView()
}
