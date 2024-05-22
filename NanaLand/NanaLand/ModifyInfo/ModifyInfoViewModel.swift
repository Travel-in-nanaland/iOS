//
//  ModifyInfoViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/8/24.
//

import Foundation

class ModifyInfoViewModel: ObservableObject {
	struct State {
		
	}
	
	enum Action {
		
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
	func action(_ action: Action) async {
		
	}
}
