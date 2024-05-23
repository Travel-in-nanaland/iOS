//
//  ReportInfoDTO.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import Foundation

struct ReportInfoRequest: Codable {
	let postId: Int64
	let fixType: String
	let category: String
	let content: String
	let email: String
}

struct ReportInfoResponse: Codable {
	let email: String
}

enum ReportInfoType: String {
	case numberAndHompage
	case placeNameAndLocation
	case operatinghour
	case priceInfo
	case deletePlace
	case provideService
	
	var name: String {
		switch self {
		case .numberAndHompage:
			return "CONTACT_OR_HOMEPAGE"
		case .placeNameAndLocation:
			return "LOCATION"
		case .operatinghour:
			return "TIME"
		case .priceInfo:
			return "PRICE"
		case .deletePlace:
			return "DELETE_LOCATION"
		case .provideService:
			return "ETC"
		}
	}
}

struct ReportInfoCategory: Hashable {
	let imageName: ImageResource
	let type: ReportInfoType
}
