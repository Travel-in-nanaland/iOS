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
		
		var allFavoriteArticles: ArticleResponse = .init()
		var natureFavoriteArticles: ArticleResponse = .init()
		var marketFavoriteArticles: ArticleResponse = .init()
		var festivalFavoriteArticles: ArticleResponse = .init()
		var experienceFavoriteArticles: ArticleResponse = .init()
		var nanaFavoriteArticles: ArticleResponse = .init()
        var restaurantFavoriteArticles: ArticleResponse = .init()
		
		var allFavoriteArticlePage: Int = 0
		var natureFavoriteArticlePage: Int = 0
		var marketFavoriteArticlePage: Int = 0
		var festivalFavoriteArticlePage: Int = 0
		var experienceFavoriteArticlePage: Int = 0
		var nanaFavoriteArticlePage: Int = 0
        var restaurantFavoriteArticlePage: Int = 0
	}
	
	enum Action {
		case getFavoriteList(category: Category)
		// 찜 리스트에서 하트 누른 경우 -> 리스트에서 삭제
		case deleteItemInFavoriteList(tab: Category, article: Article)
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
			
		case let .deleteItemInFavoriteList(tab, article):
			await deleteFavoriteArticle(article: article, tab: tab)
			
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
        case .restaurant:
            await getRestaurantFavoriteList()
		case .nanaPick:
			await getNanaFavoriteList()
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
	
	private func getNanaFavoriteList() async {
		if state.nanaFavoriteArticlePage == 0 {
			state.nanaFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getNanaFavoriteList(page: state.nanaFavoriteArticlePage) {
			if state.nanaFavoriteArticlePage == 0 {
				state.nanaFavoriteArticles = data.data
			} else {
				state.nanaFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.nanaFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getNanaFavoriteList Error")
			state.isLoading = false
		}
	}
    
    private func getRestaurantFavoriteList() async {
        if state.restaurantFavoriteArticlePage == 0 {
            state.restaurantFavoriteArticles.data.removeAll()
        }
        
        state.isLoading = true
        
        if let data = await FavoriteService.getRestaurantFavoriteList(page: state.restaurantFavoriteArticlePage) {
            if state.restaurantFavoriteArticlePage == 0 {
                state.restaurantFavoriteArticles = data.data
            } else {
                state.restaurantFavoriteArticles.data.append(contentsOf: data.data.data)
            }
            
            state.restaurantFavoriteArticlePage += 1
            state.isLoading = false
        } else {
            print("getRestaurantFavoriteList Error")
            state.isLoading = false
        }
    }
	
	private func deleteFavoriteArticle(article: Article, tab: Category) async {
		let result = await FavoriteService.toggleFavorite(id: article.id, category: article.category)
		
		guard let isFavorite = result?.data.favorite, !isFavorite
		else {return}
		
		switch tab {
		case .all:
            state.allFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.allFavoriteArticles.totalElements -= 1
		case .nature:
			state.natureFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.natureFavoriteArticles.totalElements -= 1
		case .festival:
			state.festivalFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.festivalFavoriteArticles.totalElements -= 1
		case .market:
			state.marketFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.marketFavoriteArticles.totalElements -= 1
		case .experience:
            state.experienceFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.experienceFavoriteArticles.totalElements -= 1
		case .nanaPick:
            state.nanaFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.nanaFavoriteArticles.totalElements -= 1
        case .restaurant:
            state.restaurantFavoriteArticles.data.removeAll(where: {$0.id == article.id})
            state.restaurantFavoriteArticles.totalElements -= 1
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
			state.nanaFavoriteArticlePage = 0
			state.nanaFavoriteArticles = .init()
        case .restaurant:
            state.restaurantFavoriteArticlePage = 0
            state.restaurantFavoriteArticles = .init()
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
        case .restaurant:
            return state.restaurantFavoriteArticles.totalElements == state.restaurantFavoriteArticles.data.count
		}
	}
}
