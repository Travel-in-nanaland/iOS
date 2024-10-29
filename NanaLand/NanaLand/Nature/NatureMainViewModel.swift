//
//  NatureMainViewModel.swift
//  NanaLand
//
//  Created by jun on 5/2/24.
//

import Foundation
class NatureMainViewModel: ObservableObject {
    struct State {
        var getNatureMainResponse = NatureMainModel(totalElements: 0, data: [])
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var page = 0
        var selectedLocation: [LocalizedKey] = []
    }
    
    enum Action {
        case getNatureMainItem(page: Int64, size: Int64, filterName: String)
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
        case let .getNatureMainItem(page, size, filterName):
            
            let response = await NatureService.getNatureMainItem(page: page, size: size, filterName: filterName)
            
            if response != nil {
                await MainActor.run {
                    print(filterName)
                    state.getNatureMainResponse.totalElements = response!.data.totalElements
                    state.getNatureMainResponse.data.append(contentsOf: response!.data.data)
                }
            } else {
                print("Erorr")
            }
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature)
            if response != nil {
                await MainActor.run {
                    state.getNatureMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}
