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
                        case .restaurant:
                            return "\(searchVM.state.nanaCategorySearchResult.totalElements)"
                        }
                    }() as String)
                    Text(.resultCount)
                }
                .font(.gothicNeo(.medium, size: 14))
                .foregroundStyle(Color.gray1)
                
                if searchVM.state.currentSearchTab == .experience || searchVM.state.currentSearchTab == .nanaPick || searchVM.state.currentSearchTab == .market || searchVM.state.currentSearchTab == .nature || searchVM.state.currentSearchTab == .festival {
                    if false {
                        VStack(spacing: 4) {
                            Image(.airplane)
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text(.beingPrepared)
                                .font(.body01)
                                .foregroundStyle(Color.gray1)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: Constants.screenWidth - 32)
                        .padding(.top, 150)
                        
                    } else if searchVM.isSeaechresultIsEmpty() {
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
                            ForEach({ () -> [Article] in
                                switch tab {
                                case .all:
                                    return [] as [Article]
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
                                case .restaurant:
                                    return searchVM.state.nanaCategorySearchResult.data
                                }
                            }(),
                            id: \.self) { article in
                                NavigationLink(destination: {
                                    destinationView(for: article)
                                }) {
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
                            if !searchVM.isLastPage(tab: tab) {
                                ProgressView()
                                    .task {
                                        await searchVM.action(.searchTerm(category: tab, term: searchTerm))
                                    }
                                    .frame(width: 20)
                                    .position(x: Constants.screenWidth/2 - 20)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 30)
        }
//        .navigationDestination(for: SearchDetailViewType.self) { viewType in
//            switch viewType {
//            case .detail:
//                NatureDetailView(id: 2)
//            }
//        }
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
    //            ExperienceDetailView(id: article.id)
            case .nanaPick:
                NaNaPickDetailView(id: Int64(article.id))
            case .all:
                Text("test")
            case .restaurant:
                Text("test")
            }
        }
}

enum SearchDetailViewType: Hashable {
    case detail
}

#Preview {
    SearchDetailCategoryResultView(searchVM: SearchViewModel(), tab: .experience, searchTerm: "제주시")
}
