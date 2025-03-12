//
//  FestivalMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import Foundation
import SwiftUICalendar

class FestivalMainViewModel: ObservableObject {
    struct State {
        var getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
        var title = ""
        var page = 0
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var selectedLocation: [LocalizedKey] = []
        var selectedSeason = ""
        var selectedStartDate: YearMonthDay? = .current
        var selectedEndDate: YearMonthDay? = .current
        
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
                    // 기존 데이터의 ID를 Set으로 추출
                    let existingIDs = Set(self.state.getFestivalMainResponse.data.map { $0.id })
                    
                    // 새 데이터 중 기존 데이터에 없는 항목만 필터링
                    let filteredData = response!.data.data.filter { !existingIDs.contains($0.id) }
                    
                    // 필터링된 데이터를 추가
                    state.getFestivalMainResponse.data.append(contentsOf: filteredData)
                    
                    // totalElements는 API에서 반환된 값을 그대로 사용
                    state.getFestivalMainResponse.totalElements = response!.data.totalElements
                    state.title = "이번달"
                }
            }
        case .getSeasonFestivalMainItem(page: let page, size: let size, season: let season):
            let response = await FestivalService.getSeasonFestivalMainItem(page: page, size: size, season: season)
            if response != nil {
                await MainActor.run {
                    // 기존 데이터의 ID를 Set으로 추출
                    let existingIDs = Set(self.state.getFestivalMainResponse.data.map { $0.id })
                    
                    // 새 데이터 중 기존 데이터에 없는 항목만 필터링
                    let filteredData = response!.data.data.filter { !existingIDs.contains($0.id) }
                    
                    // 필터링된 데이터를 추가
                    state.getFestivalMainResponse.data.append(contentsOf: filteredData)
                    
                    // totalElements는 API에서 반환된 값을 그대로 사용
                    state.getFestivalMainResponse.totalElements = response!.data.totalElements
                    state.title = "계절별"
                    print(response?.data.data)
                }
            }
        case .getPastFestivalMainItem(page: let page, size: let size, filterName: let filterName):
            let response = await FestivalService.getPastFestivalMainItem(page: page, size: size, filterName: filterName)
            if response != nil {
                await MainActor.run {
                    // 기존 데이터의 ID를 Set으로 추출
                    let existingIDs = Set(self.state.getFestivalMainResponse.data.map { $0.id })
                    
                    // 새 데이터 중 기존 데이터에 없는 항목만 필터링
                    let filteredData = response!.data.data.filter { !existingIDs.contains($0.id) }
                    
                    // 필터링된 데이터를 추가
                    state.getFestivalMainResponse.data.append(contentsOf: filteredData)
                    
                    // totalElements는 API에서 반환된 값을 그대로 사용
                    state.getFestivalMainResponse.totalElements = response!.data.totalElements
                    state.title = "종료된"
                    print(response)
                }
            }
        }
    }
}

