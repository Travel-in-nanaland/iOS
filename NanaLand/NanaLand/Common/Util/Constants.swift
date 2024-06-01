//
//  Constants.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import UIKit

struct Constants {
	static let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
	static let screenWidth = windowScene?.screen.bounds.width ?? 0
	static let screenHeight = windowScene?.screen.bounds.height ?? 0
	static let splashTime = 3.5
}
