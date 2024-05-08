//
//  Color+.swift
//  NanaLand
//
//  Created by 정현우 on 5/7/24.
//

import SwiftUI

extension Color {
	init(hex: UInt, alpha: Double = 1) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xFF) / 255.0,
			green: Double((hex >> 8) & 0xFF) / 255.0,
			blue: Double(hex & 0xFF) / 255.0,
			opacity: alpha
		)
	}
}
