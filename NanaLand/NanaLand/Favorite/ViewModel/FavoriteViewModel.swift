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
		var activityFavoriteArticles: ArticleResponse = .init()
        var cultureAndArtsFavoriteArticles: ArticleResponse = .init()
		var nanaFavoriteArticles: ArticleResponse = .init()
        var restaurantFavoriteArticles: ArticleResponse = .init()
		
		var allFavoriteArticlePage: Int = 0
		var natureFavoriteArticlePage: Int = 0
		var marketFavoriteArticlePage: Int = 0
		var festivalFavoriteArticlePage: Int = 0
		var activityFavoriteArticlePage: Int = 0
        var cultureAndArtsFavoriteArticlePage: Int = 0
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
		case .activity:
			await getActivityFavoriteList()
        case .cultureAndArts:
            await getCultureAndArtsFavoriteList()
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
            
            print(data.data)
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
	
	private func getActivityFavoriteList() async {
		if state.activityFavoriteArticlePage == 0 {
			state.activityFavoriteArticles.data.removeAll()
		}
		
		state.isLoading = true
		
		if let data = await FavoriteService.getActivityFavoriteList(page: state.activityFavoriteArticlePage) {
			if state.activityFavoriteArticlePage == 0 {
				state.activityFavoriteArticles = data.data
			} else {
				state.activityFavoriteArticles.data.append(contentsOf: data.data.data)
			}
			
			state.activityFavoriteArticlePage += 1
			state.isLoading = false
		} else {
			print("getActivityFavoriteList Error")
			state.isLoading = false
		}
	}
    
//    private func getCultureAndArtsFavoriteList() async {
//        if state.cultureAndArtsFavoriteArticlePage == 0 {
//            state.cultureAndArtsFavoriteArticles.data.removeAll()
//        }
//        
//        state.isLoading = true
//        
//        if let data = await FavoriteService.getCultureAndArtsFavoriteList(page: state.cultureAndArtsFavoriteArticlePage) {
//            if state.cultureAndArtsFavoriteArticlePage == 0 {
//                state.cultureAndArtsFavoriteArticles = data.data
//            } else {
//                state.cultureAndArtsFavoriteArticles.data.append(contentsOf: data.data.data)
//            }
//            
//            state.cultureAndArtsFavoriteArticlePage += 1
//            state.isLoading = false
//        } else {
//            print("getCultureAndArtsFavoriteList Error")
//            state.isLoading = false
//        }
//    }
    private func getCultureAndArtsFavoriteList() async {
        if state.cultureAndArtsFavoriteArticlePage == 0 {
            state.cultureAndArtsFavoriteArticles.data.removeAll()
        }
        
        state.isLoading = true
        
        if let data = await FavoriteService.getCultureAndArtsFavoriteList(page: state.cultureAndArtsFavoriteArticlePage) {
            if state.cultureAndArtsFavoriteArticlePage == 0 {
                // 데이터를 변환하여 저장
                state.cultureAndArtsFavoriteArticles = ArticleResponse(
                    totalElements: data.data.totalElements,
                    data: data.data.data.map { article in
                        var modifiedArticle = article
                        if article.category == .activity {
                            modifiedArticle.category = .cultureAndArts // category를 변경
                        }
                        return modifiedArticle
                    }
                )
            } else {
                // 추가 데이터를 변환하여 저장
                let newArticles = data.data.data.map { article in
                    var modifiedArticle = article
                    if article.category == .activity {
                        modifiedArticle.category = .cultureAndArts // category를 변경
                    }
                    return modifiedArticle
                }
                state.cultureAndArtsFavoriteArticles.data.append(contentsOf: newArticles)
            }
            
            state.cultureAndArtsFavoriteArticlePage += 1
            state.isLoading = false
        } else {
            print("getCultureAndArtsFavoriteList Error")
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
		case .activity:
            state.activityFavoriteArticles.data.removeAll(where: {$0.id == article.id})
			state.activityFavoriteArticles.totalElements -= 1
        case .cultureAndArts:
            state.cultureAndArtsFavoriteArticles.data.removeAll(where: {$0.id == article.id})
            state.cultureAndArtsFavoriteArticles.totalElements -= 1
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
		case .activity:
			state.activityFavoriteArticlePage = 0
			state.activityFavoriteArticles = .init()
        case .cultureAndArts:
            state.cultureAndArtsFavoriteArticlePage = 0
            state.cultureAndArtsFavoriteArticles = .init()
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
		case .activity:
            return state.activityFavoriteArticles.totalElements == state.activityFavoriteArticles.data.count
        case .cultureAndArts:
            return state.cultureAndArtsFavoriteArticles.totalElements == state.cultureAndArtsFavoriteArticles.data.count
		case .nanaPick:
			return true
        case .restaurant:
            return state.restaurantFavoriteArticles.totalElements == state.restaurantFavoriteArticles.data.count
		}
	}
}
