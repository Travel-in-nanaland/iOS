//
//  View+.swift
//  NanaLand
//
//  Created by 정현우 on 5/21/24.
//

import SwiftUI

extension View {
    func font(_ font: UIFont) -> some View {
        let fontSpacing = font.lineHeight / 100 * 50 / 2
        return self
            .font(Font(font))
            .background(.red)
            .padding(.vertical, fontSpacing)
            .background()
            .lineSpacing(fontSpacing * 2)
            
    }
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
