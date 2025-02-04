//
//  NoResultFilterView.swift
//  NanaLand
//
//  Created by wodnd on 1/8/25.
//

import SwiftUI
import SwiftUICalendar

// 카테고리내 필터를 적용시 결과가 없는 경우
struct NoResultFilterView: View {
    @Binding var keyword: String
    @Binding var location: String
    @Binding var yearMonthDay: YearMonthDay?
    @Binding var season: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter
    }()
    
    // 현재 날짜를 문자열로 변환하여 반환
    var todayDateString: String {
        return FilterView.dateFormatter.string(from: Date())
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
    
            Text(.noContent)
                .font(.body01)
                .foregroundColor(.gray1)
                .frame(height: Constants.screenWidth * (26 / 360))
                .multilineTextAlignment(.center)
            
            Text(.filterAdjustment)
                .font(.body02)
                .foregroundColor(.gray2)
                .frame(height: Constants.screenWidth * (22 / 360))
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Button(action: {
                keyword =  LocalizedKey.type.localized(for: LocalizationManager().language)
                location =  LocalizedKey.allLocation.localized(for: LocalizationManager().language)
                
                yearMonthDay = nil
                let formatterMonth = DateFormatter()
                formatterMonth.dateFormat = "MM"
                let currentMonth = formatterMonth.string(from: Date())
                
                switch Int(currentMonth) {
                case 3, 4:
                    season = LocalizedKey.spring.localized(for: LocalizationManager().language)
                    
                case 5, 6, 7, 8:
                    season = LocalizedKey.summer.localized(for: LocalizationManager().language)
                    
                case 9, 10:
                    season = LocalizedKey.autumn.localized(for: LocalizationManager().language)
                    
                case 11, 12, 1, 2:
                    season = LocalizedKey.winter.localized(for: LocalizationManager().language)
                default:
                    // 예상치 못한 경우 기본값 설정
                    season = LocalizedKey.spring.localized(for: LocalizationManager().language)
                }
                
            }, label: {
                Text(.filterReset)
                    .font(.body02_semibold)
                    .foregroundColor(.gray1)
                    .frame(height: Constants.screenWidth * (22 / 360))
                    .padding(EdgeInsets(top: Constants.screenWidth * (9 / 360), leading: Constants.screenWidth * (28 / 360), bottom: Constants.screenWidth * (9 / 360), trailing: Constants.screenWidth * (28 / 360)))
                    .background(content: {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.gray2)
                    })
            })
        }
    }
}

#Preview {
    NoResultFilterView(keyword: .constant(""), location: .constant(""), yearMonthDay:
        .constant(nil), season: .constant(""))
}

