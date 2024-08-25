//
//  NewNanaPickService.swift
//  NanaLand
//
//  Created by wodnd on 8/21/24.
//

import Foundation
struct NewNanaPickService {
    static func getNanaPickRecommend() async -> BaseResponse<[NewNanaPickMainModel]>? {
        return await NetworkManager.shared.request(NewNanaPickEndPoint.getNanaPickRecommend)
    }
    
    static func getNanaPickGridList(page: Int, size: Int) async -> BaseResponse<NewNanaPickGridModel>? {
        return await NetworkManager.shared.request(NewNanaPickEndPoint.getNanaPickGridList(page: page, size: size))
    }
}
