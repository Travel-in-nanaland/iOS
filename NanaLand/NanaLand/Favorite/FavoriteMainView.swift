//
//  FavoriteMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI

struct FavoriteMainView: View {
	@ObservedObject var favoriteVM = FavoriteViewModel()
	
	@State var currentTab: Category = .all
	let tabs: [Category] = Category.allCases
	
    var body: some View {
		NavigationStack {
			VStack {
				navigationBar
				tabBar
				favoriteList
			}
		}
    }
	
	private var navigationBar: some View {
		NanaNavigationBar(title: String(localized: "favorite"))
			.padding(.bottom, 16)
	}
	
	private var tabBar: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 0) {
				ForEach(tabs, id: \.self) { tab in
					VStack(spacing: 0) {
						Text(tab.name)
							.font(.gothicNeo(tab == currentTab ? .semibold : .medium, size: 12))
							.foregroundStyle(Color.baseBlack)
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
						Rectangle()
							.fill(tab == currentTab ? .main : .clear)
							.frame(height: 2)
					}
					.onTapGesture {
						withAnimation {
							currentTab = tab
						}
					}
				}
			}
		}
		.padding(.bottom, 16)
	}
	
	private var favoriteList: some View {
		ScrollView(.vertical) {
			VStack {
				LazyVGrid(
					columns: [GridItem(.flexible()), GridItem(.flexible())]
				) {
					ForEach(
						favoriteVM.state.articles, id: \.self
					) { article in
						ArticleItem(article: article)
					}
				}
			}
		}
	}

}



#Preview {
    FavoriteMainView()
}
