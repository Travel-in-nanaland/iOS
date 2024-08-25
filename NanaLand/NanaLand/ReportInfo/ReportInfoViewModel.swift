//
//  ReportInfoViewModel.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import Foundation

@MainActor
class ReportInfoViewModel: ObservableObject {
	struct State {
		var postId: Int64 = 0
		var category: Category = .experience
		var fixType: ReportInfoType = .priceInfo
		
		var showEmailErrorMessage: Bool = false
		
		var isLoading: Bool = false
	}
	
	enum Action {
		case onTapReportItem(type: ReportInfoType)
		case onTapSendButton(image: [Foundation.Data?], content: String, email: String)
		case onTapGoToContentButton
		case onTapReportAgainButton
	}
	
	@Published var state: State
    @Published var imageCnt: Int = 0
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
    func updateImageCount(_ count: Int) {
        imageCnt = count
    }
    
	func action(_ action: Action) async {
		switch action {
		case .onTapReportItem(let type):
			reportItemTapped(type: type)
		case let .onTapSendButton(image, content, email):
			await sendButtonTapped(image: image, content: content, email: email)
		case .onTapGoToContentButton:
			gotoContentButtonTapped()
		case .onTapReportAgainButton:
			reportAgainButtonTapped()
		}
	}
	
	func reportItemTapped(type: ReportInfoType) {
		state.fixType = type
		AppState.shared.navigationPath.append(ReportInfoViewType.reportWriting)
	}
	
	func sendButtonTapped(image: [Foundation.Data?], content: String, email: String) async {
		state.showEmailErrorMessage = false
		guard email.isValidEmail() else {
			state.showEmailErrorMessage = true
			return
		}
		let request = ReportInfoRequest(
			postId: state.postId,
			fixType: state.fixType.name,
			category: state.category.uppercase,
			content: content,
			email: email
		)
		state.isLoading = true
		let result = await ReportInfoService.postInfoFixReport(body: request, image: image)
		state.isLoading = false
		
		if result?.status == 200 {
			AppState.shared.navigationPath.append(ReportInfoViewType.reportResult)
		} else if result?.status == 400 {
			state.showEmailErrorMessage = true
		}
	}
	
	func gotoContentButtonTapped() {
		AppState.shared.navigationPath.removeLast(3)
	}
	
	func reportAgainButtonTapped() {
		state.showEmailErrorMessage = false
		AppState.shared.navigationPath.removeLast(2)
	}
}
