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
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var selectedKeyword: [String] = []
        var selectedLocation: [LocalizedKey] = []
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
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
           print(keyword)
            // TODO - 제주맛집 API 호출
            if let response = await RestaurantService.getRestaurantMainItem(keyword: keyword, address: address, page: page, size: size),
               let responseData = response.data {
                await MainActor.run {
                    print(response)
                    // 기존 데이터의 ID를 Set으로 추출
                    let existingIDs = Set(self.state.getRestaurantMainResponse.data.map { $0.id })
                    
                    // 새 데이터 중 기존 데이터에 없는 항목만 필터링
                    let filteredData = responseData.data.filter { !existingIDs.contains($0.id) }
                    
                    // 필터링된 데이터를 추가
                    state.getRestaurantMainResponse.data.append(contentsOf: filteredData)
                    
                    // totalElements는 API에서 반환된 값을 그대로 사용
                    state.getRestaurantMainResponse.totalElements = responseData.totalElements
                
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

