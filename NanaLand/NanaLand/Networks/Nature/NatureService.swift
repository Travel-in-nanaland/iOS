//
//  NatureService.swift
//  NanaLand
//
//  Created by jun on 5/2/24.
//

import Foundation

struct NatureService {
    static func getNatureMainItem(page: Int64, size: Int64, filterName: String) async -> BaseResponse<NatureMainModel>? {
        return await NetworkManager.shared.request(NatureEndPoint.getNatureMainItem(page: page, size: size, filterName: filterName))
    }
}
