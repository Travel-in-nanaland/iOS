import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    let category: Category
    
    @State var isInit: Bool = false
    
    var body: some View {
        let totalElements = getTotalElements(for: category)
        
        if totalElements == 0 {
            noFavoriteView()
                .task {
                    await fetchFavoriteList()
                }
        } else {
            favoriteListView()
        }
    }
    
    @ViewBuilder
    func destinationView(for article: Article) -> some View {
        switch article.category {
        case .nature:
            NatureDetailView(id: Int64(article.id))
        case .festival:
            FestivalDetailView(id: Int64(article.id))
        case .market:
            ShopDetailView(id: Int64(article.id))
        case .activity:
            ExperienceDetailView(id: Int64(article.id), experienceType: "Activity")
        case .cultureAndArts:
            ExperienceDetailView(id: Int64(article.id), experienceType: "CultureArts")
        case .nanaPick:
            NewNanaPickDetailView(id: Int64(article.id))
        case .all:
            Text("test")
        case .restaurant:
            RestaurantDetailView(id: Int64(article.id))
        }
    }
    /// ✅ 선택된 카테고리의 데이터 가져오기
    private func getArticles(for category: Category) -> [Article] {
        switch category {
        case .all:
            return favoriteVM.state.allFavoriteArticles.data
        case .nature:
            return favoriteVM.state.natureFavoriteArticles.data
        case .festival:
            return favoriteVM.state.festivalFavoriteArticles.data
        case .market:
            return favoriteVM.state.marketFavoriteArticles.data
        case .activity:
            return favoriteVM.state.activityFavoriteArticles.data
        case .cultureAndArts:
            return favoriteVM.state.cultureAndArtsFavoriteArticles.data
        case .nanaPick:
            return favoriteVM.state.nanaFavoriteArticles.data
        case .restaurant:
            return favoriteVM.state.restaurantFavoriteArticles.data
        }
    }
    
    
    /// ✅ 선택된 카테고리의 totalElements 가져오기
    private func getTotalElements(for category: Category) -> Int {
        switch category {
        case .all:
            return favoriteVM.state.allFavoriteArticles.totalElements
        case .nature:
            return favoriteVM.state.natureFavoriteArticles.totalElements
        case .festival:
            return favoriteVM.state.festivalFavoriteArticles.totalElements
        case .market:
            return favoriteVM.state.marketFavoriteArticles.totalElements
        case .activity:
            return favoriteVM.state.activityFavoriteArticles.totalElements
        case .cultureAndArts:
            return favoriteVM.state.cultureAndArtsFavoriteArticles.totalElements
        case .nanaPick:
            return favoriteVM.state.nanaFavoriteArticles.totalElements
        case .restaurant:
            return favoriteVM.state.restaurantFavoriteArticles.totalElements
        }
    }
    /// ✅ 찜한 리스트 UI
        @ViewBuilder
    private func favoriteListView() -> some View {
        ScrollView(.vertical) {
            VStack {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())]
                ) {
                    ForEach({
                        switch category {
                        case .all:
                            return favoriteVM.state.allFavoriteArticles.data
                        case .nature:
                            return favoriteVM.state.natureFavoriteArticles.data
                        case .festival:
                            return favoriteVM.state.festivalFavoriteArticles.data
                        case .market:
                            return favoriteVM.state.marketFavoriteArticles.data
                        case .activity:
                            return favoriteVM.state.activityFavoriteArticles.data
                        case .cultureAndArts:
                            return favoriteVM.state.cultureAndArtsFavoriteArticles.data
                        case .nanaPick:
                            return favoriteVM.state.nanaFavoriteArticles.data
                        case .restaurant:
                            return favoriteVM.state.restaurantFavoriteArticles.data
                        }
                    }() as [Article],
                            id: \.id
                    ) { article in
                        NavigationLink {
                            destinationView(for: article)
                        } label: {
                            ArticleItem(category: category, article: article, onTapHeart: {
                                Task {
                                    await favoriteVM.action(.deleteItemInFavoriteList(tab: category, article: article))
                                }
                            })
                        }
                        .onAppear {
                            print("Article Appeared: \(article)") // 나타날 때 정보 출력
                        }
                    }
                }
                if !favoriteVM.isLastPage(tab: category) && favoriteVM.state.isLoading{
                    ProgressView()
                        .task {
                            await favoriteVM.action(.getFavoriteList(category: category))
                        }
                        .frame(width: 20)
                        .position(x: Constants.screenWidth/2 - 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 0)
        .task {
            if !isInit {
                await favoriteVM.action(.getFavoriteList(category: category))
                isInit = true
            } else {
                await favoriteVM.action(.refreshData(category: category))
            }
        }
        
    }
    
    /// ✅ `찜한 컨텐츠 없음` UI
    @ViewBuilder
    private func noFavoriteView() -> some View {
        VStack{
            Image("icNoFavorite")
                .resizable()
                .scaledToFit()
                .frame(width: Constants.screenWidth * (80 / 360))
            
            Text(.noFavorite)
                .font(.body01)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray1)
                .padding(.top, Constants.screenWidth * (15 / 360))
                .padding(.bottom, Constants.screenWidth * (50 / 360))
        }
        
    }
    /// ✅ API 요청 함수 (중복 제거)
    private func fetchFavoriteList() async {
        if !isInit {
            await favoriteVM.action(.getFavoriteList(category: category))
            isInit = true
        } else {
            await favoriteVM.action(.refreshData(category: category))
        }
    }
    
}

#Preview {
    FavoriteListView(category: .all)
        .environmentObject(FavoriteViewModel())
}


