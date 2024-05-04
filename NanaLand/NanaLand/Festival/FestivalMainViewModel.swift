//
//  FestivalMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import Foundation

class FestivalMainViewModel: ObservableObject {
    struct State {
        var title = "지역12"
    }
    
    enum Action {
        case setTitle(title: String)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) {
        switch action {
        case let .setTitle(title):
            state.title = title
        }
    }
}
