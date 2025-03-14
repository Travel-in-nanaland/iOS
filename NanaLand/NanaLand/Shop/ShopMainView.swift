//
//  ShopMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ShopMainView: View {
    @EnvironmentObject var localizationMangaer: LocalizationManager
    var body: some View {
    
        VStack(spacing: 0) {
            NanaNavigationBar(title: .market, showBackButton: true)
                .frame(height: 56)
                .padding(.bottom, 10)
            
            ShopMainGridView()
            
            Spacer()
        }
        .toolbar(.hidden)
    }

}
// 정보 담는 grid 뷰
struct ShopMainGridView: View {
    @EnvironmentObject var localizationMangaer: LocalizationManager
    @StateObject var viewModel = ShopMainViewModel()
    @State private var locationModal = false
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var showScrollToTopButton = false
    @State private var isAPICalled = false
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
//                Text("\(viewModel.state.getShopMainResponse.totalElements)" + .count)
//                    .padding(.leading, 16)
//                    .foregroundStyle(Color.gray1)
                
                Spacer()
                
                Button {
                    self.locationModal = true
                } label: {
                    HStack(spacing: 0) {
                        Text(viewModel.state.location.split(separator: ",").count >= 2 ? "\(viewModel.state.location.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: localizationMangaer.language) + "\(viewModel.state.location.split(separator: ",").count - 1)" : viewModel.state.location.split(separator: ",").prefix(1).joined(separator: ","))
                            .font(.gothicNeo(.regular, size: 12))
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
                        .strokeBorder(Color.gray2, lineWidth: 1)
                )
                .padding(.trailing, 16)
                    .sheet(isPresented: $locationModal) {
                        LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: viewModel, restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), searchViewModel: SearchViewModel(), isModalShown: $locationModal, selectedLocation: viewModel.state.selectedLocation, startDate: "", endDate: "", title: LocalizedKey.market.localized(for: localizationMangaer.language))
                        .presentationDetents([.height(Constants.screenWidth * (58 / 36))])
                }
			}
			.padding(.bottom, 8)
            ScrollViewReader { reader in
                ScrollView {
                    if isAPICalled {
                        if viewModel.state.getShopMainResponse.data.count == 0 {
                            NoResultFilterView(keyword: .constant(""), location: $viewModel.state.location, yearMonthDay: .constant(nil), season: .constant(""))
                                .frame(height: 70)
                                .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                            
                        } else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                
                                ForEach((0...viewModel.state.getShopMainResponse.data.count-1), id: \.self) { index in
                                    Button(action: {
                                        AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getShopMainResponse.data[index].id))
                                    }, label: {
                                        VStack(alignment: .leading, spacing: 0) {
                                            ZStack {
                                                KFImage(URL(string: viewModel.state.getShopMainResponse.data[index].firstImage.thumbnailUrl))
                                                    .resizable()
                                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                VStack(spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        
                                                        Button {
                                                            Task {
                                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getShopMainResponse.data[index].id), category: .market), index: index)
                                                            }
                                                            
                                                        } label: {
                                                            viewModel.state.getShopMainResponse.data[index].favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                        }
                                                    }
                                                    .padding(.bottom, 8)
                                                }
                                                .padding(.trailing, 8)
                                            }
                                            
                                            
                                            Spacer()
                                            
                                            Text("\(viewModel.state.getShopMainResponse.data[index].title)")
                                                .font(.gothicNeo(.bold, size: 14))
                                                .foregroundStyle(.black)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            Text("\(viewModel.state.getShopMainResponse.data[index].addressTag)")
                                                .padding(.trailing, 12)
                                                .padding(.leading, 12)
                                                .frame(height: 20)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .foregroundStyle(Color.main10P)
                                                )
                                                .font(.gothicNeo(.regular, size: 12))
                                                .foregroundStyle(Color.main)
                                        }
                                    })
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((Constants.screenWidth - 40) / 2) * (164 / 160))
                                    .padding(.bottom, 16)
                                }
                                if viewModel.state.page < viewModel.state.getShopMainResponse.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            print("\(viewModel.state.page)")
                                            Task {
                                                if viewModel.state.location == LocalizedKey.allLocation.localized(for: localizationMangaer.language) {
                                                    await getShopMainItem(page: Int64(viewModel.state.page + 1), size: 12, filterName: "")
                                                } else {
                                                    await getShopMainItem(page: Int64(viewModel.state.page + 1), size: 12, filterName: viewModel.state.apiLocation)
                                                }
                                                viewModel.state.page += 1
                                            }
                                        }
                                }
                                
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
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
                    }
                
                }
                .overlay(
                    VStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 0) {
                            Spacer()
                            if showScrollToTopButton {
                                Button(action: {
                                    withAnimation(.default) {
                                        reader.scrollTo("Scroll_To_Top", anchor: .top)
                                    }
                                }, label: {
                                    Image("icScrollToTop")
                                })
                                .frame(width: 80, height: 80)
                                .padding(.trailing)
                                .padding(.bottom, getSafeArea().bottom == 0 ? 76 : 60)
                            }
                   
                        }
                    }.opacity(viewModel.state.getShopMainResponse.data.count != 0 ? 1 : 0) // 조건부 표시
                )
            }
		
        }
        .navigationDestination(for: ArticleViewType.self) { viewType in
            switch viewType {
            case let .detail(id):
                ShopDetailView(id: id)
            }
        }
        .onAppear {
            Task {
                if viewModel.state.location == LocalizedKey.allLocation.localized(for: localizationMangaer.language) {
                    if viewModel.state.getShopMainResponse.totalElements == 0 {
                        await getShopMainItem(page: 0, size:12, filterName:"")
                        isAPICalled = true
                    }
                    
                } else {
                    if viewModel.state.getShopMainResponse.totalElements == 0 {
                        await getShopMainItem(page: 0, size:12, filterName:viewModel.state.apiLocation)
                        isAPICalled = true
                    }
                }
            }
        }
        .onChange(of: viewModel.state.location) { newValue in
            if newValue == LocalizedKey.allLocation.localized(for: localizationMangaer.language) {
                viewModel.state.selectedLocation = []
                Task {
                    await getShopMainItem(page: 0, size: 12, filterName: "")
                }
            }
        }
    }
    
    func getShopMainItem(page: Int64, size: Int64, filterName: String) async {
        await viewModel.action(.getShopMainItem(page: page, size: size, filterName: filterName))
    }
    // 스크롤이 맨 아래에 도달 했는지 여부
    private var isAtBottom: Bool {
        let scrollView = UIScrollView.appearance()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        return offsetY > contentHeight - height
    }
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
    func getSafeArea() -> UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

#Preview {
    ShopMainView()
}

