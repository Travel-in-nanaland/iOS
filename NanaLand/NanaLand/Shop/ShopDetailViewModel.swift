//
//  ShopDetailViewModel.swift
//  NanaLand
//
//  Created by jun on 4/29/24.
//

import Foundation

class ShopDetailViewModel: ObservableObject {
    struct State {
        var getShopDetailResponse = ShopDetailModel(id: 0, title: "", originUrl: "", content: "", address: "", addressTag: "", contact: "", homepage: "", time: "", amenity: "", favorite: false)
    }
    
    enum Action {
        case getShopDetailItem(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getShopDetailItem(id):
            let response = await ShopDetailService.getShopDetailItem(id: id)
            
            if response != nil {
                await MainActor.run {
                    state.getShopDetailResponse = response!.data
                }
            } else {
                print("Error")
            }
        }
    }
}
