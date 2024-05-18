//
//  FestivalDetailService.swift
//  NanaLand
//
//  Created by jun on 5/16/24.
//

import Foundation

struct FestivalDetailService {
    static func getFestivalDetailItem(id: Int64, isSearch: Bool) async -> OldBaseResponse<FestivalDetailModel>? {
        return await NetworkManager.shared.request(FestivalDetailEndPoint.getFestivalDetailItem(id: id, isSearch: isSearch))
    }
    
}
