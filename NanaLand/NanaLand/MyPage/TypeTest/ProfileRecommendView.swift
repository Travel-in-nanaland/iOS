//
//  ProfileRecommendView.swift
//  NanaLand
//
//  Created by wodnd on 9/1/24.
//

import SwiftUI
import Kingfisher

struct ProfileRecommendView: View {
    @StateObject var typeTestVM = TypeTestProfileViewModel()
    let nickname: String
    @State var isAPICalled = false
    
    var body: some View {
        
        VStack(spacing: 32) {
            NanaNavigationBar(title: .recommendedTravelPlace, showBackButton: true)
            
            if isAPICalled {
                ScrollView {
                    VStack {
                        Text(.recommenedeTravelTitleFirstLine, arguments: [nickname])
                            .font(LocalizationManager.shared.language == .malaysia ? .largeTitle01 : .title02)
                            .foregroundStyle(LocalizationManager.shared.language == .malaysia ? .main : .baseBlack)
                        
                        Text(.recommenedeTravelTitleSecondLine, arguments: [nickname])
                            .font(LocalizationManager.shared.language == .malaysia ? .title02 : .largeTitle01)
                            .foregroundStyle(LocalizationManager.shared.language == .malaysia ? .baseBlack : .main)
                    }
                    .padding(.bottom, 40)
                    
                    ForEach(typeTestVM.state.recommendPlace, id: \.self) { place in
                        ticketView(place: place)
                    }
                    
                    Spacer()
                        .frame(height: 50)
                }
                .scrollIndicators(.hidden)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .bottom) {
            Button(action: {
                AppState.shared.navigationPath.removeLast()
                AppState.shared.navigationPath.removeLast()
            }, label: {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
                    .frame(height: 48)
                    .overlay {
                        Text(.gotoMainScreen)
                            .foregroundStyle(Color.baseWhite)
                            .font(.body_bold)
                    }
            })
            .padding(.horizontal, 16)

        }
        .onAppear(){
            Task{
                await getRecommend()
                isAPICalled = true
            }
        }
    }
    
    private func ticketView(place: RecommendModel) -> some View {
        ZStack(alignment: .topLeading) {
            KFImage(URL(string: place.firstImage.thumbnailUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 500)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.black.opacity(0.0), location: 0.0), // 상단
                    .init(color: Color.black.opacity(0.0), location: 0.36), // 위에서 36% 지점
                    .init(color: Color.black.opacity(0.8), location: 0.70), // 위에서 70% 지점
                    .init(color: Color.black.opacity(0.8), location: 1.0) // 하단
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 300, height: 500)
            
            Image(.logoStamp)
                .padding(.top, 16)
                .padding(.leading, 12)
            
            HStack {
                Spacer()
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 85.7, height: 71.8)
                    .offset(y: -35.9)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                Text(place.title)
                    .font(.title01_bold)
                    .padding(.bottom, 4)
                
                Text(place.introduction)
                    .font(.caption01)
                    .padding(.bottom, 16)
                
                HStack {
                    Spacer()
                    
                    Image(.logoWatermark)
                }
            }
            .foregroundStyle(Color.baseWhite)
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
        }
        .frame(width: 300, height: 500)
        .padding(.bottom, 32)
    }
    
    func getRecommend() async {
        await typeTestVM.action(.getRecommendPlace)
    }
}

#Preview {
    ProfileRecommendView(nickname: "재웅")
}
