//
//  RestaurantDetailViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

class RestaurantDetailViewModel: ObservableObject {
    struct State {
        var getRestaurantDetailResponse = RestaurantDetailModel(id: 0, title: "", originUrl: "", content: "", address: "", addressTag: "", contact: "", homepage: "", time: "", amenity: "", favorite: false, menu: [RestaurantDetailModel.Menu(name: "돈까스", price: "1000원", imageUrl: ""), RestaurantDetailModel.Menu(name: "돈까스", price: "1000원", imageUrl: ""), RestaurantDetailModel.Menu(name: "돈까스", price: "1000원", imageUrl: "")])
    }
    
    enum Action {
        case getRestaurantDetailItem(id: Int64)
        
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
        case let .getRestaurantDetailItem(id):
            let response = await RestaurantDetailService.getRestaurantDetailItem(id: id)
            
            if response != nil {
                await MainActor.run {
                    state.getRestaurantDetailResponse = response!.data
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .market)
            if response != nil {
                await MainActor.run {
                    state.getRestaurantDetailResponse.favorite =
                    response!.data.favorite
                }
            }
        }
    }
}
