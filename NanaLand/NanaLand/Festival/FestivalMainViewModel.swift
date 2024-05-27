//
//  FestivalMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import Foundation

class FestivalMainViewModel: ObservableObject {
    struct State {
        var getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
        var title = ""
        
    }
    
    enum Action {
        case getThisMonthFestivalMainItem(page: Int32, size: Int32, filterName: String, startDate: String, endDate: String)
        
        case getSeasonFestivalMainItem(page: Int32, size: Int32, season: String)
        
        case getPastFestivalMainItem(page: Int32, size: Int32, filterName: String)
        // 좋아요 토글
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
            
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .festival)
            if response != nil {
                await MainActor.run {
                    state.getFestivalMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        case let .getThisMonthFestivalMainItem(page, size, filterName, startDate, endDate):
            let response = await FestivalService.getThisMonthFestivalMainItem(page: page, size: size, filterName: filterName, startDate: startDate, endDate: endDate)
            if response != nil {
                await MainActor.run {
                    state.getFestivalMainResponse.data = response!.data.data
                    state.title = "이번달"
                    
                }
            }
        case .getSeasonFestivalMainItem(page: let page, size: let size, season: let season):
            let response = await FestivalService.getSeasonFestivalMainItem(page: page, size: size, season: season)
            if response != nil {
                await MainActor.run {
                    state.getFestivalMainResponse.data = response!.data.data
                    state.title = "계절별"
                }
            }
        case .getPastFestivalMainItem(page: let page, size: let size, filterName: let filterName):
            let response = await FestivalService.getPastFestivalMainItem(page: page, size: size, filterName: filterName)
            if response != nil {
                await MainActor.run {
                    state.getFestivalMainResponse.data = response!.data.data
                    state.title = "종료된"
                }
            }
        }
    }
}
