//
//  UIApplication+.swift
//  NanaLand
//
//  Created by 정현우 on 5/31/24.
//

import UIKit

extension UIApplication {
	func addTapGestureRecognizer() {
		guard let window = Constants.windowScene?.windows.first else { return }
		let tapRecognizer = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
		tapRecognizer.cancelsTouchesInView = false
		tapRecognizer.delegate = self
		window.addGestureRecognizer(tapRecognizer)
	}
 }
 
extension UIApplication: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return false
	}
}
