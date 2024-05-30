//
//  ClearBackground.swift
//  NanaLand
//
//  Created by 정현우 on 5/29/24.
//

import Foundation
import SwiftUI

struct ClearBackground: UIViewRepresentable {
	public func makeUIView(context: Context) -> some UIView {
		let view = UIView()
		DispatchQueue.main.async {
			view.superview?.superview?.backgroundColor = .clear
		}
		return view
	}
	
	public func updateUIView(_ uiView: UIViewType, context: Context) {
		
	}
}
