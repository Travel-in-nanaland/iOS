//
//  NotificationViewModel.swift
//  NanaLand
//
//  Created by juni on 8/28/24.
//

import Foundation

class NotificationViewModel: ObservableObject {
    struct State {
        var getNotificationResponse = NotificationModel(totalElements: 0, data: [])
        var page = 0
    }
    
    enum Action {
        case getNotificationItem(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNotificationItem(page, size):
            let response = await NotificationService.getNotification(page: page, size: size)
            if response != nil {
                await MainActor.run {
                    state.getNotificationResponse = response!.data ?? NotificationModel(totalElements: 0, data: [])
                }
            }
        }
    }
}
