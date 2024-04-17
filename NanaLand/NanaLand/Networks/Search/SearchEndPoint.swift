//
//  SearchEndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

enum SearchEndPoint {
	case getSearchAllCategory(term: String)
}

extension SearchEndPoint: EndPoint {
	var baseURL: String {
		return "\(Secrets.baseUrl)/search"
	}
	
	var path: String {
		switch self {
		case .getSearchAllCategory:
			return "/category"
		}
	}
	
	var method: HTTPMethod {
		switch self {
		case .getSearchAllCategory:
			return .get
		}
	}
	
	var task: APITask {
		switch self {
		case let .getSearchAllCategory(term):
			let param = ["keyword": term]
			return .requestParameters(parameters: param)
		}
	}
	
}
