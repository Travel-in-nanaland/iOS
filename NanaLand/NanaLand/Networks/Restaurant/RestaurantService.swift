//
//  RestaurantService.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

struct RestaurantService {
    static func getRestaurantMainItem(page: Int64, size: Int64, filterName: String) async -> OldBaseResponse<RestaurantMainModel>? {
        return await NetworkManager.shared.request(RestaurantEndPoint.getRestaurantMainItem(page: page, size: size, filterName: filterName))
    }
}
