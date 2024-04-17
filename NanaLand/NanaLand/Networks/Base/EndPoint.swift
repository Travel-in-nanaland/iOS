//
//  EndPoint.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

protocol EndPoint {
	var baseURL: String { get }
	var path: String { get }
	var method: HTTPMethod { get }
	var headers: HTTPHeaders? { get }
	var task: APITask { get }
}

extension EndPoint {
	// default header
	var headers: HTTPHeaders? { return ["Content-Type": "application/json"] }
}
