//
//  ExperienceDetailView.swift
//  NanaLand
//
//  Created by juni on 7/19/24.
//

import SwiftUI
import Kingfisher

struct ExperienceDetailView: View {
    @StateObject var viewModel = ExperienceDetailViewModel()
    @State private var isOn = false // 더보기 버튼 클릭 여부
    @State private var isAPICall = false
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    
    var body: some View {
        VStack {
            NanaNavigationBar(title: .experience, showBackButton: true)
                .frame(height: 56)
            ZStack {
                ScrollViewReader { proxyReader in
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            if isAPICall {
                                KFImage(URL(string: viewModel.state.getExperienceDetailResponse.images![0].originUrl!))
                                    .resizable()
                                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                                    .padding(.bottom, 24)
                                
                                ZStack(alignment: .center) {
                                    if !isOn {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.white)
                                            .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                        
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getExperienceDetailResponse.addressTag ?? "")
                                                    .background(RoundedRectangle(cornerRadius: 30)
                                                        .foregroundStyle(Color.main10P)
                                                        .frame(width: 64, height: 20)
                                                        
                                                    )
                                                    .font(.gothicNeo(.regular, size: 12))
                                                    .padding(.leading, 32)
                                                    .foregroundStyle(Color.main)
                                                ForEach(0...viewModel.state.getExperienceDetailResponse.keywords!.count - 1, id: \.self) { index in
                                                    Text(viewModel.state.getExperienceDetailResponse.keywords![index])
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                            .foregroundStyle(Color.main10P)
                                                            .frame(width: 64, height: 20)
                                                        )
                                                        .font(.gothicNeo(.regular, size: 12))
                                                        .padding(.leading, 32)
                                                        .foregroundStyle(Color.main)
                                                }
                                                Spacer()
                                                    
                                            }
                                            .padding(.bottom, 12)
                                            
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getExperienceDetailResponse.title!)
                                                    .font(.gothicNeo(.bold, size: 20))
                                                    .padding(.leading, 16)
                                                Spacer()
                                            }
                                            .padding(.bottom, 8)
                                            
                                            Text(viewModel.state.getExperienceDetailResponse.content ?? "")
                                                .font(.body01)
                                                .frame(height: roundedHeight * (84 / 224))
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                                .lineSpacing(10)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Spacer()
                                                VStack(spacing: 0) {
                                                    Button {
                                                        isOn.toggle()
                                                    } label: {
                                                        Text(.unfoldView)
                                                            .foregroundStyle(Color.gray1)
                                                            .font(.caption01)
                                                        
                                                    }
                                                }
                                                .padding(.bottom, 17)
                                            }
                                            .padding(.trailing, 16)
                                        }
                                        .padding(.top, 36)
                                    }
                                    
                                    if isOn {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                            .frame(maxWidth: Constants.screenWidth - 40) // 뷰의 크기를 지정합니다.
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getExperienceDetailResponse.addressTag ?? "")
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.main10P)
                                                            .frame(width: 64, height: 20)
                                                    )
                                                    .font(.caption01)
                                                    .padding(.leading, 32)
                                                    .foregroundStyle(Color.main)
                                                ForEach(0...viewModel.state.getExperienceDetailResponse.keywords!.count - 1, id: \.self) { index in
                                                    Text(viewModel.state.getExperienceDetailResponse.keywords![index])
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                            .foregroundStyle(Color.main10P)
                                                            .frame(width: 64, height: 20)
                                                        )
                                                        .font(.gothicNeo(.regular, size: 12))
                                                        .padding(.leading, 32)
                                                        .foregroundStyle(Color.main)
                                                }
                                                Spacer()
                                            }
                                            .padding(.bottom, 12)
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getExperienceDetailResponse.title ?? "")
                                                    .font(.title01_bold)
                                                    .padding(.leading, 16)
                                                Spacer()
                                            }
                                            .padding(.bottom, 8)
                                            Text(viewModel.state.getExperienceDetailResponse.content ?? "")
                                                .fixedSize(horizontal: false, vertical: true)
                                                .font(.body01)
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                                .lineSpacing(10)
                                            Spacer()
                                            HStack(spacing: 0) {
                                                Spacer()
                                                VStack(spacing: 0) {
                                                    Button {
                                                        isOn.toggle()
                                                    } label: {
                                                        Text(.foldView)
                                                            .foregroundStyle(Color.gray1)
                                                            .font(.caption01)
                                                    }
                                                }
                                                .padding(.bottom, 16)
                                            }
                                            .padding(.trailing, 16)
                                        }
                                        .padding(.top, 30)
                                    }
                                }
                                .padding(.leading, 20)
                                .padding(.trailing, 20)
                                
                                VStack(spacing: 24) {
                                    HStack(spacing: 10) {
                                        VStack(spacing: 0) {
                                            Image("icPin")
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.main)
                                        }
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(.address)
                                                .font(.body02_bold)
                                            Text(viewModel.state.getExperienceDetailResponse.address ?? "")
                                                .font(.body02)
                                        }
                                        Spacer()
                                    }
                                    .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                                    HStack(spacing: 10) {
                                        VStack(spacing: 0) {
                                            Image("icPhone")
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.main)
                                        }
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(.phoneNumber)
                                                .font(.body02_bold)
                                            Text(viewModel.state.getExperienceDetailResponse.contact ?? "")
                                                .font(.body02)
                                        }
                                        Spacer()
                                    }
                                    .frame(width: Constants.screenWidth - 40 , height: (Constants.screenWidth - 40) * (42 / 358))
                                    
                                    HStack(spacing: 10) {
                                        VStack(spacing: 0) {
                                            Image("icClock")
                                                .renderingMode(.template)
                                                .foregroundStyle(Color.main)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(.time)
                                                .font(.body02_bold)
                                            Text(viewModel.state.getExperienceDetailResponse.time ?? "")
                                                .font(.body02)
                                        }
                                        Spacer()
                                    }
                                    .frame(width: Constants.screenWidth - 40)
                                    
                                    HStack(spacing: 10) {
                                        VStack(spacing: 0) {
                                            Image("icFeeMain")
                                        }
                                        VStack(alignment: .leading, spacing: 0) {
                                            Text(.fee)
                                                .font(.body02_bold)
                                            
                                        }
                                        Spacer()
                                    }
                                    .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                                    .padding(.bottom, 32)
                                    
                                    Button {
                                        print(viewModel.state.getExperienceDetailResponse.id!)
                                        print(AppState.shared.navigationPath.count)
                                        AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getExperienceDetailResponse.id!, category: .experience))
                                    } label: {
                                        Text(.proposeUpdateInfo)
                                            .background(
                                                RoundedRectangle(cornerRadius: 50.0)
                                                    .foregroundStyle(Color.gray2)
                                                    .frame(width: 120, height: 40)
                                            )
                                            .foregroundStyle(Color.white)
                                            .font(.body02_bold)
                                            .padding(.bottom, 10)
                                    }
                                }
                                .padding(.bottom, 66)
                                .padding(.top, 32)
                            }
                            
                        }
                        .id("Scroll_To_Top")
                        
                        .onAppear {
                            Task {
                                await getExperienceDetail(id: id, isSearch: false)
                                isAPICall = true // 이미지 불러오는 데 시간이 걸림
                            }
                        }
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
                                .padding(.bottom, getSafeArea().bottom == 0 ? 76 : 60)
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
                VStack(spacing: 0) {
                    Spacer()
                    HStack(spacing: 0) {
                        Button {
                            Task {
                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getExperienceDetailResponse.id!), category: .experience))
                            }
                        } label: {
                            viewModel.state.getExperienceDetailResponse.favorite! ?
                            Image("icHeartFillMain")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(Color.main)
                                .padding(.leading, 16) : Image("icFavoriteHeart")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(Color.main)
                                .padding(.leading, 16)
                        }

                      
                        Spacer()
                        Button {
                            // Todo - 리뷰 작성
                        } label: {
                            Text("리뷰 작성하기")
                                .padding(.leading, (Constants.screenWidth) * (96 / 360))
                                .padding(.trailing, (Constants.screenWidth) * (96 / 360))
                                .font(.body_bold)
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.main).frame(width: Constants.screenWidth * (28 / 36), height: 40))
                              
                                
                        }
                        .padding(.trailing, 16)
                        

                    }
                    .frame(width: Constants.screenWidth, height: 56)
                    .background(Color.white)
                }
               
            }
        }
        .toolbar(.hidden)
    }
    
    func getExperienceDetail(id: Int64, isSearch: Bool) async {
        await viewModel.action(.getExperienceDetailItem(id: id, isSearch: isSearch))
        
    }
    
    func toggleFavorite(body: FavoriteToggleRequest) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body))
    }
    
    func getSafeArea() ->UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

#Preview {
    ExperienceDetailView(id: 1)
}
