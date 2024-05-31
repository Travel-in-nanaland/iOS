//
//  TypeTestRecommendPlaceView.swift
//  NanaLand
//
//  Created by 정현우 on 5/31/24.
//

import SwiftUI
import Kingfisher

struct TypeTestRecommendPlaceView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let nickname: String
	
    var body: some View {
		
		VStack(spacing: 32) {
			NanaNavigationBar(title: .recommendedTravelPlace, showBackButton: true)
			
			ScrollView {
				HStack(spacing: 0) {
					VStack(alignment: .leading) {
						Text(.recommenedeTravelTitleFirstLine, arguments: [nickname])
							.foregroundStyle(LocalizationManager.shared.language == .malaysia ? .main : .baseBlack)
						
						Text(.recommenedeTravelTitleSecondLine)
							.foregroundStyle(LocalizationManager.shared.language == .malaysia ? .baseBlack : .main)
					}
					.font(.largeTitle01)
					
					Spacer(minLength: 0)
				}
				.padding(.horizontal, 16)
				
				ForEach(typeTestVM.state.recommendPlace, id: \.self) { place in
					ticketView(place: place)
				}
				
				Spacer()
					.frame(height: 50)
			}
			.scrollIndicators(.hidden)
		}
		.toolbar(.hidden, for: .navigationBar)
		.overlay(alignment: .bottom) {
			Button(action: {
				typeTestVM.action(.onTapGotoMainViewButton)
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
    }
	
	private func ticketView(place: RecommendModel) -> some View {
		ZStack(alignment: .topLeading) {
			KFImage(URL(string: place.thumbnailUrl))
				.resizable()
				.scaledToFill()
				.frame(width: 300, height: 500)
				.clipped()
			
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
					.font(.largeTitle02)
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
			.padding(.bottom, 13)
		}
		.frame(width: 300, height: 500)
		.padding(.bottom, 28)
	}
}

#Preview {
	let data = [NanaLand.RecommendModel(id: 7, category: "EXPERIENCE", thumbnailUrl: "https://api.cdn.visitjeju.net/photomng/thumbnailpath/202111/16/d933eea8-03ee-4d30-a3f6-7cd465422207.jpg", title: "더마파크", introduction: "세계최초의 말전문 테마공원인 라온더마파크는 회원제를 기본으로 운영되는 승마장이지만, 기마공연, 승마체험, 카드라이더 등 관광객들도 체험할 수 있는 컨텐츠를 두루 제공하고 있다."), NanaLand.RecommendModel(id: 2, category: "NATURE", thumbnailUrl: "https://api.cdn.visitjeju.net/photomng/thumbnailpath/201811/29/2e824a67-25e5-461f-9f49-3c0298ac590b.jpg", title: "고사리숲", introduction: "섬안에 섬 우도에서, 바이크를 타며 자유를 느껴보세요. 바이크를 타고, 자유롭게 우도의 아름다운 해변과 우도땅콩으로 만든 커피와 아이스크림을 먹으면서, 1~2시간이면 한바퀴를 돌 수 있다. ")]
	
	@StateObject var vm = TypeTestViewModel(state: .init(recommendPlace: data))
	
	return TypeTestRecommendPlaceView(nickname: "현우")
		.environmentObject(vm)
}
