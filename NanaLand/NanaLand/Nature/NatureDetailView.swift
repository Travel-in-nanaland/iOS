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
    @State private var showScrollToTopButton = false
    @State private var thumbnailModal = false
    @State var selectedImageURL: String = ""// 선택된 이미지 URL
    var id: Int64
    
    var body: some View {
        ZStack {
            NavigationBar(title: LocalizedKey.nature.localized(for: localizationManager.language))
                .frame(height: 56)
            HStack(spacing: 0) {
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
                .padding(.trailing, 16)
            }
        }
    
        ZStack {
            ScrollViewReader { proxyReader in
                ScrollView {
                    VStack(spacing: 0) {
                        
                        
                        Button(action: {
                            selectedImageURL = viewModel.state.getNatureDetailResponse.images[0].originUrl!
                            thumbnailModal.toggle()
                        }, label: {
                            KFImage(URL(string: viewModel.state.getNatureDetailResponse.images[0].originUrl ?? ""))
                                .resizable()
                                .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                                .padding(.bottom, 24)
                        })
                        .fullScreenCover(isPresented: $thumbnailModal) {
                            PhotoModalView(imageUrl: $selectedImageURL)
                                .background(ClearBackgroundView())
                        }
                            
                        ZStack(alignment: .center) {
                            if !isOn { // 더보기 버튼이 안 눌렸을 때
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                                    .frame(width: Constants.screenWidth * (328/360), height: Constants.screenWidth * (220 / 360))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                    .overlay {
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getNatureDetailResponse.addressTag ?? "")
                                                    .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                                    .background(RoundedRectangle(cornerRadius: 30)
                                                        .foregroundStyle(Color.main10P)
                                                        .frame(height: Constants.screenWidth * (20 / 360))
                                                    )
                                                    .frame(height: Constants.screenWidth * (20 / 360))
                                                    .font(.gothicNeo(.regular, size: 12))
                                                    .foregroundStyle(Color.main)
                                                Spacer()
                                            }
                                            .padding(.bottom, Constants.screenWidth * (12 / 360))
                                            
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getNatureDetailResponse.title)
                                                    .font(.title02_bold)
                                                    .frame(height: Constants.screenWidth * (28 / 360))
                                                Spacer()
                                            }
                                            
                                            .padding(.bottom, 8)
                                            
                                            Text(viewModel.state.getNatureDetailResponse.content)
                                                .font(.body02)
                                                .lineLimit(4)
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
                                                            .font(.gothicNeo(.regular, size: 12))
                                                    }
                                                    
                                                }
                                                .padding(.bottom, Constants.screenWidth * (16 / 360))
                                            }
                                        }
                                        .padding(.leading, Constants.screenWidth * (16 / 360))
                                        .padding(.trailing, Constants.screenWidth * (16 / 360))
                                        .padding(.top, Constants.screenWidth * (16 / 360))
                                    }
                               
                                
                                
                            }
                            
                            if isOn { // 더 보기 눌렀을 때
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.addressTag ?? "")
                                            .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                .foregroundStyle(Color.main10P)
                                                .frame(height: Constants.screenWidth * (20 / 360))
                                            )
                                            .frame(height: Constants.screenWidth * (20 / 360))
                                            .font(.gothicNeo(.regular, size: 12))
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    .padding(.leading, Constants.screenWidth * (16 / 360))
                                    .padding(.bottom, Constants.screenWidth * (12 / 360))
                                    
                                    HStack(spacing: 0) {
                                        Text(viewModel.state.getNatureDetailResponse.title)
                                            .font(.title02_bold)
                                            .frame(height: Constants.screenWidth * (28 / 360))
                                        Spacer()
                                    }
                                    .padding(.leading, Constants.screenWidth * (16 / 360))
                                    
                                    .padding(.bottom, 8)
                                    
                                    Text(viewModel.state.getNatureDetailResponse.content)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.body02)
                                        .lineSpacing(10)
                                        .padding(.leading, Constants.screenWidth * (16 / 360))
                                        .padding(.trailing, Constants.screenWidth * (16 / 360))
                                    
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
                                        .padding(.trailing, Constants.screenWidth * (16 / 360))
                                        .padding(.bottom, Constants.screenWidth * (16 / 360))
                                    }
                                }
                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                .padding(.trailing, Constants.screenWidth * (16 / 360))
                                .padding(.top, Constants.screenWidth * (16 / 360))
                                .background(){
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                        .frame(width: Constants.screenWidth * (328 / 360)) // 뷰의 크기를 지정합니다.
                                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                }
                            }
                        }
                        
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
                            
                            if viewModel.state.getNatureDetailResponse.address != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailPin")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.address)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getNatureDetailResponse.address)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getNatureDetailResponse.contact != "" {
                                let sanitizedNumber = viewModel.state.getNatureDetailResponse.contact.replacingOccurrences(of: "-", with: "")
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailPhone")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                   
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.phoneNumber)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Link(destination: URL(string: "tel://\(sanitizedNumber)")!, label: {
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getNatureDetailResponse.contact)
                                                    .font(.gothicNeo(.regular, size: 12))
                                                    .padding(.trailing, 2)
                                                
                                                Image("icPhoneArrow")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: Constants.screenWidth * (8 / 360))
                                            }
                             
                                        })
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                            }
                            
                            if viewModel.state.getNatureDetailResponse.time != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailClock")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                 
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.time)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getNatureDetailResponse.time)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            if viewModel.state.getNatureDetailResponse.fee != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icFeeMain")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.fee)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getNatureDetailResponse.fee)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getNatureDetailResponse.details != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icInfo")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.detailInfo)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getNatureDetailResponse.details)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            if viewModel.state.getNatureDetailResponse.amenity != "" {
                                HStack(spacing: 10) {
                                    VStack(spacing: 0) {
                                        Image("icDetailFacility")
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                    
                                        Spacer()
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(.amenity)
                                            .font(.gothicNeo(.bold, size: 14))
                                        Text(viewModel.state.getNatureDetailResponse.amenity)
                                            .font(.gothicNeo(.regular, size: 12))
                                    }
                                    Spacer()
                                }
                                .frame(width: Constants.screenWidth - 40)
                            }
                            
                            Button {
                                AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getNatureDetailResponse.id, category: .nature))
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
                    }
                    .id("Scroll_To_Top")
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: geo.frame(in: .global).minY) { value in
                                    // 스크롤 위치 추적
                                    print("geometry scroll: \(value)")
                                    if value < 100 { // 스크롤이 일정 위치 이상 내려가면
                                        withAnimation {
                                            showScrollToTopButton = true
                                        }
                                    } else {
                                        withAnimation {
                                            showScrollToTopButton = false
                                        }
                                    }
                                }
                        }
                    )
                    
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
                            if showScrollToTopButton {
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
                    }
                )
            }
            .onAppear {
                Task {
                    await getNatureDetail(id: id)
                }
            }
            .toolbar(.hidden)
        }
    }
    
    func getNatureDetail(id: Int64) async {
        await viewModel.action(.getNatureDetailItem(id: id))
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
//    NatureDetailView()
//}
