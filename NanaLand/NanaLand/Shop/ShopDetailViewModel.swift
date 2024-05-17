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
        
        case toggleFavorite(body: FavoriteToggleRequest)
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
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .market)
            if response != nil {
                await MainActor.run {
                    state.getShopDetailResponse.favorite =
                    response!.data.favorite
                }
            }
        }
    }
}
