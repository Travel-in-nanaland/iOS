//
//  CalendarFilterView.swift
//  NanaLand
//
//  Created by 정현우 on 4/25/24.
//

import SwiftUI
import SwiftUICalendar

struct CalendarFilterView: View {
	@Environment(\.dismiss) var dismiss
	
	@StateObject var calendarController = CalendarController()
	@Binding var startDate: YearMonthDay?
	@Binding var endDate: YearMonthDay?
	
	// 적용하기 누르면 바인딩
	@State var currentStartDate: YearMonthDay?
	@State var currentEndDate: YearMonthDay?
	
    var body: some View {
		ZStack {
			Color.baseBlack.opacity(0.6)
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: 0) {
				titleAndCloseButton
				calendarYearMonthIndicator
				calendar
				bottomButtons
			}
			.frame(width: 360)
			.background(Color.white)
			.clipShape(RoundedRectangle(cornerRadius: 4))
			.shadow(color: .baseBlack.opacity(0.1), radius: 10, x: 0, y: -4)
		}
		.onAppear {
			currentStartDate = startDate
			currentEndDate = endDate
			
			if currentStartDate != nil {
				calendarController.setYearMonth(year: currentStartDate!.year, month: currentStartDate!.month)
			}
		}
    }
	
	private var titleAndCloseButton: some View {
		HStack {
			Text(String(localized: "chooseDate"))
				.font(.gothicNeo(.bold, size: 18))
			
			Spacer()
			
			Button(action: {
				dismiss()
			}, label: {
				Image(.icX)
					.resizable()
					.frame(width: 32, height: 32)
			})
		}
		.padding(.vertical, 24)
		.padding(.horizontal, 16)
	}
	
	private var calendarYearMonthIndicator: some View {
		HStack {
			Spacer()
			
			VStack(spacing: 4) {
				Text("\(calendarController.yearMonth.year.description)\(String(localized: "year"))")
					.font(.caption01_semibold)
					.foregroundStyle(Color.main)
				
				HStack(spacing: 24) {
					Button(action: {
						calendarController.scrollTo(calendarController.yearMonth.addMonth(value: -1))
					}, label: {
						Image(.icLeft)
							.resizable()
							.frame(width: 24, height: 24)
					})
					
					Text("\(calendarController.yearMonth.month)\(String(localized: "month"))")
						.font(.largeTitle02)
						.foregroundStyle(Color.baseBlack)
					
					Button(action: {
						calendarController.scrollTo(calendarController.yearMonth.addMonth(value: 1))
					}, label: {
						Image(.icRight)
							.resizable()
							.frame(width: 24, height: 24)
					})
				}
			}
			
			Spacer()
		}
		.padding(.bottom, 16)
	}
	
	private var calendar: some View {
		CalendarView(
			calendarController,
			headerSize: .fixHeight(28),
			header: { week in
				VStack(alignment: .center) {
					Text("\(week.shortString)")
						.font(.caption01)
						.foregroundStyle(Color.gray1)
				}
				.frame(width: 52, height: 28)
			}, component: { date in
				CalendarItem(date: date, currentStartDate: $currentStartDate, currentEndDate: $currentEndDate)
			}
		)
		.padding(.horizontal, 12)
		.padding(.bottom, 32)
		.frame(height: 300)
	}
	
	private var bottomButtons: some View {
		HStack(spacing: 0) {
			Button(action: {
				startDate = nil
				endDate = nil
				currentStartDate = nil
				currentEndDate = nil
			}, label: {
				HStack(spacing: 8) {
					Image(.icRe)
						.resizable()
						.frame(width: 24, height: 24)
					
					Text(String(localized: "reset"))
				}
			})
			.tint(.baseBlack)
			
			Spacer()
			
			Button(action: {
				startDate = currentStartDate
				endDate = currentEndDate
				dismiss()
			}, label: {
				Text(String(localized: "apply"))
					.frame(width: 209, height: 48)
			})
			.tint(.baseWhite)
			.background(Color.main)
			.clipShape(RoundedRectangle(cornerRadius: 30))
		}
		.padding(.leading, 31)
		.padding(.trailing, 16)
		.padding(.bottom, 36)
	}
}

#Preview {
	CalendarFilterView(startDate: .constant(nil), endDate: .constant(nil))
		.background(HomeMainView())
}
