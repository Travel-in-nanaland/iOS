//
//  AppState.swift
//  NanaLand
//
//  Created by 정현우 on 4/20/24.
//

import SwiftUI

class AppState: ObservableObject {
	@Published var currentTab: Tab = .home
    @Published var isTabViewHidden: Bool = false
	@Published var isRegisterNeeded = false
    @Published var userInfo = ProfileMainModel(email: "", provider: "", profileImageUrl: "", nickname: "", description: "", level: 0, travelType: "", hashtags: [""])
}


