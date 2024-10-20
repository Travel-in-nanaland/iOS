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
		
		var recentSearchTerms: [String] = UserDefaults.standard.stringArray(forKey: "recentSearch") ?? []
		var popularSearchTerms: [String] = []
		
		var allCategorySearchResult = SearchAllArticleResponse()
		var natureCategorySearchResult = ArticleResponse()
		var marketCategorySearchResult = ArticleResponse()
		var festivalCategorySearchResult = ArticleResponse()
		var experienceCategorySearchResult = ArticleResponse()
		var nanaCategorySearchResult = ArticleResponse()
        var restaurantCategorySearchResult = ArticleResponse()
		
		var naturePage: Int = 0
		var marketPage: Int = 0
		var festivalPage: Int = 0
		var experiencePage: Int = 0
		var nanaPage: Int = 0
        var restaurantPage: Int = 0
		
		var searchVolumeResult: [Article] = []
		
		var isLoading: Bool = false
	}
	
	enum Action {
		case searchTerm(category: Category, term: String)
		case didTapHeartInSearchAll(tab: Category, article: Article)
		case didTapHeartInSearchDetail(category: Category, article: Article)
		case didTapHeartInVolumeUp(article: Article)
		case getPopularKeyword
		case getVolumeUp
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
		case let .didTapHeartInSearchAll(tab, article):
			await didTapHeartInSearchAll(tab: tab, article: article)
		case let .didTapHeartInSearchDetail(category, article):
			await didTapHeartInSearchDetail(category: category, article: article)
		case let .didTapHeartInVolumeUp(article):
			await didTapHeartInVolumeUp(article: article)
		case .getPopularKeyword:
			await getPopularKeyword()
		case .getVolumeUp:
			await getVolumeUp()
		}
	}
	
	private func resetData() {
		state.currentSearchTab = .all
		state.allCategorySearchResult = .init()
		state.natureCategorySearchResult = .init()
		state.festivalCategorySearchResult = .init()
		state.marketCategorySearchResult = .init()
		state.experienceCategorySearchResult = .init()
		state.nanaCategorySearchResult = .init()
        state.restaurantCategorySearchResult = .init()
		state.naturePage = 0
		state.marketPage = 0
		state.festivalPage = 0
		state.experiencePage = 0
		state.nanaPage = 0
	}
	
	private func setRecentSearch(term: String) {
		if state.recentSearchTerms.contains(term) {
			state.recentSearchTerms.removeAll(where: {$0 == term})
		}
		state.recentSearchTerms.insert(term, at: 0)
		UserDefaults.standard.setValue(state.recentSearchTerms, forKey: "recentSearch")
	}
	
	private func getPopularKeyword() async {
		if let result = await SearchService.getPopularKeyword()?.data {
			state.popularSearchTerms = result
		}
	}
	
	private func getVolumeUp() async {
		if let result = await SearchService.getVolumeUp()?.data {
			state.searchVolumeResult = result
		}
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
                print("\(data.data)")
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
			if state.nanaPage == 0 {
				state.nanaCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchNanaCategory(term: term, page: state.nanaPage) {
				if state.nanaPage == 0 {
					state.nanaCategorySearchResult = data.data
				} else {
					state.nanaCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.nanaPage += 1
				state.isLoading = false
			} else {
				print("searchNanaCategory Error")
				state.isLoading = false
			}
            
        case .restaurant:
            if state.restaurantPage == 0 {
                state.restaurantCategorySearchResult = .init()
            }
            
            state.isLoading = true
            
            if let data = await SearchService.searchExperienceCategory(term: term, page: state.restaurantPage) {
                if state.restaurantPage == 0 {
                    state.restaurantCategorySearchResult = data.data
                } else {
                    state.restaurantCategorySearchResult.data.append(contentsOf: data.data.data)
                }
                state.restaurantPage += 1
                state.isLoading = false
            } else {
                print("searchRestaurantCategory Error")
                state.isLoading = false
            }

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
			return state.nanaCategorySearchResult.totalElements == state.nanaCategorySearchResult.data.count
        case .restaurant:
            return state.restaurantCategorySearchResult.totalElements == state.restaurantCategorySearchResult.data.count
		}
	}
	
	private func didTapHeartInSearchAll(tab: Category, article: Article) async {
		guard tab != .all,
			  let result = await FavoriteService.toggleFavorite(id: article.id, category: tab)
		else {return}
		
		
		
		switch tab {
		case .all:
			print("didTapHeartInSearchAll - all은 허용되지 않음")
		case .nature:
            if let index = state.allCategorySearchResult.nature.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.nature.data[index].favorite = result.data.favorite
			}
			
		case .festival:
            if let index = state.allCategorySearchResult.festival.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.festival.data[index].favorite = result.data.favorite
			}
			
		case .market:
			if let index = state.allCategorySearchResult.market.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.market.data[index].favorite = result.data.favorite
			}
			
		case .experience:
			if let index = state.allCategorySearchResult.experience.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.experience.data[index].favorite = result.data.favorite
			}
			
		case .nanaPick:
			if let index = state.allCategorySearchResult.nana.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.nana.data[index].favorite = result.data.favorite
			}
        case .restaurant:
            if let index = state.allCategorySearchResult.restaurant.data.firstIndex(where: {$0.id == article.id}) {
                state.allCategorySearchResult.restaurant.data[index].favorite = result.data.favorite
            }
		}
	}
	
	private func didTapHeartInSearchDetail(category: Category, article: Article) async {
		guard category != .all,
			  let result = await FavoriteService.toggleFavorite(id: article.id, category: category)
		else {return}
		
		switch category {
		case .all:
			print("didTapHeartInSearchDetail - all은 허용되지 않음")
		case .nature:
			if let index = state.natureCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.natureCategorySearchResult.data[index].favorite = result.data.favorite
			}
			
		case .festival:
			if let index = state.festivalCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.festivalCategorySearchResult.data[index].favorite = result.data.favorite
			}
			
		case .market:
			if let index = state.marketCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.marketCategorySearchResult.data[index].favorite = result.data.favorite
			}
			
		case .experience:
			if let index = state.experienceCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.experienceCategorySearchResult.data[index].favorite = result.data.favorite
			}
			
		case .nanaPick:
			if let index = state.nanaCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.nanaCategorySearchResult.data[index].favorite = result.data.favorite
			}
        case .restaurant:
            if let index = state.restaurantCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
                state.restaurantCategorySearchResult.data[index].favorite = result.data.favorite
            }
		}
	}
	
	private func didTapHeartInVolumeUp(article: Article) async {
		guard let result = await FavoriteService.toggleFavorite(id: article.id, category: article.category) else {return}
		
		if let index = state.searchVolumeResult.firstIndex(where: {$0.id == article.id}) {
			state.searchVolumeResult[index].favorite = result.data.favorite
		}
	}
	
	func isSeaechresultIsEmpty() -> Bool {
		switch state.currentSearchTab {
		case .all:
			return true
		case .nature:
			return state.natureCategorySearchResult.data.isEmpty
		case .festival:
			return state.festivalCategorySearchResult.data.isEmpty
		case .market:
			return state.marketCategorySearchResult.data.isEmpty
		case .experience:
			return state.experienceCategorySearchResult.data.isEmpty
		case .nanaPick:
			return state.nanaCategorySearchResult.data.isEmpty
        case .restaurant:
            return state.restaurantCategorySearchResult.data.isEmpty
		}
	}
}
