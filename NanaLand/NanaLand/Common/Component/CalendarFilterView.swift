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
    @ObservedObject var viewModel: FestivalMainViewModel
	@StateObject var calendarController = CalendarController()
	@Binding var startDate: YearMonthDay?
	@Binding var endDate: YearMonthDay?
    @Binding var location: String
	// 적용하기 누르면 바인딩
	@State var currentStartDate: YearMonthDay?
	@State var currentEndDate: YearMonthDay?
	
    var body: some View {
		
            Color.baseBlack.opacity(0.1)
				.edgesIgnoringSafeArea(.all)
			
			VStack(spacing: 0) {
				titleAndCloseButton
				calendarYearMonthIndicator
				calendar
				bottomButtons
			}
			.background(Color.white)
			.clipShape(RoundedCorners(radius: 12, corners: [.topLeft, .topRight]))
			.shadow(color: .baseBlack.opacity(0.1), radius: 10, x: 0, y: -4)
		
		.onAppear {
			currentStartDate = startDate
			currentEndDate = endDate
			
			if currentStartDate != nil {
				calendarController.setYearMonth(year: currentStartDate!.year, month: currentStartDate!.month)
			}
		}
    }
	
    func getDateFestivalMainItem(page: Int32, size: Int32, filterName: String, start: String, end: String) async {
        await viewModel.action(.getThisMonthFestivalMainItem(page: page, size: size, filterName: filterName, startDate: start, endDate: end))
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
    static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        // 현재 날짜를 문자열로 변환하여 반환
        var todayDateString: String {
            return CalendarFilterView.dateFormatter.string(from: Date())
        }
    func formattedNumber(_ number: Int) -> String {
            // 숫자를 문자열로 변환하여, 1자리 숫자인 경우에만 앞에 0을 추가
            return number < 10 ? "0\(number)" : "\(number)"
        }
    // date 문자열에서 월만 뽑아내기
    func extractFifthAndSixthCharacters(from str: String) -> String? {
        
        // 5번째 문자의 인덱스 찾기
        let fifthIndex = str.index(str.startIndex, offsetBy: 5)
        
        // 6번째 문자의 인덱스 찾기
        let sixthIndex = str.index(fifthIndex, offsetBy: 1)
        
        // 해당 인덱스의 문자열 반환
        return String(str[fifthIndex...sixthIndex])
    }
	private var bottomButtons: some View {
        
		HStack(spacing: 46) {
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
			
			Button(action: {
				startDate = currentStartDate
				endDate = currentEndDate
                // 현재날짜 문자열로
                let strCurrentDate = todayDateString
                // 현재날짜 연도
                let strCurrentYear = Int(strCurrentDate.prefix(4))
                // 현재날짜 월
                var strCurrentMonth = ""
                if let result = extractFifthAndSixthCharacters(from: strCurrentDate) {
                    strCurrentMonth = result
                }
                // 현재날짜 일
                let strCurrentDay = Int(strCurrentDate.suffix(2))
                // 시작날짜만 선택했을 경우에는 끝나는 날짜를 시작날짜와 같은 날로
                if endDate == nil {
                    endDate = startDate
                }
                
                let strStartDate = String(startDate?.year ?? strCurrentYear!) + formattedNumber(startDate?.month ?? Int(strCurrentMonth)!) + formattedNumber(startDate?.day ?? strCurrentDay!)
                
                let strEndDate = String(endDate?.year ?? strCurrentYear!) + formattedNumber(endDate?.month ?? Int(strCurrentMonth)!) + formattedNumber(endDate?.day ?? strCurrentDay!)
                
                Task {
                    if location == "지역" || location == "전 지역" {
                        location = ""
                    }
                    
                    await getDateFestivalMainItem(page: 0, size: 18, filterName: [location].joined(separator: ","), start: strStartDate, end: strEndDate)
                    if location == "" {
                        location = "전 지역"
                    }
                }
				dismiss()
			}, label: {
				Text(String(localized: "apply"))
					.frame(height: 48)
					.frame(maxWidth: .infinity)
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

//#Preview {
//	CalendarFilterView(startDate: .constant(nil), endDate: .constant(nil))
//		.background(HomeMainView())
//}
