//
//  FavoriteMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import SwiftUIIntrospect

struct FavoriteMainView: View {
	@StateObject var favoriteVM = FavoriteViewModel()
	
	@State var currentTab: Category = .all
	let tabs: [Category] = Category.allCases
	
	@AppStorage("provider") var provider: String = ""
	
	var body: some View {
		VStack {
			navigationBar
			tabBar
			contentTab
		}
		.onAppear {
			if provider == "GUEST" {
				withAnimation {
					AppState.shared.showRegisterInduction = true
				}
			}
		}
	}
	
	private var navigationBar: some View {
		NanaNavigationBar(title: .favorite)
			.padding(.bottom, 16)
	}
	
	private var tabBar: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 0) {
				ForEach(tabs, id: \.self) { tab in
					VStack(spacing: 0) {
						Text(tab.localizedName)
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
	
	private var contentTab: some View {
		TabView(selection: $currentTab) {
			FavoriteListView(category: .all)
				.tag(Category.all)
			
			FavoriteListView(category: .nature)
				.tag(Category.nature)
			
			FavoriteListView(category: .festival)
				.tag(Category.festival)
			
			FavoriteListView(category: .market)
				.tag(Category.market)
			
			FavoriteListView(category: .experience)
				.tag(Category.experience)
			
			FavoriteListView(category: .nanaPick)
				.tag(Category.nanaPick)
		}
		.environmentObject(favoriteVM)
		.tabViewStyle(.page(indexDisplayMode: .never))
		.introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
			scrollView.isScrollEnabled = false
		}
	}

}



#Preview {
    FavoriteMainView()
}
