//
//  ExperienceService.swift
//  NanaLand
//
//  Created by juni on 7/16/24.
//

import Foundation

struct ExperienceService {
    // 메인 아이템 조회
    static func getExperienceMainItem(experienceType: String, keyword: String, address: String, page: Int, size: Int) async -> BaseResponse<ExperienceMainModel>? {
        return await NetworkManager.shared.request(ExperienceEndPoint.getExperienceMainItem(experienceType: experienceType, keyword: keyword, address: address, page: page, size: size))
    }
    // 상세 아이템 조회
    static func getExperienceDetailItem(id: Int64, isSearch: Bool) async -> BaseResponse<ExperienceDetailModel>? {
        return await
        NetworkManager.shared.request(ExperienceEndPoint.getExperienceDetailItem(id: id, isSearch: isSearch))
    }
    
}
