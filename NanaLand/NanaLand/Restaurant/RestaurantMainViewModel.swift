//
//  RestaurantMainViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation
class RestaurantMainViewModel: ObservableObject {
    struct State {
        var getRestaurantMainResponse = RestaurantMainModel(totalElements: 0, data: [])
        var location = ""
        var keyword = ""
        var page = 0
    }
    
    enum Action {
        case getRestaurantMainItem(page: Int64, size: Int64, filterName: String)
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
        case let .getRestaurantMainItem(page, size, filterName):
            
            let response = await RestaurantService.getRestaurantMainItem(page: page, size: size, filterName: filterName)
            
            if response != nil {
                await MainActor.run {
                    print(filterName)
                    state.getRestaurantMainResponse.totalElements = response!.data.totalElements
                    state.getRestaurantMainResponse.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Erorr")
            }
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature)
            if response != nil {
                await MainActor.run {
                    state.getRestaurantMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}
