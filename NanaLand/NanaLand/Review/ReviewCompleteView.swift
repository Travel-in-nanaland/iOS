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
            MainView(title: title)
                .padding(.bottom, 70)
            Spacer()
            Button {
                AppState.shared.navigationPath.removeLast()
                AppState.shared.navigationPath.removeLast()
                // 네비게이션 path 맨 위 2개 제거 해서 detail view로 돌아가기
                
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
            .padding(.bottom, 10)
            
            Button(action: {
                dismiss()
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
        .toolbar(.hidden)
        .onAppear {
            print("\(AppState.shared.navigationPath)")
        }
    }
}

struct MainView: View {
    var title = ""
    
    let experienceJsonName: String = "review_experience"
    let restaurantJsonName: String = "review_restaurant"
    var body: some View {
        
        if title == "EXPERIENCE" {
            VStack{
                LottieView(jsonName: experienceJsonName, loopMode: .loop)
                    .frame(height: 350)
                    .padding(.top, 100)
                
                Text("당신의 매력적인 글 고마워요 👻")
                    .font(.largeTitle02)
                    .foregroundStyle(Color.main)
                    .frame(height: 36)
                    
                Text("당신의 매력만큼이나\n여행지의 매력도 함께 올라갔어요!")
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .padding(.top, 10)
                
                Text("점점 기대될 것 같아요🧚‍♀️")
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            }
        } else if title == "RESTAURANT" {
            VStack{
                LottieView(jsonName: restaurantJsonName, loopMode: .loop)
                    .frame(height: 350)
                    .padding(.top, 100)
                
                Text("너무 마음에 드는걸요 ?")
                    .font(.largeTitle02)
                    .foregroundStyle(Color.main)
                    .frame(height: 36)
                    
                Text("당신의 세심한 글이\n누군가의 여행 선택지를\n풍요롭게 해줬어요 !")
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .padding(.top, 10)
                
                Text("다음번도 기대할게요")
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            }
        }
    }
   
}

#Preview {   
    ReviewCompleteView()
}
