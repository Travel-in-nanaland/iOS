//
//  Color+.swift
//  NanaLand
//
//  Created by 정현우 on 5/6/24.
//

import SwiftUI

extension Color {
	init(hex: UInt) {
		self.init(
			.sRGB,
			red: Double((hex >> 16) & 0xff) / 255,
			green: Double((hex >> 08) & 0xff) / 255,
			blue: Double((hex >> 00) & 0xff) / 255
		)
	}
}
