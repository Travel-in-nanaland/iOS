//
//  NoticeDetailViewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/1/24.
//

import Foundation
class NoticeDetailViewModel: ObservableObject {
    struct State {
        var getNoticeDetailResponse = NoticeDetailModel(title: "", createdAt: "", noticeContents: [Notice(image: NoticeDetailImagesList(originUrl: "", thumbnailUrl: ""), content: "")])
    }
    
    enum Action {
        case getNoticeDetailItem(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNoticeDetailItem(id):
            if let response = await NoticeService.getNoticeDetailItem(id: id){
                if let data = response.data {
                    await MainActor.run {
                        state.getNoticeDetailResponse = data
                        print(data)
                    }
                } else {
                    print("Data is nil")
                }
            } else {
                print("Error: response is nil")
            }
        }
    }
}
