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
        var page = 0
        var location = ""
    }
    
    enum Action {
        case getRestaurantMainItem(keyword: String, address: String, page: Int, size: Int)
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
        case let .getRestaurantMainItem(keyword, address, page, size):
            // TODO - 이색체험 API 호출
            let response = await RestaurantService.getRestaurantMainItem(keyword: "", address: "", page: 0, size: 12)
            if response != nil {
                await MainActor.run {
                    print(response)
                    state.getRestaurantMainResponse.totalElements = response!.data?.totalElements ?? 0
                    state.getRestaurantMainResponse.data = response!.data!.data
                    print(state.getRestaurantMainResponse.totalElements)
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .experience)
            if response != nil {
                await MainActor.run {
                    state.getRestaurantMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}

