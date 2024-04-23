//
//  BaseResponse.swift
//  NanaLand
//
//  Created by 정현우 on 4/18/24.
//

import Foundation

struct BaseResponse<T: Codable>: Codable {
	let status: Int
	let message: String
	let data: T
}
