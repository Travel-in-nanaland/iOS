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
        var getBannerResponse = [BannerModel(id: 0, thumbnailUrl: "", version: "", subHeading: "", heading: "")]
        var getRecommendResponse = [RecommendModel(id: 0, category: "", thumbnailUrl: "", title: "", introduction: "")]
    }
    
    enum Action {
        case getBannerItem
        case getRecommendItem
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
                    print("banner: \(response)")
                    if let responseData = response!.data {
                        state.getBannerResponse = responseData
                    } else {
                        state.getBannerResponse = [BannerModel(id: 1, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/nana'spick1_.png", version: "나나's Pick vol1", subHeading: "subheading1", heading: "heading1"), BannerModel(id: 2, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/nana'spick1_.png", version: "나나's Pick vol2", subHeading: "subheading2", heading: "heading2"), BannerModel(id: 3, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/nana'spick1_.png", version: "나나's Pick vol3", subHeading: "subheading3", heading: "heading3"), BannerModel(id: 4, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/nana'spick1_.png", version: "나나's Pick vol4", subHeading: "subheading4", heading: "heading4")]
                    }
                    
                }
            } else {
                print("Error")
            }
        case .getRecommendItem:
            let response = await HomeService.getRecommendData()
            if response != nil {
                await MainActor.run {
                    print("reco:\(response)")
                    if let responseData = response!.data {
                        state.getRecommendResponse = responseData
                    } else {
                        state.getRecommendResponse = [RecommendModel(id: 466, category: "NATURE", thumbnailUrl: "https://api.cdn.visitjeju.net/photomng/thumbnailpath/201804/30/5e8a2789-4812-418b-a542-ee68632f8565.jpg", title: "용머리해안", introduction: ""), RecommendModel(id: 479, category: "NATURE", thumbnailUrl: "https://api.cdn.visitjeju.net/photomng/thumbnailpath/202110/25/c725ba8d-6837-4d07-904a-0df9f56b1ff5.JPG", title: "쇠소깍", introduction: "")]
                    }
                    
                }
            }
        }
    }
}

