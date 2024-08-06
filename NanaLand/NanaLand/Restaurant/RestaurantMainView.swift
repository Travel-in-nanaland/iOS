//
//  RestaurantMainView.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import SwiftUI
import Kingfisher

struct RestaurantMainView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @State var locationTitle: String = "1"
    
    var body: some View {
        VStack{
            NavigationBar(title: LocalizedKey.restaurant.localized(for: localizationManager.language))
                .frame(height: 56)
                .padding(.bottom, 16)
            
            RestaurantMainGridView()
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

struct RestaurantMainGridView: View {
    @EnvironmentObject var localizationManager: LocalizationManager

    @StateObject var viewModel = RestaurantMainViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var isAPICalled = false
    @State private var filterTitle = "지역"
    @State private var keywordModal = false
    @State private var locationModal = false
    @State private var keyword = LocalizedKey.type.localized(for: LocalizationManager().language)
    @State private var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
                Text("\(viewModel.state.getRestaurantMainResponse.totalElements) " + .count)
                    .padding(.leading, 16)
                    .foregroundStyle(Color.gray1)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button {
                        self.keywordModal = true
                    } label: {
                        HStack(spacing: 0) {
                            Text(keyword.split(separator: ",").count >= 3 ? "\(keyword.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : keyword.split(separator: ",").prefix(2).joined(separator: ","))
                                .font(.gothicNeo(.medium, size: 12))
                                .lineLimit(1)
                                .padding(.leading, 12)
                                .truncationMode(.tail)
                            
                            Image("icDownSmall")
                                .padding(.trailing, 12)
                        }
                        .frame(height: 40)
                    }
                    .foregroundStyle(Color.gray1)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.gray1, lineWidth: 1)
                    )
                    .padding(.trailing, 8)
                    .sheet(isPresented: $keywordModal) {
                        RestaurantKeywordView(keyword: $keyword, address: location, viewModel: viewModel)
                            .presentationDetents([.height(Constants.screenWidth * (448 / 360))]) // 팝업 뷰 height 조절
                    }
                    
                    
                    Button {
                        self.locationModal = true
                    } label: {
                        HStack(spacing: 0) {
                            Text(location.split(separator: ",").count >= 3 ? "\(location.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : location.split(separator: ",").prefix(2).joined(separator: ","))
                                .font(.gothicNeo(.medium, size: 12))
                                .lineLimit(1)
                                .padding(.leading, 12)
                                .truncationMode(.tail)
                            Image("icDownSmall")
                                .padding(.trailing, 12)
                        }
                        .frame(height: 40)
                    }
                    .foregroundStyle(Color.gray1)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.gray1, lineWidth: 1)
                    )
                    .padding(.trailing, 16)
                    .sheet(isPresented: $locationModal) { // 지역 필터링 뷰
                        LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: viewModel, experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: "제주 맛집", keyword: keyword)
                            .presentationDetents([.height(Constants.screenWidth * (63 / 36))])
                    }
                }
            }
                .padding(.bottom, 16)
            
            ScrollView {
                if isAPICalled {
                    if viewModel.state.getRestaurantMainResponse.data.count == 0 {
                        NoResultView()
                            .frame(height: 70)
                            .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach((0...viewModel.state.getRestaurantMainResponse.data.count - 1), id: \.self) { index in
                                Button(action: {
                                    AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getRestaurantMainResponse.data[index].id))
                                }, label: {
                                    VStack(alignment: .leading, spacing: 0){
                                        ZStack {
                                            KFImage(URL(string: viewModel.state.getRestaurantMainResponse.data[index].firstImage.thumbnailUrl))
                                                .resizable()
                                                .frame(width: (Constants.screenWidth - 40) / 2, height: ((Constants.screenWidth - 40) / 2) * (12 / 16))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getRestaurantMainResponse.data[index].id), category: .restaurant), index: index)
                                                        }
                                                    } label: {
                                                        viewModel.state.getRestaurantMainResponse.data[index].favorite ? Image("icHeartFillMain").animation(nil) : Image("icHeartDefault").animation(nil)
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(viewModel.state.getRestaurantMainResponse.data[index].title)
                                            .lineLimit(1)
                                            .font(.body02_semibold)
                                            .padding(.bottom, 4)
                                        HStack(spacing: 0){
                                            Text(viewModel.state.getRestaurantMainResponse.data[index].addressTag)
                                                .font(.caption01)
                                                .foregroundStyle(Color.gray1)
                                            Spacer()
                                            Image("icRatingStar")
                                            
                                            // ratingAvg가 Int
                                            let rating = viewModel.state.getRestaurantMainResponse.data[index].ratingAvg

                                            // Double로 변환하여 소수점 한 자리로 변환
                                            let formattedRating = String(format: "%.1f", Double(rating))
                                            
                                            Text(formattedRating)
                                                .font(.caption01_semibold)
                                                .foregroundStyle(Color.main)
                                        }
                                        
                                        .padding(.trailing, 8)
                                    }
                                })
                                
                                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 196)
                                
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .onAppear {
                Task {
                    if location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                        await getRestaurantMainItem(keyword: "", address: "", page: 0, size: 12)
                    } else {
                        await getRestaurantMainItem(keyword: "", address: "", page: 0, size: 12)
                    }
                    isAPICalled = true
                    
                }
            }
            .navigationDestination(for: ArticleViewType.self) { viewType in
                switch viewType {
                case let .detail(id):
                    RestaurantDetailView(id: id)
                }
            }
        }
    }
    
    func getRestaurantMainItem(keyword: String, address: String, page: Int, size: Int) async {
        await viewModel.action(.getRestaurantMainItem(keyword: keyword, address: address, page: page, size: size))
    }
    
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
}

#Preview {
    RestaurantMainView()
        .environmentObject(LocalizationManager())
}

