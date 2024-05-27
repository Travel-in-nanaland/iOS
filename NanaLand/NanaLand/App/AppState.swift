//
//  AppState.swift
//  NanaLand
//
//  Created by 정현우 on 4/20/24.
//

import SwiftUI

@MainActor
class AppState: ObservableObject {
	static let shared = AppState()
	
	@Published var currentTab: Tab = .home
  @Published var isTabViewHidden: Bool = false
	@Published var isRegisterNeeded = false
	
	// type test 띄우기
	@Published var showTypeTest: Bool = false
  
	// navigation Path
	@Published var navigationPath = NavigationPath()

	@Published var userInfo = ProfileMainModel(consentItems: [], email: "", provider: "", profileImageUrl: "", nickname: "", description: "", level: 0, travelType: "", hashtags: [""])
  
  // 비회원이 회원가입 유도 팝업에서 X를 눌렀을때 이전 탭으로 돌아가기 위한 상태
	@Published var previousTab: Tab = .home
	@Published var showRegisterInduction: Bool = false

}
