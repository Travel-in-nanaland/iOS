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
                Text(.goContent)
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
                AppState.shared.navigationPath.append(ReviewCompleteType.reviewSearch)
            }, label: {
                Text(.addAnotherReview)
                    
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
        .navigationDestination(for: ReviewCompleteType.self) { review in
            switch review {
            case let .reviewSearch:
                SearchReviewView()
            }
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
                    .frame(width: 230, height: 250)
                    .padding(.top, 100)
                
                Text(.reviewCompleteExperience)
                    .font(.largeTitle02)
                    .foregroundStyle(Color.main)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    
                Text(.reviewCompleteExperienceSub1)
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .padding(.top, 10)
                
                Text(.reviewCompleteExperienceSub2)
                    .font(.title02)
                    .foregroundColor(.main)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(10)
                    .padding(.top, 10)
                
                Text(.reviewCompleteExperienceSub3)
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            }
        } else if title == "RESTAURANT" {
            VStack{
                LottieView(jsonName: restaurantJsonName, loopMode: .loop)
                    .frame(width: 230, height: 250)
                    .padding(.top, 100)
                
                Text(.reviewCompleteRestaurant)
                    .font(.largeTitle02)
                    .foregroundStyle(Color.main)
                    .frame(height: 36)
                    
                Text(.reviewCompleteRestaurantSub1)
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineSpacing(10)
                    .padding(.top, 10)
                
                Text(.reviewCompleteRestaurantSub2)
                    .font(.title02)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
            }
        }
    }
   
}

enum ReviewCompleteType {
    case reviewSearch
}

#Preview {   
    ReviewCompleteView()
}
