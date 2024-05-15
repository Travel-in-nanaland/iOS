//
//  NatureDetailService.swift
//  NanaLand
//
//  Created by jun on 5/3/24.
//

import Foundation

struct NatureDetailService {
    static func getNatureDetailItem(id: Int64) async -> BaseResponse<NatureDetailModel>? {
        return await NetworkManager.shared.request(NatureDetailEndPoint.getNatureDetailItem(id: id))
    }
    
}
