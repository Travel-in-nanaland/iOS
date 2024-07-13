//
//  SearchDetailCategoryResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import SwiftUI

struct SearchDetailCategoryResultView: View {
    @ObservedObject var searchVM: SearchViewModel
    
    let tab: Category
    let searchTerm: String
    
    @State var isInit: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 17) {
                HStack(spacing: 0) {
                    Text({
                        switch tab {
                        case .all:
                            return ""
                        case .nature:
                            return "\(searchVM.state.natureCategorySearchResult.totalElements)"
                        case .festival:
                            return "\(searchVM.state.festivalCategorySearchResult.totalElements)"
                        case .market:
                            return "\(searchVM.state.marketCategorySearchResult.totalElements)"
                        case .experience:
                            return "\(searchVM.state.experienceCategorySearchResult.totalElements)"
                        case .nanaPick:
                            return "\(searchVM.state.nanaCategorySearchResult.totalElements)"
                        }
                    }() as String)
                    Text(.resultCount)
                }
                .font(.gothicNeo(.medium, size: 14))
                .foregroundStyle(Color.gray1)
                
                if searchVM.isSeaechresultIsEmpty() {
                    VStack(spacing: 15) {
                        Image(.orange)
                            .resizable()
                            .frame(width: 78, height: 78)
                        Text(.noResult)
                            .font(.body01)
                            .foregroundStyle(Color.gray1)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: Constants.screenWidth - 32)
                    .padding(.top, 150)
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())]
                    ) {
                        ForEach(getArticles(for: tab), id: \.id) { article in
                            NavigationLink(destination: destinationView(for: article)) {
                                ArticleItem(category: tab, article: article, onTapHeart: {
                                    if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
                                        AppState.shared.showRegisterInduction = true
                                        return
                                    }
                                    Task {
                                        await searchVM.action(.didTapHeartInSearchDetail(category: tab, article: article))
                                    }
                                })
                            }
                        }
                    }
                }
                if !searchVM.isLastPage(tab: tab) {
                    ProgressView()
                        .task {
                            await searchVM.action(.searchTerm(category: tab, term: searchTerm))
                        }
                        .frame(width: 20)
                        .position(x: Constants.screenWidth / 2 - 20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 30)
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
            Text("경험 상세 보기")
        case .nanaPick:
            NaNaPickDetailView(id: Int64(article.id))
        case .all:
            Text("테스트")
        }
    }

    func getArticles(for tab: Category) -> [Article] {
        switch tab {
        case .all:
            return []
        case .nature:
            return searchVM.state.natureCategorySearchResult.data
        case .festival:
            return searchVM.state.festivalCategorySearchResult.data
        case .market:
            return searchVM.state.marketCategorySearchResult.data
        case .experience:
            return searchVM.state.experienceCategorySearchResult.data
        case .nanaPick:
            return searchVM.state.nanaCategorySearchResult.data
        }
    }
}

#Preview {
    SearchDetailCategoryResultView(searchVM: SearchViewModel(), tab: .experience, searchTerm: "제주시")
}

