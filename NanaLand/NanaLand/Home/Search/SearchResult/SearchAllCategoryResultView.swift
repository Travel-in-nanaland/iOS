//
//  SearchAllCategoryResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import SwiftUI

struct SearchAllCategoryResultView: View {
	@EnvironmentObject var searchVM: SearchViewModel
	
	var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			SearchAllCategoryItem(
				category: .nature,
				count: searchVM.state.searchAllCategoryResponse.nature.count,
				articles: searchVM.state.searchAllCategoryResponse.nature.data
			)
			
			SearchAllCategoryItem(
				category: .festival,
				count: searchVM.state.searchAllCategoryResponse.festival.count,
				articles: searchVM.state.searchAllCategoryResponse.festival.data
			)
			
			SearchAllCategoryItem(
				category: .market,
				count: searchVM.state.searchAllCategoryResponse.market.count,
				articles: searchVM.state.searchAllCategoryResponse.market.data
			)
			
			SearchAllCategoryItem(
				category: .experience,
				count: searchVM.state.searchAllCategoryResponse.experience.count,
				articles: searchVM.state.searchAllCategoryResponse.experience.data
			)
			
			
			Spacer()
				.frame(height: 100)
		}
	}
}

struct SearchAllCategoryItem: View {
	@EnvironmentObject var searchVM: SearchViewModel
	
	let category: Category
	let count: Int
	let articles: [Article]
	
	var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 8) {
				Text(category.name)
					.font(.gothicNeo(.bold, size: 18))
					.foregroundStyle(Color.baseBlack)
				
				Text("\(count)건")
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
					ArticleItem(article: articles[0])
					
					if articles.count >= 2 {
						ArticleItem(article: articles[1])
						
					} else {
						Spacer()
					}
				}
				.padding(.bottom, 8)

			} else {
				Text(String(localized: "noResult"))
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
					.padding(.top, 48)
					.padding(.bottom, 54)
				
			}
		}
		.padding(.horizontal, 16)
		.padding(.top, 24)
	}
}

#Preview {
    SearchAllCategoryResultView()
}
