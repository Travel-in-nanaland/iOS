//
//  NewNanapickMainVeiwModel.swift
//  NanaLand
//
//  Created by wodnd on 8/21/24.
//

import Foundation
class NewNanaPickMainViewModel: ObservableObject {
    struct State {
        var getNanaPickRecommendResponse = [NewNanaPickMainModel(id: 0, firstImage: NewNanaPickImageList(originUrl: "", thumbnailUrl: ""), version: "", subHeading: "", heading: "", newest: true)]
        var getNanaPickGridResponse = NewNanaPickGridModel(totalElements: 0, data: [])
        var page = 0
    }
    
    enum Action {
        case getNanaPickRecommend
        case getNanaPickGridList(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNanaPickRecommend:
            if let response = await NewNanaPickService.getNanaPickRecommend() {
                if let responseData = response.data {
                    await MainActor.run {
                        state.getNanaPickRecommendResponse = responseData
                        print(state.getNanaPickRecommendResponse)
                    }
                } else {
                    print("Response data is nil")
                }
            } else {
                print("Error: Failed to get NanaPick recommendations")
            }
        case let .getNanaPickGridList(page, size):
            if let response = await NewNanaPickService.getNanaPickGridList(page: page, size: size) {
                if let responseData = response.data {
                    await MainActor.run {
                        state.getNanaPickGridResponse.totalElements = responseData.totalElements
                        state.getNanaPickGridResponse.data.append(contentsOf: response.data?.data ?? [])
                        print(state.getNanaPickGridResponse)
                    }
                } else {
                    print("Response data is nil")
                }
            } else {
                print("Error: Failed to get NanaPick Grid List")
            }
        }
    }
}
