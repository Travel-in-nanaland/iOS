//
//  SearchViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {
	struct State {		
		var currentSearchTab: Category = .all
		// dummy
		var recentSearchTerms: [String] = UserDefaults.standard.stringArray(forKey: "recentSearch") ?? []
		var popularSearchTerms: [String] = ["애월 드라이브코스", "제주공항 맛집", "애월 카페거리", "서귀포 전시회", "유채꽃", "서귀포 맛집", "함덕 해수욕장", "흑돼지 맛집"]
		var placeString: String = "제주 감귤밭"
		
		var allCategorySearchResult = SearchAllCategoryResponse()
		
		var natureCategorySearchResult = SearchDetailCategoryResponse()
		var marketCategorySearchResult = SearchDetailCategoryResponse()
		var festivalCategorySearchResult = SearchDetailCategoryResponse()
		var experienceCategorySearchResult = SearchDetailCategoryResponse()
		
		var naturePage: Int = 0
		var marketPage: Int = 0
		var festivalPage: Int = 0
		var experiencePage: Int = 0
		
		var isLoading: Bool = false
	}
	
	enum Action {
		case searchTerm(category: Category, term: String)
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
	func action(_ action: Action) async {
		switch action {
		case let .searchTerm(category: category, term: term):
			await search(category: category, term: term)
		}
	}
	
	private func resetData() {
		state.currentSearchTab = .all
		state.allCategorySearchResult = .init()
		state.natureCategorySearchResult = .init()
		state.festivalCategorySearchResult = .init()
		state.marketCategorySearchResult = .init()
		state.experienceCategorySearchResult = .init()
		state.naturePage = 0
		state.marketPage = 0
		state.festivalPage = 0
		state.experiencePage = 0
	}
	
	private func setRecentSearch(term: String) {
		if state.recentSearchTerms.contains(term) {
			state.recentSearchTerms.removeAll(where: {$0 == term})
		}
		state.recentSearchTerms.insert(term, at: 0)
		UserDefaults.standard.setValue(state.recentSearchTerms, forKey: "recentSearch")
	}
	
	private func search(category: Category, term: String) async {
		switch category {
		case .all:
			resetData()
			// navigation이 push 된 다음에 state 반영으로 자연스럽게
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
				self?.setRecentSearch(term: term)
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchAllCategory(term: term) {
				state.allCategorySearchResult = data.data
				state.isLoading = false
			} else {
				print("searchAllCategory Error")
				state.isLoading = false
			}
			
		case .nature:
			if state.naturePage == 0 {
				state.natureCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchNatureCategory(term: term, page: state.naturePage) {
				if state.naturePage == 0 {
					state.natureCategorySearchResult = data.data
				} else {
					state.natureCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.naturePage += 1
				state.isLoading = false
			} else {
				print("searchNatureCategory Error")
				state.isLoading = false
			}
			
		case .festival:
			if state.festivalPage == 0 {
				state.festivalCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchFestivalCategory(term: term, page: state.festivalPage) {
				if state.festivalPage == 0 {
					state.festivalCategorySearchResult = data.data
				} else {
					state.festivalCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.festivalPage += 1
				state.isLoading = false
			} else {
				print("searchFestivalCategory Error")
				state.isLoading = false
			}
			
		case .market:
			if state.marketPage == 0 {
				state.marketCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchMarketCategory(term: term, page: state.marketPage) {
				if state.marketPage == 0 {
					state.marketCategorySearchResult = data.data
				} else {
					state.marketCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.marketPage += 1
				state.isLoading = false
			} else {
				print("searchMarketCategory Error")
				state.isLoading = false
			}
			
		case .experience:
			if state.experiencePage == 0 {
				state.experienceCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchExperienceCategory(term: term, page: state.experiencePage) {
				if state.experiencePage == 0 {
					state.experienceCategorySearchResult = data.data
				} else {
					state.experienceCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.experiencePage += 1
				state.isLoading = false
			} else {
				print("searchExperienceCategory Error")
				state.isLoading = false
			}

			
		case .nanaPick:
			print("nanaPick Search")
		}

	}
	
	func getCurrentTime() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy. MM. dd | a hh:mm"
		formatter.locale = Locale(identifier: "en_US_POSIX")
		
		return formatter.string(from: Date())
	}
	
	func isLastPage(tab: Category) -> Bool {
		switch tab {
		case .all:
			return false
		case .nature:
			return state.natureCategorySearchResult.totalElements == state.natureCategorySearchResult.data.count
		case .festival:
			return state.festivalCategorySearchResult.totalElements == state.festivalCategorySearchResult.data.count
		case .market:
			return state.marketCategorySearchResult.totalElements == state.marketCategorySearchResult.data.count
		case .experience:
			return state.experienceCategorySearchResult.totalElements == state.experienceCategorySearchResult.data.count
		case .nanaPick:
			return false
		}
	}
}
