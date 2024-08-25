//
//  CalendarItem.swift
//  NanaLand
//
//  Created by 정현우 on 4/26/24.
//

import SwiftUI
import SwiftUICalendar

struct CalendarItem: View {
	
	let date: YearMonthDay
	@Binding var currentStartDate: YearMonthDay?
	@Binding var currentEndDate: YearMonthDay?
    
    var body: some View {
		VStack(alignment: .center) {
			Text("\(date.day)")
				.font(.body01)
				.foregroundStyle({
					if let startDate = currentStartDate {
						// 만약 startDate가 선택됐다면
						if let endDate = currentEndDate {
							// 만약 endDate도 선택됐다면
							if date >= startDate && date <= endDate {
								// 범위 안이라면 white
								Color.baseWhite
							} else {
								// 아니라면 black, 다른 달이면 gray
								if date.isFocusYearMonth ?? true {
									Color.baseBlack
								} else {
									Color.gray1
								}
							}
						} else {
							// endDate는 선택 안됐다면
							if date == startDate {
								// 시작날(하루)는 white
								Color.baseWhite
							} else {
								// 시작날도 아니라면 black, 다른 달이면 gray
								if date.isFocusYearMonth ?? true {
									Color.baseBlack
								} else {
									Color.gray1
								}
							}
						}
					} else {
						// startDate도 선택 안됐다면 black or gray
						if date.isFocusYearMonth ?? true {
							Color.baseBlack
						} else {
							Color.gray1
						}
					}
				}())

		}
		.frame(width: 52, height: 48)
		.background {
			// 시작하나거나 시작==종료 같은 경우 -> 원 하나
			if currentStartDate != nil && (currentEndDate == nil || currentStartDate == currentEndDate) && date == currentStartDate {
				Circle()
					.fill(Color.main)
					.frame(width: 32, height: 32)
			} else if currentStartDate != nil && currentEndDate != nil && date == currentStartDate {
				// 여러 일 선택하고 첫째날인 경우(왼쪽이 curved인 반원)
				HStack(spacing: 0) {
					Spacer(minLength: 0)
					
					Rectangle()
						.fill(Color.main)
						.clipShape(RoundedCorners(radius: 28, corners: [.topLeft, .bottomLeft]))
						.frame(width: 43, height: 32, alignment: .trailing)
				}
			} else if currentStartDate != nil && currentEndDate != nil && date == currentEndDate {
				// 여러 일 선택하고 마지막날인 경우(오른쪽이 curved인 반원)
				HStack(spacing: 0) {
					Rectangle()
						.fill(Color.main)
						.clipShape(RoundedCorners(radius: 28, corners: [.topRight, .bottomRight]))
						.frame(width: 43, height: 32, alignment: .leading)
					Spacer(minLength: 0)
				}
			} else if currentStartDate != nil && currentEndDate != nil && date > currentStartDate! && date < currentEndDate! {
				// 여러 일 선택하고 중간 날(직사각형)
				Rectangle()
					.fill(Color.main)
					.frame(width: 52, height: 32)
			}
		}
		.onTapGesture {
			if currentStartDate == nil {
				currentStartDate = date
			} else if currentEndDate == nil && date < currentStartDate! {
				currentStartDate = date
			} else if currentEndDate == nil {
				currentEndDate = date
			} else {
				currentStartDate = date
				currentEndDate = nil
			}
		}
    }
}
