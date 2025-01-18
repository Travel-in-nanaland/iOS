//
//  HomeViewType.swift
//  NanaLand
//
//  Created by 정현우 on 5/23/24.
//

import Foundation

enum HomeViewType: Hashable {
	case search
	case nature
	case festival
	case shop
    case activity
    case cultureAndArts
	case nanapick
	case natureDetail(id: Int)
	case shopDetail(id: Int)
	case festivalDetail(id: Int)
	case notification
    case restaurant
    case activityDetail(id: Int)
    case cultureAndArtsDetail(id: Int)
    case restaurantDetail(id: Int)
}
