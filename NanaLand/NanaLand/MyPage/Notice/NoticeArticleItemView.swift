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
                    .padding()
                
                VStack(alignment: .leading){
                    Text(type)
                        .font(.caption01_semibold)
                        .foregroundColor(.main)
                    
                    Text(title)
                        .font(.body02_bold)
                        .foregroundColor(.black)
                    
                    Text(date)
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
}

#Preview {
    NoticeArticleItemView(title: "6월 4주차 공지", type: "공지사항", date: "2024.06.12")
}
