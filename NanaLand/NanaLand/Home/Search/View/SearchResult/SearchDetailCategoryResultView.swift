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
				Text({
					switch tab {
					case .all:
						return ""
					case .nature:
						return "\(searchVM.state.natureCategorySearchResult.totalElements)건"
					case .festival:
						return "\(searchVM.state.festivalCategorySearchResult.totalElements)건"
					case .market:
						return "\(searchVM.state.marketCategorySearchResult.totalElements)건"
					case .experience:
						return "\(searchVM.state.experienceCategorySearchResult.totalElements)건"
					case .nanaPick:
						return "\(searchVM.state.nanaCategorySearchResult.totalElements)건"
					}
				}() as String)
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
				
//				if searchVM.state.currentSearchTab == .experience || searchVM.state.currentSearchTab == .nanaPick {
				if false {
					VStack(spacing: 4) {
						Image(.airplane)
							.resizable()
							.frame(width: 100, height: 100)
						Text("해당 서비스 준비 중입니다.\n다음에 만나요!")
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
						Text("해당 검색 결과가 없습니다.")
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
								return [] as [Article]
							}
						}(),
								id: \.id
						) { article in
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
	
	
}

#Preview {
	SearchDetailCategoryResultView(searchVM: SearchViewModel(), tab: .experience, searchTerm: "제주시")
}
