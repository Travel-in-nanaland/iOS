//
//  RestaurantDetailService.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

struct RestaurantDetailService {
    static func getRestaurantDetailItem(id: Int64) async -> OldBaseResponse<RestaurantDetailModel>? {
        return await NetworkManager.shared.request(RestaurantDetailEndPoint.getRestaurantDetailItem(id: id))
    }
    
}
