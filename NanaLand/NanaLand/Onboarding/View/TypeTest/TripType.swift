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
			return .GAMGYUL // TODO: 미구현 이미지 변경 필요
		case .GAMGYUL_ADE:
			return .GAMGYUL_ADE
		case .GAMGYUL_BUBBLE_TEA:
			return .GAMGYUL_BUBBLE_TEA
		}
	}
}
