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
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var page = 0
        var selectedLocation: [LocalizedKey] = []
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
                    let newData = response!.data.data
                        
                        // 기존 데이터에서 중복되지 않는 항목만 추가
                        let uniqueData = newData.filter { newItem in
                            !state.getShopMainResponse.data.contains(where: { $0.id == newItem.id })
                        }
                        
                        state.getShopMainResponse.data.append(contentsOf: uniqueData)
                        state.getShopMainResponse.totalElements = response!.data.totalElements
                        print(state.getShopMainResponse.totalElements)
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
