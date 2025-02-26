//
//  NewNanaPickDetailViewModel.swift
//  NanaLand
//
//  Created by wodnd on 8/22/24.
//

import Foundation
class NewNanaPickDetailViewModel: ObservableObject {
    struct State {
        var getNanaPickDetailResponse = NewNanaPickDetailModel(id: 0, subHeading: "", heading: "", version: "", firstImage: NewNanaPickDetailImageList(originUrl: "", thumbnailUrl: ""), notice: "", nanaDetails: [NewDetailInfo(number: 0, subTitle: "", title: "", images: [NewNanaPickDetailImageList(originUrl: "", thumbnailUrl: "")], content: "", additionalInfoList: [NewAdditionalInfo(infoEmoji: "", infoKey: "", infoValue: "")], hashtags: [""])], favorite: true)
        var getKoreanAddress = ""
    }
    
    enum Action {
        case getNanaPickDetail(id: Int64)
        case toggleFavorite(body: FavoriteToggleRequest)
        case getKoreanAddress(id: Int64, category: String, number: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNanaPickDetail(id):
            if let response = await NewNanaPickDetailService.getNanaDetailItem(id: id) {
                if let responseData = response.data {
                    await MainActor.run {
                        state.getNanaPickDetailResponse = responseData
                        print(state.getNanaPickDetailResponse)
                    }
                } else {
                    print("Response data is nil")
                }
            } else {
                print("Error: Failed to get NanaPick recommendations")
            }
        case .toggleFavorite(body: let body):
            if let response = await FavoriteService.toggleFavorite(id: body.id, category: .nanaPick) {
                await MainActor.run {
                    state.getNanaPickDetailResponse.favorite = response.data.favorite
                }
            } else {
                print("Eror: response is nil")
            }
        case let .getKoreanAddress(id, category, number):
            let response = await AddressService.getKoreanAddress(id: id, category: category, number: number)
            if response != nil {
                print("주소: \(response)")
                state.getKoreanAddress = response?.data ?? ""
            } else {
                print("Error")
            }
        }
    }
}
