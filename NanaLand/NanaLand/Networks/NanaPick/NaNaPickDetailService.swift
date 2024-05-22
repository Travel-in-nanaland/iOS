//
//  NaNaPickDetailService.swift
//  NanaLand
//
//  Created by jun on 4/21/24.
//

import Foundation

struct NaNaPickDetailService {
    static func getNaNaPickDetail(id: Int64) async -> OldBaseResponse<NaNaPickDetailModel>? {
        return await NetworkManager.shared.request(NaNaPickDetailEndPoint.getNaNaPickDetail(id: id))
    }
}
