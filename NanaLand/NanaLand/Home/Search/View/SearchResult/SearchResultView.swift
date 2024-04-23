//
//  SearchResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import SwiftUI
import SwiftUIIntrospect

enum Category: String, CaseIterable {
	case all // 전체
	case nature  // 7대 자연
	case festival  // 축제
	case market  // 전통시장
	case experience  // 이색 체험
	case nanaPick  // 나나 Pick
	
	var name: String {
		return NSLocalizedString(self.rawValue, comment: "")
	}
}

struct SearchResultView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var searchVM: SearchViewModel
	
	@State var searchTerm: String
	
	let tabs: [Category] = Category.allCases
	
    var body: some View {
		VStack(spacing: 0) {
			navigationBar
			tabBar
			contentTab
		}
		.toolbar(.hidden, for: .navigationBar)
    }
	
	private var navigationBar: some View {
		HStack(spacing: 8) {
			Button(action: {
				dismiss()
			}, label: {
				Image(.icLeft)
					.resizable()
					.frame(width: 32, height: 32)
			})
			
			NanaSearchBar(
				searchTerm: $searchTerm,
				searchAction: {
					await searchVM.action(.searchTerm(category: .all, term: searchTerm))
				}
			)
		}
		.padding(.horizontal, 16)
		.padding(.top, 8)
		.padding(.bottom, 24)
	}
	
	private var tabBar: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			HStack(spacing: 0) {
				ForEach(tabs, id: \.self) { tab in
					VStack(spacing: 0) {
						Text(tab.name)
							.font(.gothicNeo(tab == searchVM.state.currentSearchTab ? .semibold : .medium, size: 12))
							.foregroundStyle(Color.baseBlack)
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
						Rectangle()
							.fill(tab == searchVM.state.currentSearchTab ? .main : .clear)
							.frame(height: 2)
					}
					.onTapGesture {
						withAnimation {
							searchVM.state.currentSearchTab = tab
						}
					}
				}
			}
		}
	}
	
	private var contentTab: some View {
		TabView(selection: $searchVM.state.currentSearchTab) {
			SearchAllCategoryResultView()
				.tag(Category.all)
			
			SearchDetailCategoryResultView(tab: .nature, searchTerm: searchTerm)
				.tag(Category.nature)
			
			SearchDetailCategoryResultView(tab: .festival, searchTerm: searchTerm)
				.tag(Category.festival)
			
			SearchDetailCategoryResultView(tab: .market, searchTerm: searchTerm)
				.tag(Category.market)
			
			SearchDetailCategoryResultView(tab: .experience, searchTerm: searchTerm)
				.tag(Category.experience)
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
			scrollView.isScrollEnabled = false
		}
	}
}

#Preview {
	SearchResultView(searchTerm: "")
		.environmentObject(SearchViewModel())
}
