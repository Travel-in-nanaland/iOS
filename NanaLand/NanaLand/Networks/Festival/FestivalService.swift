//
//  FestivalService.swift
//  NanaLand
//
//  Created by jun on 5/5/24.
//

import Foundation

struct FestivalService {
    static func getThisMonthFestivalMainItem(page: Int32, size: Int32, filterName: String, startDate: String, endDate: String) async -> OldBaseResponse<FestivalModel>? {
        return await NetworkManager.shared.request(FestivalEndPoint.thisMonthFestival(page: page, size: size, filterName: filterName, startDate: startDate, endDate: endDate))
        
    }
    
    static func getSeasonFestivalMainItem(page: Int32, size: Int32, season: String) async -> OldBaseResponse<FestivalModel>? {
        return await NetworkManager.shared.request(FestivalEndPoint.seasonFestival(page: page, size: size, season: season))
    }
    
    static func getPastFestivalMainItem(page: Int32, size: Int32, filterName: String) async -> OldBaseResponse<FestivalModel>? {
        return await NetworkManager.shared.request(FestivalEndPoint.pastFestival(page: page, size: size, filterName: filterName))
    }
}
