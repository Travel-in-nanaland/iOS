//
//  SearchDetailCategoryResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import SwiftUI

struct SearchDetailCategoryResultView: View {
	@EnvironmentObject var searchVM: SearchViewModel
	
	let tab: Category
	let searchTerm: String
	
	@State var isInit: Bool = false
	
    var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			VStack(alignment: .leading, spacing: 17) {
				Text({
					switch tab {
					case .all:
						return ""
					case .nature:
						return "\(searchVM.state.natureCategorySearchResult.count)건"
					case .festival:
						return "\(searchVM.state.festivalCategorySearchResult.count)건"
					case .market:
						return "\(searchVM.state.marketCategorySearchResult.count)건"
					case .experience:
						return "\(searchVM.state.experienceCategorySearchResult.count)건"
					case .nanaPick:
						return ""
					}
				}())
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
				
				LazyVGrid(
					columns: [GridItem(.flexible()), GridItem(.flexible())]
				) {
					ForEach({
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
							return [] as [Article]
						}
					}(),
						id: \.id
					) { article in
						ArticleItem(article: article)
					}
					
					if !isLastPage() {
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
		.padding(.horizontal, 16)
		.padding(.top, 30)
		.task {
			if !isInit {
				await searchVM.action(.searchTerm(category: tab, term: searchTerm))
				isInit = true
			}
		}
    }
	
	private func isLastPage() -> Bool {
		switch tab {
		case .all:
			return false
		case .nature:
			return searchVM.state.natureCategorySearchResult.count == searchVM.state.natureCategorySearchResult.data.count
		case .festival:
			return searchVM.state.festivalCategorySearchResult.count == searchVM.state.festivalCategorySearchResult.data.count
		case .market:
			return searchVM.state.marketCategorySearchResult.count == searchVM.state.marketCategorySearchResult.data.count
		case .experience:
			return searchVM.state.experienceCategorySearchResult.count == searchVM.state.experienceCategorySearchResult.data.count
		case .nanaPick:
			return false
		}
	}
}

#Preview {
	SearchDetailCategoryResultView(tab: .experience, searchTerm: "제주시")
}
