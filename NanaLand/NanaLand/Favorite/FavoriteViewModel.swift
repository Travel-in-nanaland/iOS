//
//  FavoriteViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 4/21/24.
//

import Foundation

class FavoriteViewModel: ObservableObject {
	struct State {
		// dummy
		var articles: [Article] = [
			Article(id: 0, thumbnailUrl: "", title: "제주 감귤밭", favorite: true),
			Article(id: 1, thumbnailUrl: "", title: "제주 감귤밭", favorite: true),
			Article(id: 2, thumbnailUrl: "", title: "제주 감귤밭", favorite: true),
		]
	}
	
	enum Action {
		case getAllFavoriteList
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
}
