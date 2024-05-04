//
//  YearMonthDay+.swift
//  NanaLand
//
//  Created by 정현우 on 4/26/24.
//

import SwiftUICalendar

extension YearMonthDay {
	static func < (lhs: Self, rhs: Self) -> Bool {
		if lhs.year != rhs.year {
			return lhs.year < rhs.year
		} else if lhs.month != rhs.month {
			return lhs.month < rhs.month
		} else {
			return lhs.day < rhs.day
		}
	}
	
	static func <= (lhs: Self, rhs: Self) -> Bool {
		return lhs < rhs || lhs == rhs
	}
	
	static func > (lhs: Self, rhs: Self) -> Bool {
		return !(lhs <= rhs)
	}
	
	static func >= (lhs: Self, rhs: Self) -> Bool {
		return !(lhs < rhs)
	}
}
