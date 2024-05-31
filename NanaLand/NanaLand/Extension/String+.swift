//
//  String+.swift
//  NanaLand
//
//  Created by 정현우 on 5/31/24.
//

import Foundation

extension String {
	func isValidNickname() -> Bool {
		return true
	}
	
	func isValidEmail() -> Bool {
		let emailRegEx = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}"
		let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return pred.evaluate(with: self)
	}
}
