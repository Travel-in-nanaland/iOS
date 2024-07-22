//
//  RestaurantDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import SwiftUI
import Kingfisher

struct RestaurantDetailView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = RestaurantDetailViewModel()
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    
    var body: some View {
        NavigationDeepLinkBar(title: LocalizedKey.restaurant.localized(for: localizationManager.language))
            .frame(height: 56)
        
        ZStack{
            ScrollView{
                VStack{
                    KFImage(URL(string: viewModel.state.getRestaurantDetailResponse.originUrl))
                        .resizable()
                        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                        .padding(.bottom, 24)
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                            .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity) // 뷰의 크기를 지정합니다.
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        
                        VStack {
                            HStack(spacing: 0) {
                                
                                Text(viewModel.state.getRestaurantDetailResponse.addressTag)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundStyle(Color.main10P)
                                            .frame(width: 64, height: 20)
                                    )
                                    .font(.gothicNeo(.regular, size: 12))
                                    .padding(.leading, 70)
                                    .foregroundStyle(Color.main)
                                Spacer()
                            }
                            .padding(.bottom, 14)
                            HStack(spacing: 0) {
                                Text(viewModel.state.getRestaurantDetailResponse.title)
                                    .font(.gothicNeo(.bold, size: 20))
                                    .padding(.leading, 16)
                                Spacer()
                            }
                            .padding(.bottom, 8)
                            Text(viewModel.state.getRestaurantDetailResponse.content)
                                .font(.gothicNeo(.regular, size: 16))
                                .frame(height: roundedHeight * (84 / 224))
                                .padding(.leading, 16)
                                .lineSpacing(10)
                                .padding(.trailing, 16)
                            
                            Spacer()
                        }
                        .padding(.top, 36)
                        
                    }
                    
                    VStack{
                        
                        HStack{
                            Text(.menu)
                                .font(.title02_bold)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 0))
                        
                        ForEach(viewModel.state.getRestaurantDetailResponse.menu, id: \.name) { menuItem in
                            RestaurantMenuView(title: menuItem.name, price: menuItem.price, imageUrl: menuItem.imageUrl)
                        }
                        
                    }
                    
                    VStack(spacing: 24) {
                        if !viewModel.state.getRestaurantDetailResponse.address.isEmpty {
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icDetailPin")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.address)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getRestaurantDetailResponse.address)
                                        .font(.body02)
                                    
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                        }
                        
                        if !viewModel.state.getRestaurantDetailResponse.contact.isEmpty {
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icDetailPhone")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.phoneNumber)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getRestaurantDetailResponse.contact)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                        }
                        
                        if !viewModel.state.getRestaurantDetailResponse.time.isEmpty {
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icDetailClock")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.time)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getRestaurantDetailResponse.time)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                        }
                        
                        if !viewModel.state.getRestaurantDetailResponse.amenity.isEmpty {
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icDetailFacility")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.amenity)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getRestaurantDetailResponse.amenity)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40)
                        }
                        
                        if !viewModel.state.getRestaurantDetailResponse.homepage.isEmpty {
                            HStack(spacing: 10) {
                                VStack(spacing: 0) {
                                    Image("icDetailHomepage")
                                    Spacer()
                                }
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(.homepage)
                                        .font(.gothicNeo(.bold, size: 14))
                                    Text(viewModel.state.getRestaurantDetailResponse.homepage)
                                        .font(.body02)
                                }
                                Spacer()
                            }
                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                            .padding(.bottom, 32)
                        }
                        
                        Button(action: {
                            AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getRestaurantDetailResponse.id, category: .restaurant))
                        }, label: {
                            Text(.proposeUpdateInfo)
                                .background(
                                    RoundedRectangle(cornerRadius: 12.0)
                                        .foregroundStyle(Color.gray2)
                                        .frame(width: 120, height: 40)
                                )
                                .foregroundStyle(Color.white)
                                .font(.body02_bold)
                                .padding(.bottom, 10)
                        })
                    }
                    .padding(.top, 32)
                }
            }
            .padding(.bottom, 100)
            
            VStack{
                Spacer()
                
                ZStack{
                    Rectangle()
                        .frame(height: 70)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 12) {
                        Spacer()
                        
                        Button {
                            Task {
                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getRestaurantDetailResponse.id), category: .restaurant))
                            }
                        } label: {
                            viewModel.state.getRestaurantDetailResponse.favorite ? Image("icHeartFillMain").renderingMode(.template).foregroundColor(.main) : Image("icFavoriteHeart").renderingMode(.template).foregroundColor(.main)
                        }
                        
                        Button(action: {
                            
                        }
                               , label: {
                            Rectangle()
                                .foregroundColor(.main)
                                .frame(maxWidth: .infinity, maxHeight: 40)
                                .cornerRadius(50)
                                .overlay(
                                    Text(.writeReview)
                                        .font(.body_bold)
                                        .foregroundColor(.white)
                                )
                        })
                    }
                    .padding(.trailing, 30)
                    .padding(.top, 15)
                }
            }
        }
        .toolbar(.hidden)
    }
    
    func getRestaurantDetail(id: Int64) async {
        await viewModel.action(.getRestaurantDetailItem(id: id))
    }
    
    func toggleFavorite(body: FavoriteToggleRequest) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body))
    }
}

#Preview {
    RestaurantDetailView()
        .environmentObject(LocalizationManager())
}
