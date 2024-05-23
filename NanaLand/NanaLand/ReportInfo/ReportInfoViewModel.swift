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
		var postId: Int = 0
		var category: Category = .experience
		var fixType: ReportInfoType = .priceInfo
	}
	
	enum Action {
		case onTapReportItem(type: ReportInfoType)
		case onTapSendButton(image: [Foundation.Data?], content: String, email: String)
	}
	
	@Published var state: State
	
	init(
		state: State = .init()
	) {
		self.state = state
	}
	
	func action(_ action: Action) async {
		switch action {
		case .onTapReportItem(let type):
			reportItemTapped(type: type)
		case let .onTapSendButton(image, content, email):
			await sendButtonTapped(image: image, content: content, email: email)
		}
	}
	
	func reportItemTapped(type: ReportInfoType) {
		state.fixType = type
		AppState.shared.navigationPath.append(ReportInfoViewType.reportWriting)
	}
	
	func sendButtonTapped(image: [Foundation.Data?], content: String, email: String) async {
		let request = ReportInfoRequest(
			postId: state.postId,
			fixType: state.fixType.name,
			category: state.category.uppercase,
			content: content,
			email: email
		)
		
		let result = await ReportInfoService.postInfoFixReport(body: request, image: image)
	}
}
