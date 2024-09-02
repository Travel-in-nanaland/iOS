//
//  TypeTestProfileViewModel.swift
//  NanaLand
//
//  Created by wodnd on 9/1/24.
//

import Foundation

class TypeTestProfileViewModel: ObservableObject {
    struct State {
        var recommendPlace: [RecommendModel] = []
    }
    
    enum Action {
        case getRecommendPlace
    }
    
    @Published var state: State
    
    init(state: State = .init()) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case .getRecommendPlace:
            let response = await HomeService.getRecommendDataInTypeTest()
            if let data = response?.data {
                // Ensure that UI updates happen on the main thread
                DispatchQueue.main.async {
                    self.state.recommendPlace = data
                    print(data)
                }
            }
        }
    }
}
