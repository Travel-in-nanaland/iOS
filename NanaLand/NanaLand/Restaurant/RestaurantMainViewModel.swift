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
        var selectedKeyword: [String] = []
        var selectedLocation: [LocalizedKey] = []
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
            // TODO - 제주맛집 API 호출
            if let response = await RestaurantService.getRestaurantMainItem(keyword: keyword, address: address, page: page, size: size),
               let responseData = response.data {
                await MainActor.run {
                    print(response)
                    state.getRestaurantMainResponse.totalElements = responseData.totalElements
                    state.getRestaurantMainResponse.data = responseData.data
                    print(state.getRestaurantMainResponse.totalElements)
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .restaurant)
            if response != nil {
                await MainActor.run {
                    state.getRestaurantMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}

