//
//  AddressService.swift
//  NanaLand
//
//  Created by wodnd on 2/24/25.
//

import Foundation

struct AddressService {

    static func getKoreanAddress(id: Int64, category: String, number: Int64?) async -> BaseResponse<String>? {
        return await NetworkManager.shared.request(AddressEndPoint.getKoreanAddress(id: id, category: category, number: number))
    }
}
