//
//  AuthDTO.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation

struct LoginRequest: Codable {
	let locale: String
	let email: String
	let gender: String
	let birthDate: String
	let provider: String
	let providerId: Int64
}

struct LoginResponse: Codable {
	let accessToken: String
	let refreshToken: String
}
