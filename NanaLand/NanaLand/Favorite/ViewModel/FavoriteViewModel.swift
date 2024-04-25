//
//  FavoriteViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/21/24.
//

import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
	struct State {
		var isLoading: Bool = false
		
		var allFavoriteArticles: FavoriteListResponse = .init()
		var natureFavoriteArticles: FavoriteListResponse = .init()
		var marketFavoriteArticles: FavoriteListResponse = .init()
		var festivalFavoriteArticles: FavoriteListResponse = .init()
		var experienceFavoriteArticles: FavoriteListResponse = .init()
		
		var allFavoriteArticlePage: Int = 0
		var natureFavoriteArticlePage: Int = 0
		var marketFavoriteArticlePage: Int = 0
		var festivalFavoriteArticlePage: Int = 0
		var experienceFavoriteArticlePage: Int = 0
		
		// 찜 토글 API 호출 결과 임시저장
		var currentFavoriteResult: Bool = false
	}
	
	enum Action {
		case getFavoriteList(category: Category)
		case didTapHeart(category: Category, article: Article)
		case deleteItemInFavoriteList(index: Int, category: Category)
		case refreshData(category: Category)
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
	func action(_ action: Action) async {
		switch action {
		case let .getFavoriteList(category: category):
			await fetchFavoriteList(category: category)
			
		case let .didTapHeart(category: category, article: article):
			state.currentFavoriteResult = await toggleFavorite(category: category, article: article)
			
		case let .deleteItemInFavoriteList(index: index, category: category):
			await deleteFavoriteArticle(index: index, category: category)
			
		case let .refreshData(category: category):
			await refreshData(category: category)
		}
	}
	
	private func fetchFavoriteList(category: Category) async {
		switch category {
		case .all:
			await getAllFavoriteList()
		case .nature:
			await getNatureFavoriteList()
		case .festival:
			await getFestivalFavoriteList()
		case .market:
			await getMarketFavoriteList()
		case .experience:
			await getExperienceFavoriteList()
		case .nanaPick:
			print("nana 아직 구현X")
		}
	}
	
	private func getAllFavoriteList() async {
		if state.allFavoriteArticlePage == 0 {
			state.allFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getAllFavoriteList(page: state.allFavoriteArticlePage) {
			if state.allFavoriteArticlePage == 0 {
				state.allFavoriteArticles = data.data
			} else {
				state.allFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.allFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getAllFavoriteList Error")
			state.isLoading = false
		}
	}
	
	private func getNatureFavoriteList() async {
		if state.natureFavoriteArticlePage == 0 {
			state.natureFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getNatureFavoriteList(page: state.natureFavoriteArticlePage) {
			if state.natureFavoriteArticlePage == 0 {
				state.natureFavoriteArticles = data.data
			} else {
				state.natureFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.natureFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getNatureFavoriteList Error")
			state.isLoading = false
		}
	}
	
	private func getFestivalFavoriteList() async {
		if state.festivalFavoriteArticlePage == 0 {
			state.festivalFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getFestivalFavoriteList(page: state.festivalFavoriteArticlePage) {
			if state.festivalFavoriteArticlePage == 0 {
				state.festivalFavoriteArticles = data.data
			} else {
				state.festivalFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.festivalFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getFestivalFavoriteList Error")
			state.isLoading = false
		}
	}
	
	private func getMarketFavoriteList() async {
		if state.marketFavoriteArticlePage == 0 {
			state.marketFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getMarketFavoriteList(page: state.marketFavoriteArticlePage) {
			if state.marketFavoriteArticlePage == 0 {
				state.marketFavoriteArticles = data.data
			} else {
				state.marketFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.marketFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getMarketFavoriteList Error")
			state.isLoading = false
		}
	}
	
	private func getExperienceFavoriteList() async {
		if state.experienceFavoriteArticlePage == 0 {
			state.experienceFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getExperienceFavoriteList(page: state.experienceFavoriteArticlePage) {
			if state.experienceFavoriteArticlePage == 0 {
				state.experienceFavoriteArticles = data.data
			} else {
				state.experienceFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.experienceFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getExperienceFavoriteList Error")
			state.isLoading = false
		}
	}
	
	private func toggleFavorite(category: Category, article: Article) async -> Bool {
		switch category {
		case .nature:
			return await FavoriteService.toggleFavoriteNature(id: article.id)?.data.favorite ?? false
		case .festival:
			return await FavoriteService.toggleFavoriteFestival(id: article.id)?.data.favorite ?? false
		case .market:
			return await FavoriteService.toggleFavoriteMarket(id: article.id)?.data.favorite ?? false
		case .experience:
			return await FavoriteService.toggleFavoriteExperience(id: article.id)?.data.favorite ?? false
		case .nanaPick:
			return await FavoriteService.toggleFavoriteNana(id: article.id)?.data.favorite ?? false
		default:
			print("error toggleFavorite")
			return false
		}
	}
	
	private func deleteFavoriteArticle(index: Int, category: Category) async {
		switch category {
		case .all:
			state.allFavoriteArticles.data.remove(at: index)
			state.allFavoriteArticles.totalElements -= 1
		case .nature:
			state.natureFavoriteArticles.data.remove(at: index)
			state.natureFavoriteArticles.totalElements -= 1
		case .festival:
			state.festivalFavoriteArticles.data.remove(at: index)
			state.festivalFavoriteArticles.totalElements -= 1
		case .market:
			state.marketFavoriteArticles.data.remove(at: index)
			state.marketFavoriteArticles.totalElements -= 1
		case .experience:
			state.experienceFavoriteArticles.data.remove(at: index)
			state.experienceFavoriteArticles.totalElements -= 1
		case .nanaPick:
			state.allFavoriteArticles.data.remove(at: index)
			state.allFavoriteArticles.totalElements -= 1
		}
	}
	
	private func refreshData(category: Category) async {
		resetData(category: category)
		
		await fetchFavoriteList(category: category)
	}
	
	private func resetData(category: Category) {
		switch category {
		case .all:
			state.allFavoriteArticlePage = 0
			state.allFavoriteArticles = .init()
		case .nature:
			state.natureFavoriteArticlePage = 0
			state.natureFavoriteArticles = .init()
		case .festival:
			state.festivalFavoriteArticlePage = 0
			state.festivalFavoriteArticles = .init()
		case .market:
			state.marketFavoriteArticlePage = 0
			state.marketFavoriteArticles = .init()
		case .experience:
			state.experienceFavoriteArticlePage = 0
			state.experienceFavoriteArticles = .init()
		case .nanaPick:
			state.allFavoriteArticlePage = 0
			state.allFavoriteArticles = .init()
		}
	}
	
	func isLastPage(tab: Category) -> Bool {
		switch tab {
		case .all:
			return state.allFavoriteArticles.totalElements == state.allFavoriteArticles.data.count
		case .nature:
			return state.natureFavoriteArticles.totalElements == state.natureFavoriteArticles.data.count
		case .festival:
			return state.festivalFavoriteArticles.totalElements == state.festivalFavoriteArticles.data.count
		case .market:
			return state.marketFavoriteArticles.totalElements == state.marketFavoriteArticles.data.count
		case .experience:
			return state.experienceFavoriteArticles.totalElements == state.experienceFavoriteArticles.data.count
		case .nanaPick:
			return true
		}
	}
}
