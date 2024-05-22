//
//  View+.swift
//  NanaLand
//
//  Created by 정현우 on 5/21/24.
//

import SwiftUI

extension View {
	
	func hidden(_ shouldHide: Bool) -> some View {
		modifier(ViewHiddenModifier(isHidden: shouldHide))
	}
}

struct ViewHiddenModifier: ViewModifier {
	
	var isHidden: Bool
	
	func body(content: Content) -> some View {
		
		Group {
			if isHidden {
				content.hidden()
			} else {
				content
			}
		}
	}
}
