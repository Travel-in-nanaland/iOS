//
//  NatureDetailView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI
import Kingfisher

struct NatureDetailView: View {
    @StateObject var viewModel = NatureDetailViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var isOn = false // 더보기 버튼 클릭 여부
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    
    var body: some View {
        NavigationBar(title: LocalizedKey.nature.localized(for: localizationManager.language))
            .frame(height: 56)
        ZStack {
            ScrollViewReader { proxyReader in
                ScrollView {
                    VStack(spacing: 0) {
                        KFImage(URL(string: viewModel.state.getNatureDetailResponse.originUrl))
                            .resizable()
                            .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                            .padding(.bottom, 24)
                        
                        ZStack(alignment: .center) {
                            if !isOn { // 더보기 버튼이 안 눌렸을 때
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                VStack(spacing: 0) {
                                    HStack(spacing: 12) {
                                        Spacer()
                                        Button {
                                            Task {
                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getNatureDetailResponse.id), category: .nature))
                                            }
                                        } label: {
                                            viewModel.state.getNatureDetailResponse.favorite ? Image("icHeartFillMain") : Image("icFavoriteHeart")
                                        }
										
										ShareLink(item: DeepLinkManager.shared.makeLink(category: .nature, id: Int(viewModel.state.getNatureDetailResponse.id)), label: {
											Image("icShare2")
										})
                                    }
                                    .padding(.trailing, 16)
                                    Spacer()
                                }
                                .padding(.top, 8)
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.addressTag)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(Color.main10P)
                                                    .frame(width: 64, height: 20)
                                            )
                                            .font(.gothicNeo(.regular, size: 12))
                                            .padding(.leading, 32)
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    .padding(.bottom, 12)
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.title)
                                            .font(.gothicNeo(.bold, size: 20))
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                    
                                    .padding(.bottom, 8)
                                    
                                    Text(viewModel.state.getNatureDetailResponse.content)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .frame(height: roundedHeight * (84 / 224))
                                        .padding(.leading, 16)
                                        .lineSpacing(10)
                                        .padding(.trailing, 16)
                                    
                                    
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button {
                                                isOn.toggle()
                                            } label: {
                                                Text(.unfoldView)
                                                    .foregroundStyle(Color.gray1)
                                                    .font(.gothicNeo(.regular, size: 14))
                                            }
                                            
                                        }
                                        .padding(.bottom, 16)
                                    }
                                    .padding(.trailing, 16)
                                    
                                    
                                }
                                .padding(.top, 36)
                            }
                            
                            if isOn { // 더 보기 눌렀을 때
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                    .frame(maxWidth: Constants.screenWidth - 40) // 뷰의 크기를 지정합니다.
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                VStack(spacing: 0) {
                                    HStack(spacing: 12) {
                                        Spacer()
                                        Button {
                                            Task {
                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getNatureDetailResponse.id), category: .nature))
                                            }
                                        } label: {
                                            viewModel.state.getNatureDetailResponse.favorite ? Image("icHeartFillMain") : Image("icFavoriteHeart")
                                        }
										
										ShareLink(item: DeepLinkManager.shared.makeLink(category: .nature, id: Int(viewModel.state.getNatureDetailResponse.id)), label: {
											Image("icShare2")
										})
                                    }
                                    .padding(.trailing, 16)
                                    Spacer()
                                }
                                .padding(.top, 8)
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.addressTag)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(Color.main10P)
                                                    .frame(width: 64, height: 20)
                                            )
                                            .font(.gothicNeo(.regular, size: 12))
                                            .padding(.leading, 32)
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    .padding(.bottom, 12)
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.title)
                                            .font(.gothicNeo(.bold, size: 20))
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                    .padding(.bottom, 8)
                                    Text(viewModel.state.getNatureDetailResponse.content)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .lineSpacing(10)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    
                                    
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button {
                                                isOn.toggle()
                                            } label: {
                                                Text(.foldView)
                                                    .foregroundStyle(Color.gray1)
                                                    .font(.gothicNeo(.regular, size: 14))
                                            }
                                            
                                        }
                                        .padding(.bottom, 16)
                                    }
                                    .padding(.trailing, 16)
                                }
                                .padding(.top, 36)
                                
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        VStack(spacing: 24) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.main10P)
                                    .frame(maxWidth: Constants.screenWidth - 40)
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Image("icNoticeMain")
                                        Text(.introduce)
                                            .font(.gothicNeo(.bold, size: 14))
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    .padding(.leading, 32)
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 4)
                                    Text(viewModel.state.getNatureDetailResponse.intro)
                                        .padding(.leading, 32)
                                        .padding(.trailing, 32)
                                        .padding(.bottom, 16)
                                        .font(.gothicNeo(.regular, size: 14))
                                    Spacer()
                                }
                                .padding(.top, 24)
                                
                            }
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icPin")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.address)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.address)
                                        .font(.body02)
                                }
                                Spacer()
                                
                            }
                            .frame(width: Constants.screenWidth - 40)
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icPhone")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.phoneNumber)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.contact)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.time)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.time)
                                        .font(.body02)
                                    
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.fee)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.fee)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.detailInfo)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.details)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icFacility")
                                    Spacer()
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.amenity)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getNatureDetailResponse.amenity)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            .padding(.bottom, 32)
                            
                            Button {
                                AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getNatureDetailResponse.id, category: .nature))
                            } label: {
                                Text(.proposeUpdateInfo)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12.0)
                                            .foregroundStyle(Color.gray2)
                                            .frame(width: 120, height: 40)
                                    )
                                    .foregroundStyle(Color.white)
                                    .font(.body02_bold)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 32)
                    }
                    .id("Scroll_To_Top")
                    .onAppear {
                        Task {
                            await getNatureDetail(id: id)
       
                        }
                    }
                    .toolbar(.hidden)
                    .overlay(
                        GeometryReader { proxy -> Color in
                            let offset = proxy.frame(in: .global).minY
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                        
                    )
                }
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                      
                                  // 10. withAnimation 과함께 함수 작성
                                  withAnimation(.default) {
                                      // ScrollViewReader의 proxyReader을 넣어줌
                                      proxyReader.scrollTo("Scroll_To_Top", anchor: .top)
                                  }
                                  
                              }, label: {
                                   Image("icScrollToTop")
                                  
                              })
                            .frame(width: 80, height: 80)
                            .padding(.trailing)
                            .padding(.bottom, getSafeArea().bottom == 0 ? 15 : 0)
                        }
                    }
                )
            }

        }
		.navigationDestination(for: ArticleDetailViewType.self) { viewType in
			switch viewType {
			case let .reportInfo(id, category):
				ReportInfoMainView(id: id, category: category)
			}
		}
     
    }
    
    func getNatureDetail(id: Int64) async {
        await viewModel.action(.getNatureDetailItem(id: id))
    }
    
    func getSafeArea() ->UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func toggleFavorite(body: FavoriteToggleRequest) async {
		if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
			AppState.shared.showRegisterInduction = true
			return
		}
        await viewModel.action(.toggleFavorite(body: body))
    }
}

//#Preview {
//    NatureDetailView()
//}
