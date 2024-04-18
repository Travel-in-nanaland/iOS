//
//  SearchViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import Foundation
import SwiftUI
import Alamofire

@MainActor
final class SearchViewModel: ObservableObject {
	struct State {		
		var currentSearchTab: Category = .all
		// dummy
		var recentSearchTerms: [String] = ["제주시", "제주 드라이브", "서귀포 놀거리", "나나랜드"]
		var popularSearchTerms: [String] = ["애월 드라이브코스", "제주공항 맛집", "애월 카페거리", "서귀포 전시회", "유채꽃", "서귀포 맛집", "함덕 해수욕장", "흑돼지 맛집"]
		var placeString: String = "제주 감귤밭"
//		var searchAllCategoryResponse = SearchAllCategoryResponse(
//			festival: SearchDetailCategoryResponse(
//				count: 3,
//				data: [
//					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭"),
//					Article(id: 1, thumbnailUrl: "", title: "제주 감귤밭"),
//					Article(id: 2, thumbnailUrl: "", title: "제주 감귤밭")
//				]
//			), nature: SearchDetailCategoryResponse(
//				count: 0,
//				data: []
//			), experience: SearchDetailCategoryResponse(
//				count: 1,
//				data: [
//					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭")
//				]
//			), market: SearchDetailCategoryResponse(
//				count: 2,
//				data: [
//					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭"),
//					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭")
//				]
//			)
//		)
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
			switch category {
			case .all:
				resetData()
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
	
}
