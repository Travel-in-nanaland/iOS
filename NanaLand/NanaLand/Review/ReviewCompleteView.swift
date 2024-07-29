//
//  ReviewCompleteView.swift
//  NanaLand
//
//  Created by juni on 7/28/24.
//

import SwiftUI

struct ReviewCompleteView: View {
    var title: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                MainView()
                    .padding(.bottom, 70)
                Spacer()
                Button {
                    dismiss()
                    dismiss()
                } label: {
                    Text("콘텐츠 다시 보러 가기")
                        
                }
                .frame(width: Constants.screenWidth - 32, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 50.0)
                        .foregroundStyle(Color.main)
                        .frame(width: Constants.screenWidth - 32, height: 48)
                )
                .foregroundStyle(Color.white)
                .font(.body_bold)
                .padding(.bottom, 16)
                
                Button(action: {
                    
                }, label: {
                    Text("다른 리뷰 추가하기")
                        
                })
                .frame(width: Constants.screenWidth - 32, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 50.0)
                         .fill(Color.white) // 배경색 설정
                         .overlay(
                             RoundedRectangle(cornerRadius: 50.0)
                                 .stroke(Color.main, lineWidth: 1) // 테두리 설정
                         )
                )
                .foregroundStyle(Color.main)
                .font(.body_bold)
                .padding(.bottom, 24)
            }
           
        }
        .toolbar(.hidden)
    }
}

struct MainView: View {
    var body: some View {
        Image("ic_reviewComplete")
            .resizable()
            .frame(height: 231)
            .padding(.leading, 55)
            .padding(.trailing, 55)
            .padding(.top, 108)
            .padding(.bottom, 48)
        Text("당신의 매력적인 글 고마워요 👻")
            .font(.largeTitle02)
            .foregroundStyle(Color.main)
            .padding(.bottom, 4)
            .frame(height: 36)
            
        Text("당신의 매력만큼이나\n여행지의 매력도 함께 올라갔어요!")
            .font(.title02)
            .multilineTextAlignment(.center)
            .lineSpacing(10)
    }
   
}

#Preview {    ReviewCompleteView()
}
