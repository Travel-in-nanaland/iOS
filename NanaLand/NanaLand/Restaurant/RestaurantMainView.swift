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
            NanaNavigationBar(title: .restaurant, showBackButton: true)
                .frame(height: 56)
                .padding(.bottom, 24)
            
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
//    @State private var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
//    @State private var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
    
    @State private var APIKeyword = ""
    
    var translations: [String: String] {
        return [
            LocalizedKey.koreanFood.localized(for: localizationManager.language) : "KOREAN",
            LocalizedKey.chineseFood.localized(for: localizationManager.language) : "CHINESE",
            LocalizedKey.japaneseFood.localized(for: localizationManager.language) : "JAPANESE",
            LocalizedKey.westernFood.localized(for: localizationManager.language) : "WESTERN",
            LocalizedKey.snacks.localized(for: localizationManager.language) : "SNACK",
            LocalizedKey.southAmericanFood.localized(for: localizationManager.language) : "SOUTH_AMERICAN",
            LocalizedKey.southeastAsianFood.localized(for: localizationManager.language) : "SOUTHEAST_ASIAN",
            LocalizedKey.vegan.localized(for: localizationManager.language) : "VEGAN",
            LocalizedKey.halalFood.localized(for: localizationManager.language) : "HALAL",
            LocalizedKey.meatblackpork.localized(for: localizationManager.language) : "MEAT_BLACK_PORK",
            LocalizedKey.seaFood.localized(for: localizationManager.language) : "SEAFOOD",
            LocalizedKey.chickenBurger.localized(for: localizationManager.language) : "CHICKEN_BURGER",
            LocalizedKey.cafeDessert.localized(for: localizationManager.language) : "CAFE_DESSERT",
            LocalizedKey.pubRestaurant.localized(for: localizationManager.language) : "PUB_FOOD_PUB"
        ]
    }
    
    func generateAPIKeyword(from localizedKeyword: String) -> String {
        var apiKeyword = localizedKeyword
        for (localized, english) in translations {
            apiKeyword = apiKeyword.replacingOccurrences(of: localized, with: english)
        }
        return apiKeyword
    }
    
    var body: some View {
        
        VStack {
            HStack(spacing: 0) {
//                Text("\(viewModel.state.getRestaurantMainResponse.totalElements) " + .count)
//                    .padding(.leading, 16)
//                    .foregroundStyle(Color.gray1)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Button {
                        self.keywordModal = true
                    } label: {
                        HStack(spacing: 0) {
                            Text(keyword.split(separator: ",").count >= 3 ? "\(keyword.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : keyword.split(separator: ",").prefix(2).joined(separator: ","))
                                .font(.gothicNeo(.regular, size: 12))
                                .foregroundColor(Color.gray1)
                                .lineLimit(1)
                                .padding(.leading, 12)
                                .truncationMode(.tail)
                            
                            Image("icDownSmall")
                                .padding(.trailing, 12)
                        }
                        .frame(height: 40)
                    }
                    .foregroundStyle(Color.gray2)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.gray2, lineWidth: 1)
                    )
                    .padding(.trailing, 8)
                    .sheet(isPresented: $keywordModal) {
                        RestaurantKeywordView(keyword: $keyword, viewModel: viewModel, selectedKeyword: viewModel.state.selectedKeyword)
                            .presentationDetents([.height(Constants.screenWidth * (448 / 360))]) // 팝업 뷰 height 조절
                    }
                    
                    
                    Button {
                        self.locationModal = true
                    } label: {
                        HStack(spacing: 0) {
                            Text(viewModel.state.location.split(separator: ",").count >= 3 ? "\(viewModel.state.location.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : viewModel.state.location.split(separator: ",").prefix(2).joined(separator: ","))
                                .font(.gothicNeo(.regular, size: 12))
                                .foregroundColor(Color.gray1)
                                .lineLimit(1)
                                .padding(.leading, 12)
                                .truncationMode(.tail)
                            Image("icDownSmall")
                                .padding(.trailing, 12)
                        }
                        .frame(height: 40)
                    }
                    .foregroundStyle(Color.gray2)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .strokeBorder(Color.gray2, lineWidth: 1)
                    )
                    .padding(.trailing, 16)
                    .sheet(isPresented: $locationModal) { // 지역 필터링 뷰
                        LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: viewModel, experienceViewModel: ExperienceMainViewModel(), isModalShown: $locationModal, selectedLocation: viewModel.state.selectedLocation, startDate: "", endDate: "", title: LocalizedKey.restaurant.localized(for: localizationManager.language), keyword: keyword)
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
                                    AppState.shared.navigationPath.append(RestaurantViewType.detail(id: viewModel.state.getRestaurantMainResponse.data[index].id))
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
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getRestaurantMainResponse.data[index].id), category: .experience), index: index)
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
                                            
                                            Image("icStarFill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 11)
                                            
                                            Text(String(format: "%.1f", viewModel.state.getRestaurantMainResponse.data[index].ratingAvg))
                                                .font(.caption01_semibold)
                                                .foregroundStyle(Color.main)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                })
                                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height:  ((Constants.screenWidth - 40) / 2) * (164 / 160))
                            }
                            if viewModel.state.page < viewModel.state.getRestaurantMainResponse.totalElements / 12 {
                                ProgressView()
                                    .onAppear {
                                        print("\(viewModel.state.page)")
                                        Task {
                                            if viewModel.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                APIKeyword = keyword
                                                for (key, value) in translations {
                                                    APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                }
                                                await getRestaurantMainItem(keyword: keyword == LocalizedKey.type.localized(for: localizationManager.language) ? "" : APIKeyword, address: "", page: viewModel.state.page + 1, size: 12)
                                            } else {
                                                APIKeyword = keyword
                                                for (key, value) in translations {
                                                    APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                }
                                                await getRestaurantMainItem(keyword: keyword == LocalizedKey.type.localized(for: localizationManager.language) ? "" : APIKeyword, address: viewModel.state.apiLocation, page: viewModel.state.page + 1, size: 12)
                                            }
                                            
                                            viewModel.state.page += 1
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .onAppear {
                Task {
                    
                    if viewModel.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                        APIKeyword = generateAPIKeyword(from: keyword)
                        
                        if viewModel.state.getRestaurantMainResponse.totalElements == 0 {
                            await getRestaurantMainItem(keyword: keyword == LocalizedKey.type.localized(for: localizationManager.language) ? "" : APIKeyword, address: "", page: viewModel.state.page, size: 12)
                        }
                    } else {
                        APIKeyword = generateAPIKeyword(from: keyword)
                        
                        if viewModel.state.getRestaurantMainResponse.totalElements == 0{
                            await getRestaurantMainItem(keyword: keyword == LocalizedKey.type.localized(for: localizationManager.language) ? "" : APIKeyword, address: viewModel.state.apiLocation, page: viewModel.state.page, size: 12)
                        }
                    }
                    
                    isAPICalled = true
                }
            }
            .navigationDestination(for: RestaurantViewType.self) { viewType in
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

enum RestaurantViewType: Hashable {
    case detail(id: Int64)
}

#Preview {
    RestaurantMainView()
        .environmentObject(LocalizationManager())
}

