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
	
    var body: some View {
		ScrollView(.vertical, showsIndicators: false) {
			VStack(alignment: .leading, spacing: 17) {
				Text("\(searchVM.state.searchAllCategoryResponse.festival.count)건")
					.font(.gothicNeo(.medium, size: 14))
					.foregroundStyle(Color.gray1)
				
				LazyVGrid(
					columns: [GridItem(.flexible()), GridItem(.flexible())]
				) {
					ForEach(searchVM.state.searchAllCategoryResponse.festival.data, id: \.id) { article in
						ArticleItem(article: article)
					}
				}
			}
		}
		.padding(.horizontal, 16)
		.padding(.top, 30)
    }
}

#Preview {
	SearchDetailCategoryResultView(tab: .experience)
}
