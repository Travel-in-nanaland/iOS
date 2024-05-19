//
//  ShopService.swift
//  NanaLand
//
//  Created by jun on 4/26/24.
//

import Foundation

struct ShopService {
    static func getShopMainItem(page: Int64, size: Int64, filterName: String) async -> OldBaseResponse<ShopMainModel>? {
        return await NetworkManager.shared.request(ShopEndPoint.getShopMainItem(page: page, size: size, filterName: filterName))
    }
}
