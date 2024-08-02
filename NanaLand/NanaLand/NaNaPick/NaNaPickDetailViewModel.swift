//
//  NaNaPickDetailViewModel.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation

class NaNaPickDetailViewModel: ObservableObject {
    struct State {
        var getNaNaPickDetailResponse = NaNaPickDetailModel(subHeading: "", heading: "", version: "", firstImage: NanaPickDetailImageList(originUrl: "", thumbnailUrl: ""), notice: "", nanaDetails: [DetailInfo(number: 3, subTitle: "", title: "", images: [NanaPickDetailImageList(originUrl: "", thumbnailUrl: "")], content: "", additionalInfoList: [AdditionalInfo(infoEmoji: "", infoKey: "", infoValue: "")], hashtags: [""])], favorite: true)
    }
    
    enum Action {
        case getNaNaPickDetail(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNaNaPickDetail(id):
            let data = await NaNaPickDetailService.getNaNaPickDetail(id: id)
            
            if data != nil {
                await MainActor.run {
                    print("api 연결 성공: \(data!.data)")
                    state.getNaNaPickDetailResponse = data!.data
                }
            } else {
                print("Error")
            }
        }
    }
}
