//
//  HomeMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation
import Alamofire

class HomeMainViewModel: ObservableObject {
//    @Published var recommendResponseData: RecommendModel?
//    @Published var bannerResponseData:  BannerModel?
//    let baseUrl = "http://13.125.110.80:8080"
//
//    let headers: HTTPHeaders = [
//        "Accept": "application/json",
//        "Authorization": "Bearer \(Secrets.tempAccessToken)"
//    ]
//
//    // 추천 data 받아오는 함수
//    func recommendFetchData() {
//
//        AF.request("http://13.125.110.80:8080/member/recommended", headers: headers).responseDecodable(of: RecommendModel.self) { response in
//            switch response.result {
//            case .success(let data):
//                self.recommendResponseData = data
//            case .failure(let error):
//                print("Error fetching data: \(error)")
//            }
//        }
//    }
//    // 배너 data 받아오는 함수
//    func bannerFetchData() {
//
//        AF.request("http://13.125.110.80:8080/nana", headers: headers).responseDecodable(of: BannerModel.self) { response in
//            switch response.result {
//            case .success(let data):
//                self.bannerResponseData = data
//
//            case .failure(let error):
//                print("Error fetching data: \(error)")
//            }
//        }
//    }
    
    struct State {
        var getBannerResponse = [BannerModel]()
        var getRecommendResponse = [RecommendModel]()
        var getHotResponse = [HotModel]()
    }
    
    enum Action {
        case getBannerItem
        case getRecommendItem
        case toggleFavorite(body: FavoriteToggleRequest, index: Int)
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
            case "EXPERIENCE":
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .experience)
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
                let response = await FavoriteService.toggleFavorite(id: body.id, category: .nature)
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
        }
    }
}

