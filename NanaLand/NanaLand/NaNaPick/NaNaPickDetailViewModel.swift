//
//  NaNaPickDetailViewModel.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation

class NaNaPickDetailViewModel: ObservableObject {
    struct State {
        var getNaNaPickDetailResponse = NaNaPickDetailModel(originUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/4.png", notice: nil, nanaDetails: [DetailInfo(number: 1, subTitle: "sub1", title: "title12345", imageUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/1.png", content: "content1", additionalInfoList: [AdditionalInfo(infoEmoji: "", infoKey: "주차", infoValue: "없음"), AdditionalInfo(infoEmoji: "",infoKey: "주소", infoValue: "제주도")], hashtags: ["ex1", "ex2"])])
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
                    state.getNaNaPickDetailResponse = data!.data
                }
            } else {
                print("Error")
            }
        }
    }
}
