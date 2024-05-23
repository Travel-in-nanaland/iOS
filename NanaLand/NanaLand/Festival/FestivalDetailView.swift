//
//  FestivalDetailView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI
import Kingfisher

struct FestivalDetailView: View {
    @StateObject var viewModel = FestivalDetailViewModel()
    @State private var isOn = false // 더보기 버튼 클릭 여부
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    
    var body: some View {
        NavigationBar(title: "축제")
            .frame(height: 56)
        ZStack {
            ScrollViewReader { proxyReader in
                ScrollView {
                    VStack(spacing: 0) {
                        KFImage(URL(string: viewModel.state.getFestivalDetailResponse.originUrl))
                            .resizable()
                            .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                            .padding(.bottom, 24)
                        
                        ZStack(alignment: .center) {
                            if !isOn { // 더보기 버튼이 안 눌렸을 때
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white)
                                    .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity)
                                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Button {
                                            // 버튼을 누를 경우에 좋아요 API 호출
                                            Task {
                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getFestivalDetailResponse.id), category: .festival))
                                               
                                            }
                                        } label: {
                                            viewModel.state.getFestivalDetailResponse.favorite ? Image("icHeartFillMain") : Image("icHeart")
                                       
                                        }
                                        Button {
                                            
                                        } label: {
                                            Image("icShare2")
                                        }
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
                                    
                                    .padding(.bottom, 4)
                                    
                                    Text(viewModel.state.getFestivalDetailResponse.content)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .frame(height: roundedHeight * (84 / 224))
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    
                                    
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button {
                                                isOn.toggle()
                                            } label: {
                                                Text("더 보기")
                                                    .foregroundStyle(Color.gray1)
                                                    .font(.gothicNeo(.regular, size: 14))
                                            }
                                            
                                        }
                                        .padding(.bottom, 16)
                                    }
                                    .padding(.trailing, 16)
                                    
                                    
                                }
                                .padding(.top, 28)
                            }
                            
                            if isOn { // 더 보기 눌렀을 때
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                    .frame(maxWidth: Constants.screenWidth - 40) // 뷰의 크기를 지정합니다.
                                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Button {
                                            
                                        } label: {
                                            viewModel.state.getFestivalDetailResponse.favorite ? Image("icHeartFillMain") :
                                            Image("icHeart")
                                        }
                                        Button {
                                            
                                        } label: {
                                            Image("icShare2")
                                        }
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
                                    .padding(.bottom, 4)
                                    Text(viewModel.state.getFestivalDetailResponse.content)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.gothicNeo(.regular, size: 16))
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    
                                    
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button {
                                                isOn.toggle()
                                            } label: {
                                                Text("접기")
                                                    .foregroundStyle(Color.gray1)
                                                    .font(.gothicNeo(.regular, size: 14))
                                            }
                                            
                                        }
                                        .padding(.bottom, 16)
                                    }
                                    .padding(.trailing, 16)
                                    
                                    
                                }
                                .padding(.top, 28)
                                
                            }
                        }
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        
                        VStack(spacing: 16) {
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icPin")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("주소")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.address)
                                        .font(.gothicNeo(.regular, size: 12))
                                }
                                Spacer()
                                
                            }
                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icPhone")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("연락처")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.contact)
                                        .font(.gothicNeo(.regular, size: 12))
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("기간")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.period)
                                        .font(.gothicNeo(.regular, size: 12))
                                    
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                   
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("이용시간")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.time)
                                        .font(.gothicNeo(.regular, size: 12))
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icClock")
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("입장료")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.fee)
                                        .font(.gothicNeo(.regular, size: 12))
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icHomepage")
                                 
                                }
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("홈페이지")
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getFestivalDetailResponse.homepage)
                                        .font(.gothicNeo(.regular, size: 12))
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                            .padding(.bottom, 32)
                            
                            Button {
                                
                            } label: {
                                Text("정보 수정 제안")
                                    .background(
                                        RoundedRectangle(cornerRadius: 12.0)
                                            .foregroundStyle(Color.gray2)
                                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (53 / 358))
                                    )
                                    .foregroundStyle(Color.white)
                                    .font(.gothicNeo(.bold, size: 16))
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 24)
                    }
                    .id("Scroll_To_Top")
                    .onAppear {
                        Task {
                            await getFestivalDetail(id: id, isSearch: false)
       
                        }
                    }
                    .toolbar(.hidden)
                    .overlay(
                        GeometryReader { proxy -> Color in
                            let offset = proxy.frame(in: .global).minY
                            print(offset)
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
                                print("hello")
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
     
    }
    
    func getFestivalDetail(id: Int64, isSearch: Bool) async {
        await viewModel.action(.getFestivalDetailItem(id: id, isSearch: isSearch))
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
//    FestivalDetailView()
//}
