//
//  BaseResponse.swift
//  NanaLand
//
//  Created by 정현우 on 4/18/24.
//

import Foundation

struct EmptyResponseModel: Codable {
    
}

struct OldBaseResponse<T: Codable>: Codable {
	let status: Int
	let message: String
	let data: T
}

struct BaseResponse<T: Codable>: Codable {
	let status: Int
	let message: String
	let data: T?

	enum CodingKeys: String, CodingKey {
		case status
		case message
		case data
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		status = try container.decode(Int.self, forKey: .status)
		message = try container.decode(String.self, forKey: .message)
		data = try container.decodeIfPresent(T.self, forKey: .data)
	}
}
