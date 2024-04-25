//
//  FavoriteListView.swift
//  NanaLand
//
//  Created by 정현우 on 4/24/24.
//

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
							return Array(favoriteVM.state.allFavoriteArticles.data.enumerated())
						case .nature:
							return Array(favoriteVM.state.natureFavoriteArticles.data.enumerated())
						case .festival:
							return Array(favoriteVM.state.festivalFavoriteArticles.data.enumerated())
						case .market:
							return Array(favoriteVM.state.marketFavoriteArticles.data.enumerated())
						case .experience:
							return Array(favoriteVM.state.experienceFavoriteArticles.data.enumerated())
						case .nanaPick:
							return Array(favoriteVM.state.experienceFavoriteArticles.data.enumerated())
						}
					}(),
						id: \.element
					) { (index, article) in
						FavoriteArticleItem(index: index, tab: category, article: article)
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
		}
		.padding(.horizontal, 16)
		.padding(.top, 16)
		.task {
			if !isInit {
				await favoriteVM.action(.getFavoriteList(category: category))
				isInit = true
			} else {
				await favoriteVM.action(.refreshData(category: category))
			}
		}
    }
	
}

#Preview {
	FavoriteListView(category: .all)
		.environmentObject(FavoriteViewModel())
}
