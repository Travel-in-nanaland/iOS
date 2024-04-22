//
//  HomeMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import Foundation
import Alamofire

class HomeMainViewModel: ObservableObject {
    @Published var recommendResponseData: RecommendModel?
    @Published var bannerResponseData:  BannerModel?
    let baseUrl = "http://13.125.110.80:8080"
    
    let headers: HTTPHeaders = [
        "Accept": "application/json",
        "Authorization": "Bearer \(Secrets.tempAccessToken)"
    ]
    
    // 추천 data 받아오는 함수
    func recommendFetchData() {
        
        AF.request("http://13.125.110.80:8080/member/recommended", headers: headers).responseDecodable(of: RecommendModel.self) { response in
            switch response.result {
            case .success(let data):
                self.recommendResponseData = data
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    // 배너 data 받아오는 함수
    func bannerFetchData() {
        
        AF.request("http://13.125.110.80:8080/nana", headers: headers).responseDecodable(of: BannerModel.self) { response in
            switch response.result {
            case .success(let data):
                self.bannerResponseData = data
               
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}
