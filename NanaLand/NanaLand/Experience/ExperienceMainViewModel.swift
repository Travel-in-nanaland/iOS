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
        var location = ""
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
            // TODO - 이색체험 API 호출
            let response = await ExperienceService.getExperienceMainItem(experienceType: experienceType, keyword: "", address: "", page: 0, size: 12)
            if response != nil {
                await MainActor.run {
                    print(response)
                    state.getExperienceMainResponse.totalElements = response!.data?.totalElements ?? 0
                    state.getExperienceMainResponse.data = response!.data!.data
                    print(state.getExperienceMainResponse.totalElements)
                }
            } else {
                print("Error")
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
