//
//  NoticeMainViewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation
class NoticeMainViewModel: ObservableObject {
    struct State {
        var getNoticeMainResponse = NoticeMainModel(totalElements: 0, data: [])
        var page = 0
        var size = 12
    }
    
    enum Action {
        case getNoticeMainItem(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNoticeMainItem(page, size):
            // TODO - 공지사항 API 호출
            let response = await NoticeService.getNoticeMainItem(page: 0, size: 12)
            if response != nil {
                await MainActor.run {
                    print(response)
                    state.getNoticeMainResponse.totalElements = response!.data?.totalElements ?? 0
                    state.getNoticeMainResponse.data = response!.data!.data
                    print(state.getNoticeMainResponse.totalElements)
                }
            } else {
                print("Error")
            }
        }
    }
}

