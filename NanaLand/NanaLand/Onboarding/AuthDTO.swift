//
//  AuthDTO.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation

struct LoginRequest: Codable {
	let email: String
	let provider: String
	let providerId: Int64
}

struct RegisterRequest: Codable {
	let consentItems: [ConsentItem]
	let locale: String
	let email: String
	let gender: String
	let birthDate: String
	let nickname: String
	let provider: String
	let providerId: Int64
}

struct LoginRegisterResponse: Codable {
	let accessToken: String
	let refreshToken: String
}

struct ConsentItem: Codable {
	let consentType: String
	let consent: Bool
}
