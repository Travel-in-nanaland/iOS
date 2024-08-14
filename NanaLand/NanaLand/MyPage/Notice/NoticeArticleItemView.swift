//
//  NoticeArticleItemView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI

struct NoticeArticleItemView: View {
    let title: String
    let type: String
    let date: String
    
    var body: some View {
        ZStack{
            HStack{
                Image("icNotice")
                    .padding(.bottom, 30)
                    .padding(.leading, 12)
                
                VStack(alignment: .leading){
                    Text(type)
                        .font(.caption01_semibold)
                        .foregroundColor(.main)
                    
                    Text(title)
                        .font(.body02_bold)
                        .foregroundColor(.black)
                    
                    Text(dateFormatter(createdDate: date))
                        .font(.caption02)
                        .foregroundColor(.gray1)
                        .padding(.top, 10)
                }
                
                Spacer()
                
                Image("icArrow")
                    .padding(.top, 50)
                    .padding(.trailing, 20)
            }
            .background(){
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(minWidth: Constants.screenWidth - 32, minHeight: 88)
                    .shadow(radius: 1)
            }
        }
    }
    
    func dateFormatter(createdDate: String) -> String {
            // 날짜 및 시간 포맷
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let parsedDate = inputFormatter.date(from: createdDate) else { return "Date parse error" }

            // 현재 날짜와 비교
            let now = Date()
            let calendar = Calendar.current

            // 1시간 이내인 경우 "방금 전" 반환
            let minutesDifference = calendar.dateComponents([.minute], from: parsedDate, to: now).minute!
            if minutesDifference < 60 {
                return "방금 전"
            }
            
            // 24시간 이내인 경우 시간 차이 반환
            let daysDifference = calendar.dateComponents([.day], from: parsedDate, to: now).day!
            if daysDifference < 1 {
                let hoursDifference = calendar.dateComponents([.hour], from: parsedDate, to: now).hour!
                return "\(hoursDifference)시간 전"
            } else {
                // 날짜 차이가 있는 경우 날짜 반환
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "yyyy-MM-dd"
                return outputFormatter.string(from: parsedDate)
            }
        }
}

#Preview {
    NoticeArticleItemView(title: "6월 4주차 공지", type: "공지사항", date: "2024.06.12")
}
