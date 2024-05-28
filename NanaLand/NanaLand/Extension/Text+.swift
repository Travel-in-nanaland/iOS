//
//  Text+.swift
//  NanaLand
//
//  Created by 정현우 on 5/27/24.
//

import Foundation
import SwiftUI

extension Text {
	init(_ localizedKey: LocalizedKey) {
		let localizedString = localizedKey.localized(for: LocalizationManager.shared.language)
		self.init(localizedString)
	}
	
	init(_ localizedKey: LocalizedKey, arguments: [CVarArg]) {
		let localizedString = localizedKey.localized(for: LocalizationManager.shared.language, arguments)
		self.init(localizedString)
	}
}
