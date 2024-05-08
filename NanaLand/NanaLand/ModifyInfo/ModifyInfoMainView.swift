//
//  ModifyInfoMainView.swift
//  NanaLand
//
//  Created by 정현우 on 5/7/24.
//

import SwiftUI

struct ModifyInfoCategory: Hashable {
	let imageName: ImageResource
	let title: String
}

struct ModifyInfoMainView: View {
	let categories: [ModifyInfoCategory] = [
		ModifyInfoCategory(imageName: .icPhone, title: String(localized: "numberAndHompage")),
		ModifyInfoCategory(imageName: .icClock, title: String(localized: "operatinghour")),
		ModifyInfoCategory(imageName: .icPin, title: String(localized: "placeNameAndLocation")),
		ModifyInfoCategory(imageName: .icMoney, title: String(localized: "priceInfo")),
		ModifyInfoCategory(imageName: .icTrashcan, title: String(localized: "deletePlace"))
	]
	
    var body: some View {
		VStack(spacing: 0) {
			NanaNavigationBar(title: String(localized: "modifyInfo"), showBackButton: true)
				.padding(.bottom, 32)
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 0) {
					Text(String(localized: "suggestInfoModificationTitle"))
						.font(.title01_bold)
						.padding(.bottom, 4)
					
					Text(String(localized: "suggestInfoModificationDescription"))
						.lineLimit(2)
						.font(.body02)
						.padding(.bottom, 27)
						.foregroundStyle(Color(hex: 0x717171))
					
					ForEach(categories, id: \.self) { category in
						NavigationLink(destination: {
							ModifyInfoWritingView()
						}, label: {
							ModifyInfoItemView(category: category)
								.padding(.bottom, 16)
						})
						
					}
					
					Text(String(localized: "shareETCInfo"))
						.font(.title01_bold)
						.padding(.top, 32)
						.padding(.bottom, 16)
					
					NavigationLink(destination: {
						ModifyInfoWritingView()
					}, label: {
						ModifyInfoItemView(category: ModifyInfoCategory(imageName: .icGift, title: String(localized: "provideService")))
					})
					
					
				}
			}
			.padding(.horizontal, 16)
		}
		.toolbar(.hidden, for: .navigationBar)
    }
}

struct ModifyInfoItemView: View {
	let category: ModifyInfoCategory
	
	var body: some View {
		HStack(spacing: 8) {
			Image(category.imageName)
				.resizable()
				.frame(width: 28, height: 28)
				.foregroundStyle(Color.baseBlack)
			
			Text(category.title)
				.font(.body02)
				.foregroundStyle(Color.baseBlack)
			
			Spacer()
			
			Image(.icRight)
				.resizable()
				.frame(width: 24, height: 20)
				.foregroundStyle(Color.baseBlack)
		}
		.padding(.horizontal, 12)
		.frame(height: 48)
		.background {
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color.gray2, lineWidth: 1)
			
		}
		
	}
}

#Preview {
	NavigationStack {
		ModifyInfoMainView()
	}
}
