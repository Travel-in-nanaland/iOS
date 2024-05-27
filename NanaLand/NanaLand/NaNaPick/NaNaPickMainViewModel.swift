//
//  NaNaPickMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

class NaNaPickMainViewModel: ObservableObject {
    struct State {
        var getNaNaPickResponse = NaNaPickModel(data: [])
    }
    
    enum Action {
        case getNaNaPick(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNaNaPick(page, size):
            
            let data = await NaNaPickService.getNaNaPick(page: page, size: size)
           
            if data != nil {
                await MainActor.run {
                    state.getNaNaPickResponse.data.append(contentsOf: data!.data.data)
                }
            } else {
                print("Error")
            }
           
            
        }
    }
}
