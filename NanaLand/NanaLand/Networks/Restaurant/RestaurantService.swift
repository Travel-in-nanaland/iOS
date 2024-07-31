//
//  RestaurantService.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

struct RestaurantService {
    static func getRestaurantMainItem(keyword: String, address: String, page: Int, size: Int) async -> BaseResponse<RestaurantMainModel>? {
        return await NetworkManager.shared.request(RestaurantEndPoint.getRestaurantMainItem(keyword: keyword, address: address, page: page, size: size))
    }
    
    static func getRestaurantDetailItem(id: Int64, isSearch: Bool) async -> BaseResponse<RestaurantDetailModel>? {
        return await
        NetworkManager.shared.request(RestaurantEndPoint.getRestaurantDetailItem(id: id, isSearch: isSearch))
    }
}
