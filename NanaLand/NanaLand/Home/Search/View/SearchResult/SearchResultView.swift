//
//  SearchResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import SwiftUI
import SwiftUIIntrospect

enum Category: String, CaseIterable, Codable {
	case all // 전체
	case nature  // 7대 자연
	case festival  // 축제
	case market  // 전통시장
	case experience  // 이색 체험
	case nanaPick  // 나나 Pick
	
	var name: String {
		return NSLocalizedString(self.rawValue, comment: "")
	}
	
	var uppercase: String {
		switch self {
		case .all:
			return ""
		case .nature:
			return "NATURE"
		case .festival:
			return "FESTIVAL"
		case .market:
			return "MARKET"
		case .experience:
			return "EXPERIENCE"
		case .nanaPick:
			return "NANA"
		}
	}
}

struct SearchResultView: View {
	@Environment(\.dismiss) var dismiss
	@ObservedObject var searchVM: SearchViewModel
	
	@State var searchTerm: String
	
	@State var isNatureSearchIsDone: Bool = false
	@State var isMarketSearchIsDone: Bool = false
	@State var isFestivalSearchIsDone: Bool = false
	@State var isExperienceSearchIsDone: Bool = false
	@State var isNanaSearchIsDone: Bool = false
	
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
				Image("icLeft")
					.resizable()
					.frame(width: 32, height: 32)
			})
			
			NanaSearchBar(
				searchTerm: $searchTerm,
				searchAction: {
					await searchVM.action(.searchTerm(category: .all, term: searchTerm))
					isNatureSearchIsDone = false
					isMarketSearchIsDone = false
					isFestivalSearchIsDone = false
					isExperienceSearchIsDone = false
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
			SearchAllCategoryResultView(searchVM: searchVM)
				.tag(Category.all)
			
			SearchDetailCategoryResultView(searchVM: searchVM, tab: .nature, searchTerm: searchTerm)
				.tag(Category.nature)
				.onAppear {
					if !isNatureSearchIsDone {
						Task {
							print("search Nature")
							await searchVM.action(.searchTerm(category: .nature, term: searchTerm))
						}
						isNatureSearchIsDone = true
					}
				}
			
			SearchDetailCategoryResultView(searchVM: searchVM, tab: .festival, searchTerm: searchTerm)
				.tag(Category.festival)
				.onAppear {
					if !isFestivalSearchIsDone {
						Task {
							await searchVM.action(.searchTerm(category: .festival, term: searchTerm))
						}
						isFestivalSearchIsDone = true
					}
				}
			
			SearchDetailCategoryResultView(searchVM: searchVM, tab: .market, searchTerm: searchTerm)
				.tag(Category.market)
				.onAppear {
					if !isMarketSearchIsDone {
						Task {
							await searchVM.action(.searchTerm(category: .market, term: searchTerm))
						}
						isMarketSearchIsDone = true
					}
				}
			
			SearchDetailCategoryResultView(searchVM: searchVM, tab: .experience, searchTerm: searchTerm)
				.tag(Category.experience)
				.onAppear {
					if !isExperienceSearchIsDone {
						Task {
							await searchVM.action(.searchTerm(category: .experience, term: searchTerm))
						}
						isExperienceSearchIsDone = true
					}
				}
			
			SearchDetailCategoryResultView(searchVM: searchVM, tab: .nanaPick, searchTerm: searchTerm)
				.tag(Category.nanaPick)
				.onAppear {
					if !isNanaSearchIsDone {
						Task {
							await searchVM.action(.searchTerm(category: .nanaPick, term: searchTerm))
						}
						isNanaSearchIsDone = true
					}
				}
		}
		.tabViewStyle(.page(indexDisplayMode: .never))
		.introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
			scrollView.isScrollEnabled = false
		}
	}
}

#Preview {
	SearchResultView(searchVM: SearchViewModel(), searchTerm: "")
}
