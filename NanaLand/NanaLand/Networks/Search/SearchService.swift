//
//  SearchService.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

struct SearchService {
	static func searchAllCategory(term: String) async -> BaseResponse<SearchAllCategoryResponse>? {
		
		return await NetworkManager.shared.request(SearchEndPoint.getSearchAllCategory(term: term))
	}
}
