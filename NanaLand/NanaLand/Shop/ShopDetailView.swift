//
//  ShopDetailView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI
import Kingfisher
struct ShopDetailView: View {
    @StateObject var viewModel = ShopDetailViewModel()
    @State private var isAPICalled = false
    @State private var isOn = false
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    @State private var shouldScrollToTop = false
    var id: Int64
    
    var body: some View {
        NavigationBar(title: "전통시장")
            .frame(height: 56)
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    KFImage(URL(string: viewModel.state.getShopDetailResponse.originUrl))
                        .resizable()
                        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                        .padding(.bottom, 24)
                    
                    ZStack(alignment: .center) {
                        if !isOn { // 더보기 버튼이 안 눌렸을 때
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity) // 뷰의 크기를 지정합니다.
                                              .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Spacer()
                                    Button {
                                        
                                    } label: {
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
                            
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text(viewModel.state.getShopDetailResponse.addressTag)
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
                                .padding(.bottom, 14)
                                HStack(spacing: 0) {
                                    Text(viewModel.state.getShopDetailResponse.title)
                                        .font(.gothicNeo(.bold, size: 20))
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                .padding(.bottom, 4)
                                Text(viewModel.state.getShopDetailResponse.content)
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
                       
                        // 더보기 버튼이 눌렸을 때
                        if isOn {
                            RoundedRectangle(cornerRadius: 30)
                                .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                .frame(width: Constants.screenWidth - 40) // 뷰의 크기를 지정합니다.
                                              .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Spacer()
                                    Button {
                                        
                                    } label: {
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
                            
                            VStack {
                                HStack(spacing: 0) {
                                    Text(viewModel.state.getShopDetailResponse.addressTag)
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
                                .padding(.bottom, 14)
                                HStack(spacing: 0) {
                                    Text(viewModel.state.getShopDetailResponse.title)
                                        .font(.gothicNeo(.bold, size: 20))
                                        .padding(.leading, 16)
                                    Spacer()
                                }
                                .padding(.bottom, 4)
                                Text(viewModel.state.getShopDetailResponse.content)
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
                        
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 10) {
                            VStack(spacing: 0) {
                                Image("icPin")
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("주소")
                                    .font(.gothicNeo(.bold, size: 14))
                                Text(viewModel.state.getShopDetailResponse.address)
                                    .font(.gothicNeo(.regular, size: 12))
                                
                            }
                            Spacer()
                           
                        }
                        .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
                     
                        HStack(spacing: 10) {
                            VStack(spacing: 0) {
                                Image("icPhone")
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("연락처")
                                    .font(.gothicNeo(.bold, size: 14))
                                Text(viewModel.state.getShopDetailResponse.contact)
                                    .font(.gothicNeo(.regular, size: 12))
                                
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
                                Text("이용시간")
                                    .font(.gothicNeo(.bold, size: 14))
                                Text(viewModel.state.getShopDetailResponse.time)
                                    .font(.gothicNeo(.regular, size: 12))
                                
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
                                Text("편의시설")
                                    .font(.gothicNeo(.bold, size: 14))
                                Text(viewModel.state.getShopDetailResponse.amenity)
                                    .font(.gothicNeo(.regular, size: 12))
                            }
                            Spacer()
                        }
                        .frame(width: Constants.screenWidth - 40)

                        HStack(spacing: 10) {
                            VStack(spacing: 0) {
                                Image("icHomepage")
                                Spacer()
                            }
                            
                            VStack(alignment: .leading, spacing: 0) {
                                Text("홈페이지")
                                    .font(.gothicNeo(.bold, size: 14))
                                Text(viewModel.state.getShopDetailResponse.homepage)
                                    .font(.gothicNeo(.regular, size: 12))
                                
                            }
                            Spacer()
                        }
                        .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * ( 42 / 358))
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
                .onAppear {
                    Task {
                        await getShopDetail(id: id)
                    }
                }
                .toolbar(.hidden)
            }
            HStack(spacing: 0) {
                Spacer()
                VStack(spacing: 0) {
                    Spacer()
                    ScrollToTopButton()
                    
                }
                .padding(.bottom, 50)
            }
            .padding(.trailing, 16)
            
            
        }
        
        
    }
    
    func getShopDetail(id: Int64) async {
        await viewModel.action(.getShopDetailItem(id: id))
    }
    
}

struct ScrollToTopButton: View {
    var body: some View {
        Button(action: {
            withAnimation {
              
            }
        }) {
            Image("icScrollToTop")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
}
//#Preview {
//    ShopDetailView()
//}
