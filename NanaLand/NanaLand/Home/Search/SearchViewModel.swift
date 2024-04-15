//
//  SearchViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import Foundation
import SwiftUI

final class SearchViewModel: ObservableObject {
	struct State {
		var searchTerm: String
		
		// dummy
		var recentSearchTerms: [String] = ["제주시", "제주 드라이브", "서귀포 놀거리", "나나랜드"]
		var popularSearchTerms: [String] = ["애월 드라이브코스", "제주공항 맛집", "애월 카페거리", "서귀포 전시회", "유채꽃", "서귀포 맛집", "함덕 해수욕장", "흑돼지 맛집"]
		var placeString: String = "제주 감귤밭"
	}
	
	enum Action {
		case onChangeSearchTerm(String)
	}
	
	@Published var state: State
	
	init(
		state: State = .init(
			searchTerm: ""
		)
	) {
		self.state = state
	}
	
	func action(_ action: Action) {
		switch action {
		case let .onChangeSearchTerm(newValue):
			state.searchTerm = newValue
		}
	}
}
