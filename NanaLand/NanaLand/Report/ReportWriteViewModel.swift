//
//  ReportWriteViewModel.swift
//  NanaLand
//
//  Created by juni on 8/25/24.
//

import Foundation

class ReportWriteViewModel: ObservableObject {
    
    struct State {
        var imgCnt = 0
        var getReportResponse = ReportModel(status: 0, message: "")
        var reportDTO = ReportDTO(id: nil, reportType: "REVIEW", claimType: nil, content: nil, email: "duthd3@naver.com")
    }
    
    enum Action {
        case postReport(body: ReportDTO, multipartFile: [Foundation.Data?])
    }
    
    @Published var state: State

    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func updateImageCount(_ count: Int) {
        state.imgCnt = count
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .postReport(body, multipartFile):
            let response = await ReportService.postReport(body: body, multipartFile: multipartFile)
            if response != nil {
                await MainActor.run {
                    state.getReportResponse.status = response!.status
                    print(response!.message)
                }
            }
        }
    }
}
