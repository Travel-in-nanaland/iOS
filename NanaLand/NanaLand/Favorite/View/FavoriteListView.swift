import SwiftUI

struct FavoriteListView: View {
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    let category: Category
    
    @State var isInit: Bool = false
    
    var body: some View {
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
                        case .experience:
                            return favoriteVM.state.experienceFavoriteArticles.data
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
                    }
                }
                if !favoriteVM.isLastPage(tab: category) {
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
    
    @ViewBuilder
        func destinationView(for article: Article) -> some View {
            switch article.category {
            case .nature:
                NatureDetailView(id: Int64(article.id))
            case .festival:
                FestivalDetailView(id: Int64(article.id))
            case .market:
                ShopDetailView(id: Int64(article.id))
            case .experience:
                ExperienceDetailView(id: Int64(article.id))
            case .nanaPick:
                NaNaPickDetailView(id: Int64(article.id))
            case .all:
                Text("test")
            case .restaurant:
                RestaurantDetailView(id: Int64(article.id))
            }
        }
}

#Preview {
    FavoriteListView(category: .all)
        .environmentObject(FavoriteViewModel())
}


