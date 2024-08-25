//
//  NewNanaPickDetailService.swift
//  NanaLand
//
//  Created by wodnd on 8/23/24.
//

import Foundation
struct NewNanaPickDetailService {
    static func getNanaDetailItem(id: Int64) async -> BaseResponse<NewNanaPickDetailModel>? {
        return await NetworkManager.shared.request(NewNanaPickDetailEndPoint.getNewNanaPickDetail(id: id))
    }

}
