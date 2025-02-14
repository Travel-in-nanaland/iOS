//
//  ReviewCompleteView.swift
//  NanaLand
//
//  Created by juni on 7/28/24.
//

import SwiftUI

struct ReviewCompleteView: View {
    var title: String = "EXPERIENCE"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            MainView(title: title)
                .padding(.top, Constants.screenWidth * (60 / 360))
                .padding(.bottom, Constants.screenWidth * (95 / 360))
            
            Button {
                AppState.shared.navigationPath.removeLast()
                AppState.shared.navigationPath.removeLast()
                // 네비게이션 path 맨 위 2개 제거 해서 detail view로 돌아가기
                
            } label: {
                RoundedRectangle(cornerRadius: 50.0)
                    .foregroundStyle(Color.main)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (48 / 360))
                    .overlay {
                        Text(.goContent)
                    }
            }
            .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (48 / 360))
            .foregroundStyle(Color.white)
            .font(.body_bold)
            .padding(.bottom, Constants.screenWidth * (24 / 360))
            
            Spacer()
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
                    .frame(width: Constants.screenWidth * (350 / 360), height: Constants.screenWidth * (331 / 360))
                
                Text(.reviewCompleteExperience)
                    .font(.title01_bold)
                    .foregroundStyle(Color.main)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, Constants.screenWidth * (22 / 360))
                    
                Text(.reviewCompleteExperienceSub1)
                    .font(.body01)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                
                Text(.reviewCompleteExperienceSub2)
                    .font(.body01)
                    .foregroundColor(.main)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(10)
                    .padding(.bottom, Constants.screenWidth * (22 / 360))
                
                Text(.reviewCompleteExperienceSub3)
                    .font(.body01)
                    .multilineTextAlignment(.center)
            }
        } else if title == "RESTAURANT" {
            VStack{
                LottieView(jsonName: restaurantJsonName, loopMode: .loop)
                    .frame(width: Constants.screenWidth * (350 / 360), height: Constants.screenWidth * (331 / 360))
                
                
                Text(.reviewCompleteRestaurant)
                    .font(.title01_bold)
                    .foregroundStyle(Color.main)
                    .padding(.bottom, Constants.screenWidth * (22 / 360))
                    
                Text(.reviewCompleteRestaurantSub1)
                    .font(.body01)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(10)
                    .padding(.bottom, Constants.screenWidth * (22 / 360))
                
                Text(.reviewCompleteRestaurantSub2)
                    .font(.body01)
                    .multilineTextAlignment(.center)
            }
        }
    }
   
}

#Preview {   
    ReviewCompleteView()
}
