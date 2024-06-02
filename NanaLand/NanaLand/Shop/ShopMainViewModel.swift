//
//  ShopMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/26/24.
//

import Foundation

class ShopMainViewModel: ObservableObject {
    struct State {
        var getShopMainResponse = ShopMainModel(totalElements: 0, data: [])
        var location = ""
        var page = 0
    }
    
    enum Action {
        case getShopMainItem(page: Int64, size: Int64, filterName: String)
        case toggleFavorite(body: FavoriteToggleRequest, index: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getShopMainItem(page, size, filterName):
            
            let response = await ShopService.getShopMainItem(page: page, size: size, filterName: filterName)
            
            if response != nil {
                await MainActor.run {
                    state.getShopMainResponse.totalElements = response!.data.totalElements
                    state.getShopMainResponse.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Erorr")
            }
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .market)
            if response != nil {
                await MainActor.run {
                    state.getShopMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}
