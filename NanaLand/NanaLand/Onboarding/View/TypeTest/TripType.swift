//
//  TripType.swift
//  NanaLand
//
//  Created by 정현우 on 5/17/24.
//

import Foundation

enum TripType: String {
	case GAMGYUL_ICECREAM
	case GAMGYUL_RICECAKE
	case GAMGYUL
	case GAMGYUL_CIDER
	case GAMGYUL_AFFOKATO
	case GAMGYUL_HANGWA
	case GAMGYUL_JUICE
	case GAMGYUL_CHOCOLATE
	case GAMGYUL_COCKTAIL
	case TANGERINE_PEEL_TEA
	case GAMGYUL_YOGURT
	case GAMGYUL_FLATCCINO
	case GAMGYUL_LATTE
	case GAMGYUL_SIKHYE
	case GAMGYUL_ADE
	case GAMGYUL_BUBBLE_TEA
	
	var localizedKey: LocalizedKey {
		return LocalizedKey(rawValue: self.rawValue)!
	}
	
	var descriptionLocalizedKey: LocalizedKey {
		return LocalizedKey(rawValue: self.rawValue + "_DESCRIPTION")!
	}
	
	var image: ImageResource {
		switch self {
		case .GAMGYUL_ICECREAM:
			return .GAMGYUL_ICECREAM
		case .GAMGYUL_RICECAKE:
			return .GAMGYUL_RICECAKE
		case .GAMGYUL:
			return .GAMGYUL
		case .GAMGYUL_CIDER:
			return .GAMGYUL_CIDER
		case .GAMGYUL_AFFOKATO:
			return .GAMGYUL_AFFOKATO
		case .GAMGYUL_HANGWA:
			return .GAMGYUL_HANGWA
		case .GAMGYUL_JUICE:
			return .GAMGYUL_JUICE
		case .GAMGYUL_CHOCOLATE:
			return .GAMGYUL_CHOCOLATE
		case .GAMGYUL_COCKTAIL:
			return .GAMGYUL_COCKTAIL
		case .TANGERINE_PEEL_TEA:
			return .TANGERINE_PEEL_TEA
		case .GAMGYUL_YOGURT:
			return .GAMGYUL_YOGURT
		case .GAMGYUL_FLATCCINO:
			return .GAMGYUL_FLATCCINO
		case .GAMGYUL_LATTE:
			return .GAMGYUL_LATTE
		case .GAMGYUL_SIKHYE:
			return .GAMGYUL_SIKHYE
		case .GAMGYUL_ADE:
			return .GAMGYUL_ADE
		case .GAMGYUL_BUBBLE_TEA:
			return .GAMGYUL_BUBBLE_TEA
		}
	}
    
    static let localizedKeyMapping: [String: TripType] = [
            "감귤아이스크림": .GAMGYUL_ICECREAM,
            "감귤 찹쌀떡": .GAMGYUL_RICECAKE,
            "감귤": .GAMGYUL,
            "감귤사이다": .GAMGYUL_CIDER,
            "감귤 아포카토": .GAMGYUL_AFFOKATO,
            "감귤한과": .GAMGYUL_HANGWA,
            "감귤주스": .GAMGYUL_JUICE,
            "감귤 초콜릿": .GAMGYUL_CHOCOLATE,
            "감귤 칵테일": .GAMGYUL_COCKTAIL,
            "귤피차": .TANGERINE_PEEL_TEA,
            "감귤 요거트": .GAMGYUL_YOGURT,
            "감귤 플랫치노": .GAMGYUL_FLATCCINO,
            "감귤 라떼": .GAMGYUL_LATTE,
            "감귤식혜": .GAMGYUL_SIKHYE,
            "감귤에이드": .GAMGYUL_ADE,
            "감귤 버블티": .GAMGYUL_BUBBLE_TEA
        ]
}
