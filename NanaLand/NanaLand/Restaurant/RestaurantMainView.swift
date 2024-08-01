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
    @State private var keyword = LocalizedKey.keyword.localized(for: LocalizationManager().language)
    @State private var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
    @State private var APIFlag: Bool = true // 첫 onAppear시에만 호출
    
    var body: some View {
        
        HStack(spacing: 0) {
            Text("\(viewModel.state.getRestaurantMainResponse.totalElements)" + .count)
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            
            Spacer()
            
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
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 12)
                }
                .frame(height: 40)
            }
            .foregroundStyle(Color.gray1)
            .frame(maxHeight: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray1, lineWidth: 1)
                    
            )
            .padding(.trailing, 16)
//            .sheet(isPresented: $keywordModal) {
//                RestaurantKeywordView(viewModel: RestaurantMainViewModel(), keyword: $keyword, isModalShown: $keywordModal, title: "제주 맛집")
//                    .presentationDetents([.height(Constants.screenWidth * (63 / 50))])
//            }
            
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
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.trailing, 12)
                }
                .frame(height: 40)
            }
            .foregroundStyle(Color.gray1)
            .frame(maxHeight: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray1, lineWidth: 1)
                    
            )
            .padding(.trailing, 16)
            .sheet(isPresented: $locationModal) {
                LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(),restaurantModel: viewModel, experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: "제주 맛집")
                    .presentationDetents([.height(Constants.screenWidth * (63 / 36))])
            }

        }
        .padding(.bottom, 16)
        
        ScrollView {
            if isAPICalled {
                if viewModel.state.getRestaurantMainResponse.data.count == 0 {
                    NoResultView()
                        .frame(height: 70)
                        .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                }
                else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                            ForEach((0...viewModel.state.getRestaurantMainResponse.data.count-1), id: \.self) { index in
                                Button(action: {
                                    AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getRestaurantMainResponse.data[index].id))
                                }, label: {
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            KFImage(URL(string: viewModel.state.getRestaurantMainResponse.data[index].thumbnailUrl))
                                                .resizable()
                                                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack {
                                                HStack {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getRestaurantMainResponse.data[index].id), category: .restaurant), index: index)
                                                        }
                                                      
                                                    } label: {
                                                        viewModel.state.getRestaurantMainResponse.data[index].favorite ? Image("icHeartFillMain") : Image("icHeartDefault")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        
                                        Spacer()
                                        
                                        Text("\(viewModel.state.getRestaurantMainResponse.data[index].title)")
                                            .font(.gothicNeo(.bold, size: 14))
                                            .foregroundStyle(.black)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        Text("\(viewModel.state.getRestaurantMainResponse.data[index].addressTag)")
                                            .frame(width:64, height: 20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(Color.main10P)
                                            )
                                            .font(.gothicNeo(.regular, size: 12))
                                            .foregroundStyle(Color.main)
                                    }
                                })
                                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 196)
                                .padding(.leading, 0)
                            }
                        if viewModel.state.page < 40 {
                            ProgressView()
                                .onAppear {
                                    Task {
                                        if location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                            await getRestaurantMainItem(page: Int64(viewModel.state.page + 1), size: 12, filterName: "")
                                        } else {
                                            await getRestaurantMainItem(page: Int64(viewModel.state.page + 1), size: 12, filterName: location)
                                        }
                                        
                                        viewModel.state.page += 1
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                }
            }
            
        }
        .navigationDestination(for: ArticleViewType.self) { viewType in
            switch viewType {
            case let .detail(id):
                RestaurantDetailView(id: id)
            }
        }
    }
    
    func getRestaurantMainItem(page: Int64, size: Int64, filterName: String) async {
        await viewModel.action(.getRestaurantMainItem(page: page, size: size, filterName: filterName))
    }
    
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
}

#Preview {
    RestaurantMainView()
        .environmentObject(LocalizationManager())
}

