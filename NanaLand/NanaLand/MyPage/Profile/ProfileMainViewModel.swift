//
//  ProfileMainViewModel.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import Foundation

class ProfileMainViewModel: ObservableObject {
    struct State {
		var getProfileMainResponse = ProfileMainModel(consentItems: [], email: "", provider: "", profileImageUrl: "", nickname: "", description: "", level: 0, travelType: "", hashtags: [""])
        
    }
    
    enum Action {
        case getUserInfo
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case .getUserInfo:
            let response = await UserInfoService.getUserInfo()
            if response != nil {
                await MainActor.run {
                    state.getProfileMainResponse = response!.data
                }
            }
        }
    }
}
