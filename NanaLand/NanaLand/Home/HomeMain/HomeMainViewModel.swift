//
//  HomeMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation
import Alamofire

class HomeMainViewModel: ObservableObject {
    
    struct State {
        var getBannerResponse = [BannerModel]()
        var getRecommendResponse = [RecommendModel]()
        var getHotResponse = [HotModel]()
    }
    
    enum Action {
        case getBannerItem
        case getRecommendItem
        case toggleFavorite(body: FavoriteToggleRequest, index: Int)
        case hotItemToggleFavorite(body: FavoriteToggleRequest, index: Int)
        case getHotItem
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case .getBannerItem:
            let response = await HomeService.getBannerData()
            if response != nil {
                await MainActor.run {
                    state.getBannerResponse = response?.data ?? []
                }
            } else {
                print("Error")
            }
        case .getRecommendItem:
            let response = await HomeService.getRecommendData()
            if response != nil {
                await MainActor.run {
                    state.getRecommendResponse = response?.data ?? []
                    print(state.getRecommendResponse)
                }
            }
        case .toggleFavorite(body: let body, index: let index):
            
            switch body.category {
            case "NATURE":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            case "FESTIVAL":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .festival)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            case "MARKET":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .market)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            case "ACTIVITY":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .activity)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            case "CULTURE_AND_ARTS":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .cultureAndArts)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            case "RESTAURANT":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .restaurant)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            default:
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .activity)
                if response != nil {
                    await MainActor.run {
                        state.getRecommendResponse[index].favorite = response!.data.favorite
                    }
                }
            }
        case .getHotItem:
            let response = await HomeService.getHotItem()
            if response != nil {
                await MainActor.run {
                    state.getHotResponse = response!.data ?? []
                }
            }
        case .hotItemToggleFavorite(body: let body, index: let index):
            switch body.category {
            case "NATURE":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            case "FESTIVAL":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .festival) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            case "MARKET":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .market) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            case "ACTIVITY":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .activity) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            case "CULTURE_AND_ARTS":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .cultureAndArts) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            case "RESTAURANT":
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .restaurant) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            default:
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .activity) {
                    await MainActor.run {
                        state.getHotResponse[index].favorite = response.data.favorite
                    }
                }
            }
            
        }
        

    }
}

