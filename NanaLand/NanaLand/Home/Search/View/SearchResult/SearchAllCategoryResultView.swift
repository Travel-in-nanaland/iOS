//
//  SearchAllCategoryResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import SwiftUI

struct SearchAllCategoryResultView: View {
    @ObservedObject var searchVM: SearchViewModel

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .nature,
                count: searchVM.state.allCategorySearchResult.nature.totalElements,
                articles: searchVM.state.allCategorySearchResult.nature.data
            )

            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .festival,
                count: searchVM.state.allCategorySearchResult.festival.totalElements,
                articles: searchVM.state.allCategorySearchResult.festival.data
            )

            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .market,
                count: searchVM.state.allCategorySearchResult.market.totalElements,
                articles: searchVM.state.allCategorySearchResult.market.data
            )

            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .experience,
                count: searchVM.state.allCategorySearchResult.experience.totalElements,
                articles: searchVM.state.allCategorySearchResult.experience.data
            )
            
            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .restaurant,
                count: searchVM.state.allCategorySearchResult.restaurant.totalElements,
                articles: searchVM.state.allCategorySearchResult.restaurant.data
            )

            SearchAllCategoryItem(
                searchVM: searchVM,
                category: .nanaPick,
                count: searchVM.state.allCategorySearchResult.nana.totalElements,
                articles: searchVM.state.allCategorySearchResult.nana.data
            )
            
            

            Spacer()
                .frame(height: 100)
        }
    }
}

struct SearchAllCategoryItem: View {
    @EnvironmentObject var manager: LocalizationManager
    @ObservedObject var searchVM: SearchViewModel

    let category: Category
    let count: Int
    let articles: [Article]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(category.localizedName)
                    .font(.gothicNeo(.bold, size: 18))
                    .foregroundStyle(Color.baseBlack)

                HStack(spacing: 0) {
                    Text("\(count)")
                    Text(.resultCount)
                }
                .font(.gothicNeo(.medium, size: 14))
                .foregroundStyle(Color.gray1)

                Spacer()

                Button(action: {
                    withAnimation {
                        searchVM.state.currentSearchTab = category
                    }
                }, label: {
                    Image(.icRight)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            .padding(.bottom, 8)

            Rectangle()
                .fill(Color.gray2)
                .frame(height: 1)
                .padding(.bottom, 16)

            if !articles.isEmpty {
                HStack(spacing: 8) {
                    NavigationLink(destination: {
                        destinationView(for: articles[0])
                    }) {
                        ArticleItem(category: category, article: articles[0], onTapHeart: {
                            if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
                                AppState.shared.showRegisterInduction = true
                                return
                            }
                            Task {
                                await searchVM.action(.didTapHeartInSearchAll(tab: category, article: articles[0]))
                            }
                        })
                    }
                    if articles.count >= 2 {
                        NavigationLink(destination: {
                            destinationView(for: articles[1])
                        }) {
                            ArticleItem(category: category, article: articles[1], onTapHeart: {
                                if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
                                    AppState.shared.showRegisterInduction = true
                                    return
                                }
                                Task {
                                    await searchVM.action(.didTapHeartInSearchAll(tab: category, article: articles[1]))
                                }
                            })
                        }
                    } else {
                        Spacer()
                    }
                }
                .padding(.bottom, 12)
            } else {
                VStack(spacing: 9.3) {
                    Image(.orange)
                        .resizable()
                        .frame(width: 37.5, height: 37.5)

                    Text(.noResult)
                        .font(.gothicNeo(.medium, size: 14))
                        .foregroundStyle(Color.gray1)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 48)
                .padding(.bottom, 58)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
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
            Text("Experience Detail View")
        case .nanaPick:
            NaNaPickDetailView(id: Int64(article.id))
        case .all:
            Text("test")
        case .restaurant:
            Text("test")
        }
    }
}

enum SearchViewType: Hashable {
    case natureDetail(id: Int)
    case shopDetail(id: Int)
    case festivalDetail(id: Int)
}

#Preview {
    SearchAllCategoryResultView(searchVM: SearchViewModel())
}
