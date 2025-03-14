//
//  SearchViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import Foundation
import SwiftUICalendar

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
		var activityCategorySearchResult = ArticleResponse()
        var cultureAndArtsCategorySearchResult = ArticleResponse()
		var nanaCategorySearchResult = ArticleResponse()
        var restaurantCategorySearchResult = ArticleResponse()
		
		var naturePage: Int = 0
		var marketPage: Int = 0
		var festivalPage: Int = 0
		var activityPage: Int = 0
        var cultureAndArtsPage: Int = 0
		var nanaPage: Int = 0
        var restaurantPage: Int = 0
		
		var searchVolumeResult: [Article] = []
		
		var isLoading: Bool = false
        
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language) // 필터 내 어떤 지역이 선택 되었는지 알려주는 변수
        var selectedLocation: [LocalizedKey] = []
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        
        var selectedStartDate: YearMonthDay? = .current // 선택 시작날짜 오늘 날짜로 초기화
        var selectedEndDate: YearMonthDay? = .current // 선택 종료날짜 오늘 날짜로 초기화
        
        var selectedKeyword: [String] = []
	}
	
	enum Action {
		case searchTerm(category: Category, term: String)
        case searchFilterNatureMainItem(term: String, page: Int, filterName: String) // 자연 검색시 지역선택
        case searchFilterMarketMainItem(term: String, page: Int, filterName: String) // 전통시장 검색시 지역선택
        case searchFilterFestivalMainItem(term: String, page: Int, startDate: String, endDate: String) // 축제 검색 시 날짜 선택, 추후 장소 선택도 추가하기
        case searchFilterActivityMainItem(term: String, page: Int, type: String, keyword: String, filterName: String) // 액티비티 검색 시 지역 선택
        case searchFilterCultureAndArtsMainItem(term: String, page: Int, type: String, keyword: String, filterName: String) // 문화예술 검색 시 지역 선택
        case searchFilterRestaurantMainItem(term: String, page: Int, keyword: String, filterName: String) // 제주맛집 검색 시 지역 선택
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
        case let .searchFilterNatureMainItem(term: term, page: page, filterName: filterName):
            let response = await SearchService.searchFilterNatureCategory(term: term, page: page, filterName: filterName)
            print(response!.data)
            if response != nil {
                await MainActor.run {
                    print(response!.data.totalElements)
                    state.natureCategorySearchResult.totalElements = response!.data.totalElements
                    state.natureCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error")
            }
        case let .searchFilterMarketMainItem(term: term, page: page, filterName: filterName):
            let response = await SearchService.searchFilterMarketCategory(term: term, page: page, filterName: filterName)
            print(response!.data)
            if response != nil {
                await MainActor.run {
                    print(response!.data.totalElements)
                    state.marketCategorySearchResult.totalElements = response!.data.totalElements
                    state.marketCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error")
            }
        case let .searchFilterFestivalMainItem(term: term, page: page, startDate: startDate, endDate: endDate):
            let response = await SearchService.searchFilterFestivalCategory(term: term, page: page, startDate: startDate, endDate: endDate)
            if response != nil {
                await MainActor.run {
                    state.festivalCategorySearchResult.totalElements = response!.data.totalElements
                    state.festivalCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error - searchFilterFestivalMainItem")
            }
        case let .searchFilterActivityMainItem(term: term, page: page, type: type, keyword: keyword, filterName: filterName):
            let response = await SearchService.searchFilterActivityCategory(term: term, page: page, type: type, keyword: keyword, filterName: filterName)
            if response != nil {
                await MainActor.run {
                    state.activityCategorySearchResult.totalElements = response!.data.totalElements
                    state.activityCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error - searchFilterAcitivityMainItemError")
            }
        case let .searchFilterCultureAndArtsMainItem(term: term, page: page, type: type, keyword: keyword, filterName: filterName):
            let response = await SearchService.searchFilterCultureAndArtsCategory(term: term, page: page, type: type, keyword: keyword, filterName: filterName)
            if response != nil {
                await MainActor.run {
                    print(response!.data)
                    state.cultureAndArtsCategorySearchResult.totalElements = response!.data.totalElements
                    state.cultureAndArtsCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error - searchFilterCultureAndArtsMainItemError")
            }
        case let .searchFilterRestaurantMainItem(term: term, page: page, keyword: keyword, filterName: filterName):
            let response = await SearchService.searchFilterRestaurantCategory(term: term, page: page, keyword: keyword, filterName: filterName)
            print(response)
            if response != nil {
                await MainActor.run {
                    state.restaurantCategorySearchResult.totalElements = response!.data.totalElements
                    state.restaurantCategorySearchResult.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Error - searchFilterRestaurantMainItemError")
            }
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
		state.activityCategorySearchResult = .init()
        state.cultureAndArtsCategorySearchResult = .init()
		state.nanaCategorySearchResult = .init()
        state.restaurantCategorySearchResult = .init()
		state.naturePage = 0
		state.marketPage = 0
		state.festivalPage = 0
		state.activityPage = 0
        state.cultureAndArtsPage = 0
		state.nanaPage = 0
        state.restaurantPage = 0
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
            print(state.searchVolumeResult)
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
			
		case .activity:
			if state.activityPage == 0 {
				state.activityCategorySearchResult = .init()
			}
			
			state.isLoading = true
			
			if let data = await SearchService.searchActivityCategory(term: term, page: state.activityPage) {
				if state.activityPage == 0 {
					state.activityCategorySearchResult = data.data
				} else {
					state.activityCategorySearchResult.data.append(contentsOf: data.data.data)
				}
				
				state.activityPage += 1
				state.isLoading = false
			} else {
				print("searchExperienceCategory Error")
				state.isLoading = false
			}

        case .cultureAndArts:
            if state.cultureAndArtsPage == 0 {
                state.cultureAndArtsCategorySearchResult = .init()
            }
            
            state.isLoading = true
            
            if let data = await SearchService.searchCultureAndArtsCategory(term: term, page: state.cultureAndArtsPage) {
                if state.cultureAndArtsPage == 0 {
                    state.cultureAndArtsCategorySearchResult = data.data
                } else {
                    state.cultureAndArtsCategorySearchResult.data.append(contentsOf: data.data.data)
                }
                
                state.cultureAndArtsPage += 1
                state.isLoading = false
            } else {
                print("searchCultureCategory Error")
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
            
            if let data = await SearchService.searchRestaurantCategory(term: term, page: state.restaurantPage) {
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
		case .activity:
			return state.activityCategorySearchResult.totalElements == state.activityCategorySearchResult.data.count
        case .cultureAndArts:
            return state.cultureAndArtsCategorySearchResult.totalElements == state.cultureAndArtsCategorySearchResult.data.count
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
			
		case .activity:
			if let index = state.allCategorySearchResult.activity.data.firstIndex(where: {$0.id == article.id}) {
				state.allCategorySearchResult.activity.data[index].favorite = result.data.favorite
			}
			
        case .cultureAndArts:
            if let index = state.allCategorySearchResult.cultureAndArts.data.firstIndex(where: {$0.id == article.id}) {
                state.allCategorySearchResult.cultureAndArts.data[index].favorite = result.data.favorite
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
			
		case .activity:
			if let index = state.activityCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
				state.activityCategorySearchResult.data[index].favorite = result.data.favorite
			}
            
        case .cultureAndArts:
            if let index = state.cultureAndArtsCategorySearchResult.data.firstIndex(where: {$0.id == article.id}) {
                state.cultureAndArtsCategorySearchResult.data[index].favorite = result.data.favorite
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
		case .activity:
			return state.activityCategorySearchResult.data.isEmpty
        case .cultureAndArts:
            return state.cultureAndArtsCategorySearchResult.data.isEmpty
		case .nanaPick:
			return state.nanaCategorySearchResult.data.isEmpty
        case .restaurant:
            return state.restaurantCategorySearchResult.data.isEmpty
		}
	}
}
