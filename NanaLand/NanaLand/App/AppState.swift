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
	
	// 비회원이 회원가입 유도 팝업에서 X를 눌렀을때 이전 탭으로 돌아가기 위한 상태
	@Published var previousTab: Tab = .home
	// 비회원 alert 띄우기
	@Published var showRegisterInduction: Bool = false
}
