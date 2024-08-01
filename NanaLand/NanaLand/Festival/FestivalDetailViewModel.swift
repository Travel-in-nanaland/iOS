//
//  FestivalDetailViewModel.swift
//  NanaLand
//
//  Created by jun on 5/16/24.
//

import Foundation

class FestivalDetailViewModel: ObservableObject {
    struct State {
        var getFestivalDetailResponse = FestivalDetailModel(id: 0, images: [DetailImagesList(originUrl: "", thumbnailUrl: "")], addressTag: "", title: "", content: "", address: "", contact: "", time: "", fee: "", homepage: "", period: "", favorite: false)
    }
    
    enum Action {
        case getFestivalDetailItem(id: Int64, isSearch: Bool)
        
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
        case let .getFestivalDetailItem(id, isSearch):
            let response = await FestivalDetailService.getFestivalDetailItem(id: id, isSearch: isSearch)
            if response != nil {
                await MainActor.run {
                    state.getFestivalDetailResponse = response!.data
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .festival)
            if response != nil {
                await MainActor.run {
                    state.getFestivalDetailResponse.favorite = response!.data.favorite
                }
            }
        }
    }
}
