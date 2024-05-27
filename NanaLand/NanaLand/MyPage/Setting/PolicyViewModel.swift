//
//  PolicyViewModel.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import Foundation

class PolicyViewModel: ObservableObject {
    struct State {
        var marketingAgree = false
        var gpsAgree = false
    }
    
    enum Action {
        case marketingAgreeToggle
        case gpsAgreeToggle
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) {
        switch action {
        case .marketingAgreeToggle:
            state.marketingAgree.toggle()
        case .gpsAgreeToggle:
            state.gpsAgree.toggle()
        }
    }
    
}
