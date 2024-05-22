//
//  AuthDTO.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import Foundation

struct LoginRequest: Codable {
	let locale: String
	let provider: String
	let providerId: String
}

struct RegisterRequest: Codable {
	var consentItems: [ConsentItem]
	var locale: String
	var email: String
	var gender: String
	var birthDate: String
	var nickname: String
	var provider: String
	var providerId: String
	
	init(
		consentItems: [ConsentItem] = [],
		locale: String = "",
		email: String = "",
		gender: String = "",
		birthDate: String = "",
		nickname: String = "",
		provider: String = "",
		providerId: String = ""
	) {
		self.consentItems = consentItems
		self.locale = locale
		self.email = email
		self.gender = gender
		self.birthDate = birthDate
		self.nickname = nickname
		self.provider = provider
		self.providerId = providerId
	}
}

struct LoginRegisterResponse: Codable {
	let accessToken: String
	let refreshToken: String
}

struct ConsentItem: Codable {
	let consentType: String
	let consent: Bool
}

struct PatchUserTypeRequest: Codable {
	let type: String
}
