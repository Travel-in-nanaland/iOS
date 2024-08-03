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
                
                filterButton(text: $keyword, modal: $keywordModal, placeholder: LocalizedKey.type.localized(for: LocalizationManager().language))
                    .sheet(isPresented: $keywordModal) {
                        RestaurantKeywordView(keyword: $keyword)
                            .presentationDetents([.height(Constants.screenWidth * (448 / 360))]) // 팝업 뷰 height 조절
                    }
                
                filterButton(text: $location, modal: $locationModal, placeholder: LocalizedKey.allLocation.localized(for: LocalizationManager().language))
                    .sheet(isPresented: $locationModal) {
                        
                        LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: viewModel, experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: LocalizedKey.restaurant.localized(for: localizationManager.language))
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
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.state.getRestaurantMainResponse.data.indices, id: \.self) { index in
                                Button(action: {
                                    AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getRestaurantMainResponse.data[index].id))
                                }) {
                                    VStack(alignment: .leading) {
                                        ZStack {
                                            KFImage(URL(string: viewModel.state.getRestaurantMainResponse.data[index].firstImage.thumbnailUrl))
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
                                        
                                        Text(viewModel.state.getRestaurantMainResponse.data[index].title)
                                            .font(.gothicNeo(.bold, size: 14))
                                            .foregroundStyle(.black)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Text(viewModel.state.getRestaurantMainResponse.data[index].addressTag)
                                            .frame(width: 64, height: 20)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(Color.main10P)
                                            )
                                            .font(.gothicNeo(.regular, size: 12))
                                            .foregroundStyle(Color.main)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                    }
                }
            }
            .onAppear {
                Task {
                    await getRestaurantMainItem(keyword: "", address: "", page: 0, size: 12)
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
    
    @ViewBuilder
    private func filterButton(text: Binding<String>, modal: Binding<Bool>, placeholder: String) -> some View {
        Button {
            modal.wrappedValue = true
        } label: {
            HStack(spacing: 0) {
                Text(text.wrappedValue.split(separator: ",").count >= 3 ? "\(text.wrappedValue.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : text.wrappedValue.split(separator: ",").prefix(2).joined(separator: ","))
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

