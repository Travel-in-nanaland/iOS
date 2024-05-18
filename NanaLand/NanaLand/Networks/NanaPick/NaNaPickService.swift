//
//  NaNaPickService.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

struct NaNaPickService {
    static func getNaNaPick(page: Int, size: Int) async -> OldBaseResponse<NaNaPickModel>? {
        return await NetworkManager.shared.request(NaNaPickEndPoint.getNaNaPick(page: page, size: size))
        
    }
}
