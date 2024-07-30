//
//  NoticeDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI
import Kingfisher

struct NoticeDetailView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State var notice: ProfileMainModel.Notice
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                NavigationBar(title: "")
                    .frame(height: 56)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 10)
                
                VStack(alignment: .leading){
                    Text(notice.title)
                        .font(.title02_bold)
                        .foregroundColor(.black)
                    
                    Text(notice.date)
                        .font(.caption01)
                        .foregroundColor(.black)
                        .padding(.top, 1)
                }
                .padding()
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray2)
                    .padding(.top, 1)
                
                if !notice.imageUrl.isEmpty {
                    KFImage(URL(string: (notice.imageUrl)))
                        .resizable()
                        .frame(width: Constants.screenWidth * 0.9, height: Constants.screenHeight * 0.3)
                        .cornerRadius(8)
                        .padding()
                    
                    Text(notice.content)
                        .font(.body02)
                        .foregroundColor(.black)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                } else {
                    Text(notice.content)
                        .font(.body02)
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                }
                
                
                    
                Spacer()
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    NoticeDetailView(notice: ProfileMainModel.Notice(id: 1, type: "공지사항", imageUrl: "https://github.com/user-attachments/assets/05bf3472-2745-44f8-a9bc-1480595e806a", title: "나나랜드 앱 출시 이벤트🪄", date: "2024.06.12", content: "7월 20일까지 sns에 올려주시면 추첨을 통해 소정의 선물을 드리겠sadfsadfsafsdfasfsadfasdfasdfasdfasdfasdfsafsafasfdsafasfasfsafsafsafasfsafsafsaf습니다!"))
        .environmentObject(LocalizationManager())
}
