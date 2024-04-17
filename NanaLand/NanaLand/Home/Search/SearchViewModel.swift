//
//  SearchViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import Foundation
import SwiftUI
import Alamofire

final class SearchViewModel: ObservableObject {
	struct State {		
		var currentSearchTab: Category = .all
		// dummy
		var recentSearchTerms: [String] = ["제주시", "제주 드라이브", "서귀포 놀거리", "나나랜드"]
		var popularSearchTerms: [String] = ["애월 드라이브코스", "제주공항 맛집", "애월 카페거리", "서귀포 전시회", "유채꽃", "서귀포 맛집", "함덕 해수욕장", "흑돼지 맛집"]
		var placeString: String = "제주 감귤밭"
		var searchAllResponse = SearchAllCategoryResponse(
			festival: ArticlesWithCount(
				count: 3,
				data: [
					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭"),
					Article(id: 1, thumbnailUrl: "", title: "제주 감귤밭"),
					Article(id: 2, thumbnailUrl: "", title: "제주 감귤밭")
				]
			), nature: ArticlesWithCount(
				count: 0,
				data: []
			), experience: ArticlesWithCount(
				count: 1,
				data: [
					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭")
				]
			), market: ArticlesWithCount(
				count: 2,
				data: [
					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭"),
					Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭")
				]
			)
		)
	}
	
	enum Action {
		case searchTerm(String)
		case searchDetailByCategory(Category, String)
	}
	
	@Published var state: State
	
	init(
		state: State = .init(
//			searchTerm: ""
		)
	) {
		self.state = state
	}
	
	func action(_ action: Action) {
		
	}
	
}
