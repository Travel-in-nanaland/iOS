//
//  ExperienceMainViewModel.swift
//  NanaLand
//
//  Created by juni on 7/15/24.
//

import Foundation

class ExperienceMainViewModel: ObservableObject {
    struct State {
        var getExperienceMainResponse = ExperienceMainModel(totalElements: 0, data: [])
        var page = 0
        var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var apiLocation = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
        var selectedKeyword: [String] = []
        var selectedLocation: [LocalizedKey] = []
    }
    
    enum Action {
        case getExperienceMainItem(experienceType: String, keyword: String, address: String, page: Int, size: Int)
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
        case let .getExperienceMainItem(experienceType, keyword, address, page, size):
            // TODO: - 이색체험 API 호출
            
            let response = await ExperienceService.getExperienceMainItem(experienceType: experienceType, keyword: keyword, address: address, page: page, size: size)
            if let responseData = response?.data {
                await MainActor.run {
                    let existingIDs = Set(self.state.getExperienceMainResponse.data.map { $0.id })
                    
                    // 새 데이터 중 기존 데이터에 없는 항목만 필터링
                    let filteredData = responseData.data.filter { !existingIDs.contains($0.id) }
                    
                    // 필터링된 데이터를 추가
                    state.getExperienceMainResponse.data.append(contentsOf: filteredData)
                    
                    // totalElements는 API에서 반환된 값을 그대로 사용
                    state.getExperienceMainResponse.totalElements = responseData.totalElements
                    print(state.getExperienceMainResponse.totalElements)
                }
            } else {
                // response.data가 nil인 경우 처리
                await MainActor.run {
                    print("Error: response data is nil")
                }
            }
            
        case .toggleFavorite(body: let body, index: let index):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .experience)
            if response != nil {
                await MainActor.run {
                    state.getExperienceMainResponse.data[index].favorite = response!.data.favorite
                }
            }
        }
    }
}
