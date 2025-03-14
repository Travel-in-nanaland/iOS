//
//  NatureDetailViewModel.swift
//  NanaLand
//
//  Created by jun on 5/3/24.
//

import Foundation

class NatureDetailViewModel: ObservableObject {
    struct State {
        var getNatureDetailResponse = NatureDetailModel(id: 0, title: "", images: [DetailImagesList(originUrl: "", thumbnailUrl: "")], content: "", address: "", addressTag: "", contact: "", time: "", fee: "", details: "", amenity: "", favorite: false, intro: "")
        var getKoreanAddress = ""
    }
    
    enum Action {
        case getNatureDetailItem(id: Int64)
        
        case toggleFavorite(body: FavoriteToggleRequest)
        case getKoreanAddress(id: Int64, category: String)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNatureDetailItem(id):
            let response = await NatureDetailService.getNatureDetailItem(id: id)
            
            if response != nil {
                await MainActor.run {
                    state.getNatureDetailResponse = response!.data
                }
            } else {
                print("Error")
            }
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature)
            if response != nil {
                await MainActor.run {
                    state.getNatureDetailResponse.favorite = response!.data.favorite
                }
            }
        case let .getKoreanAddress(id, category):
            let response = await AddressService.getKoreanAddress(id: id, category: category, number: nil)
            if response != nil {
                print("주소: \(response)")
                state.getKoreanAddress = response?.data ?? ""
            } else {
                print("Error")
            }
        }
    }
}
