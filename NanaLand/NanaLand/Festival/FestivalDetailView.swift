//
//  FestivalDetailView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI
import Kingfisher

struct FestivalDetailView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = FestivalDetailViewModel()
    @State private var isOn = false // 더보기 버튼 클릭 여부
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    
    var body: some View {
        NavigationBar(title: LocalizedKey.festival.localized(for: localizationManager.language))
            .frame(height: 56)
        ZStack {
            ScrollViewReader { proxyReader in
                ScrollView {
                    VStack(spacing: 0) {
                        KFImage(URL(string: viewModel.state.getFestivalDetailResponse.images[0].originUrl ?? ""))
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
                                            // 버튼을 누를 경우에 좋아요 API 호출
                                            Task {
                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getFestivalDetailResponse.id), category: .festival))
                                            }
                                        } label: {
                                            viewModel.state.getFestivalDetailResponse.favorite ? Image("icHeartFillMain") : Image("icFavoriteHeart")
                                        }
                                        
                                        ShareLink(item: DeepLinkManager.shared.makeLink(category: .festival, id: Int(viewModel.state.getFestivalDetailResponse.id)), label: {
                                            Image("icShare2")
                                        })
                                    }
                                    .padding(.trailing, 16)
                                    Spacer()
                                }
                                .padding(.top, 8)
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getFestivalDetailResponse.addressTag)
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
                                        Text(viewModel.state.getFestivalDetailResponse.title)
                                            .font(.gothicNeo(.bold, size: 20))
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                    
                                    .padding(.bottom, 8)
                                    
                                    Text(viewModel.state.getFestivalDetailResponse.content)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .frame(height: roundedHeight * (84 / 224))
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        .lineSpacing(10)
                                    
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
                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getFestivalDetailResponse.id), category: .festival))
                                            }
                                        } label: {
                                            viewModel.state.getFestivalDetailResponse.favorite ? Image("icHeartFillMain") : Image("icFavoriteHeart")
                                        }
                                        
                                        ShareLink(item: DeepLinkManager.shared.makeLink(category: .festival, id: Int(viewModel.state.getFestivalDetailResponse.id)), label: {
                                            Image("icShare2")
                                        })
                                    }
                                    .padding(.trailing, 16)
                                    Spacer()
                                }
                                .padding(.top, 8)
                                
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getFestivalDetailResponse.addressTag)
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
                                        Text(viewModel.state.getFestivalDetailResponse.title)
                                            .font(.gothicNeo(.bold, size: 20))
                                            .padding(.leading, 16)
                                        Spacer()
                                    }
                                    .padding(.bottom, 8)
                                    Text(viewModel.state.getFestivalDetailResponse.content)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        .lineSpacing(10)
                                    
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
                            if viewModel.state.getFestivalDetailResponse.address != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailPin")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.address)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.address)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getFestivalDetailResponse.contact != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailPhone")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.phoneNumber)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.contact)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                            }
                            
                            if viewModel.state.getFestivalDetailResponse.period != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailDate")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.duration)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.period)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getFestivalDetailResponse.time != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailClock")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.time)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.time)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getFestivalDetailResponse.fee != "" {
                                HStack(alignment: .top, spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailCharge")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.fee)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.fee)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            if viewModel.state.getFestivalDetailResponse.homepage != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailHomepage")
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.homepage)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getFestivalDetailResponse.homepage)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            Button {
                                AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getFestivalDetailResponse.id, category: .festival))
                            } label: {
                                Text(.proposeUpdateInfo)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 50.0)
                                            .foregroundStyle(Color.gray2)
                                            .frame(height: 40)
                                    )
                                    .foregroundStyle(Color.gray1)
                                    .font(.body02_bold)
                                    .padding(.top, 32)
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 32)
                        .id("Scroll_To_Top")
                    }
                }
                .navigationDestination(for: ArticleDetailViewType.self) { viewType in
                    switch viewType {
                    case let .reportInfo(id, category):
                        ReportInfoMainView(id: id, category: category)
                    }
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
            .onAppear {
                Task {
                    await getFestivalDetail(id: id, isSearch: false)
                }
            }
            .toolbar(.hidden)
        }
    }
    
    func getFestivalDetail(id: Int64, isSearch: Bool) async {
        await viewModel.action(.getFestivalDetailItem(id: id, isSearch: isSearch))
    }
    
    func getSafeArea() -> UIEdgeInsets {
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
//    FestivalDetailView()
//}
