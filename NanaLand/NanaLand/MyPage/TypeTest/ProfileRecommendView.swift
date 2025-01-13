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
    @State private var isAPICalled = false
    
    var body: some View {
        
        VStack(spacing: 32) {
            NanaNavigationBar(title: .recommendedTravelPlace, showBackButton: true)
            
            if isAPICalled {
                if !typeTestVM.state.recommendPlace.isEmpty {
                    ScrollView {
                        VStack {
                            Text(.recommenedeTravelTitleFirstLine, arguments: [nickname])
                                .font(.title02)
                                .foregroundStyle(LocalizationManager.shared.language == .malaysia ? .main : .baseBlack)
                            
                            Text(.recommenedeTravelTitleSecondLine, arguments: [nickname])
                                .font(.largeTitle01)
                                .multilineTextAlignment(.center)
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
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(){
            Task{
                await getRecommend()
                isAPICalled = true
            }
        }
        .navigationDestination(for: recommendDetailType.self, destination: { page in
            switch page{
            case let .recommendNature(id):
                NatureDetailView(id: id)
            case let .recommendFestival(id):
                FestivalDetailView(id: id)
            case let .recommendShop(id):
                ShopDetailView(id: id)
            case let .recommendActivity(id):
                ExperienceDetailView(id: id, experienceType: "Activity")
            case let .recommendArts(id):
                ExperienceDetailView(id: id, experienceType: "CultureArts")
            case let .recommendResaurant(id):
                RestaurantDetailView(id: id)
            }
        })
    }
    
    private func ticketView(place: RecommendModel) -> some View {
        ZStack(alignment: .topLeading) {
            KFImage(URL(string: place.firstImage.thumbnailUrl ?? ""))
                .placeholder {
                        Image(systemName: "photo") // 기본 이미지
                            .resizable()
                            .scaledToFit()
                    }
                    .onFailure { error in
                        print("Image loading failed: \(error.localizedDescription)") // 디버깅용 로그
                    }
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
                
                Text(place.introduction ?? "")
                    .font(.caption01)
                    .padding(.bottom, 16)
                
                HStack {
                    
                    Image(.logoWatermark)
                    
                    Spacer()
                    
                    Button(action: {
                        switch place.category {
                        case "NATURE":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendNature(id: place.id))
                        case "FESTIVAL":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendFestival(id: place.id))
                        case "SHOP":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendShop(id: place.id))
                        case "EXPERIENCE":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendActivity(id: place.id))
                        case "CULTURE_AND_ARTS":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendArts(id: place.id))
                        case "RESTAURANT":
                            AppState.shared.navigationPath.append(recommendDetailType.recommendResaurant(id: place.id))
                        default:
                            print("error")
                        }
                    }, label: {
                        HStack(spacing: 0){
                            Text(.recommendDetail)
                                .font(.caption01_semibold)
                                .foregroundColor(.white)
                            
                            Image(.icDetailGo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.screenWidth * (24 / 360), height: Constants.screenWidth * (5 / 360))
                        }
                        .frame(height: Constants.screenWidth * (18 / 360))
                    })
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

enum recommendDetailType: Hashable{
    case recommendNature(id: Int64)
    case recommendFestival(id: Int64)
    case recommendShop(id: Int64)
    case recommendActivity(id: Int64)
    case recommendArts(id: Int64)
    case recommendResaurant(id: Int64)
}


#Preview {
    ProfileRecommendView(nickname: "wodnd")
}
