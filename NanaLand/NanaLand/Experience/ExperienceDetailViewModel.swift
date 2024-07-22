//
//  ExperienceDetailViewModel.swift
//  NanaLand
//
//  Created by juni on 7/19/24.
//

import Foundation

class ExperienceDetailViewModel: ObservableObject {
    struct State {
        var getExperienceDetailResponse = ExperienceDetailModel(id: 0, title: "", content: "", address: "", addressTag: "", contact: "", homepage: "", time: "", amenity: "", details: "", keywords: [""], images: [], favorite: false)
    }
    
    enum Action {
        case getExperienceDetailItem(id: Int64, isSearch: Bool)
        
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
        case let .getExperienceDetailItem(id, isSearch):
            let response = await ExperienceService.getExperienceDetailItem(id: id, isSearch: isSearch)
            if response != nil {
                await MainActor.run {
                    state.getExperienceDetailResponse = response!.data!
                    print(response!.data!)
                    print(response!.data!.images![1].thumbnailUrl)
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .experience)
            if response != nil {
                await MainActor.run {
                    state.getExperienceDetailResponse.favorite = response!.data.favorite
                }
            }
        }
    }
    
}
