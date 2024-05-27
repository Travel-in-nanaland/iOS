//
//  HomeService.swift
//  NanaLand
//
//  Created by jun on 5/24/24.
//

import Foundation
import Alamofire
import SwiftUI

struct HomeService {
    static func getBannerData() async -> BaseResponse<[BannerModel]>? {
        return await NetworkManager.shared.request(HomeEndPoint.getBannerData)
    }
    
    static func getRecommendData() async -> BaseResponse<[RecommendModel]>? {
        return await NetworkManager.shared.request(HomeEndPoint.getRecommendData)
    }
}
