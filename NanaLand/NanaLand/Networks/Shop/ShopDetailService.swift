//
//  ShopDetailService.swift
//  NanaLand
//
//  Created by jun on 4/29/24.
//

import Foundation

struct ShopDetailService {
    static func getShopDetailItem(id: Int64) async -> BaseResponse<ShopDetailModel>? {
        return await NetworkManager.shared.request(ShopDetailEndPoint.getShopDetailItem(id: id))
    }
}
