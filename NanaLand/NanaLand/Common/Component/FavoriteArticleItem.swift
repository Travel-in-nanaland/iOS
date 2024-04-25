//
//  FavoriteArticleItem.swift
//  NanaLand
//
//  Created by 정현우 on 4/24/24.
//

import SwiftUI
import Kingfisher

struct FavoriteArticleItem: View {
	@EnvironmentObject var favoriteVM: FavoriteViewModel
	let index: Int
	let tab: Category
	let article: FavoriteArticle
	
	let itemWidth = (Constants.screenWidth-40)/2
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			KFImage(URL(string: article.thumbnailUrl))
				.resizable()
				.aspectRatio(contentMode: .fill)
				.frame(width: itemWidth, height: itemWidth*120/175)
				.clipped()
				.clipShape(RoundedRectangle(cornerRadius: 12))
			
			Text(article.title)
				.font(.gothicNeo(.bold, size: 14))
				.foregroundStyle(Color.baseBlack)
				.lineLimit(1)
		}
		.overlay(alignment: .topTrailing) {
			Button(action: {
				Task {
					await favoriteVM.action(.deleteItemInFavoriteList(index: index, category: tab))
				}
			}, label: {
				Image(.icHeartFillMain)
					.padding(.top, 4)
					.padding(.trailing, 4)
			})
		}
	}
	
}

#Preview {
	FavoriteArticleItem(index: 0, tab: .all, article: FavoriteArticle(id: 0, title: "근하신뇽! 새해도 9.81파크와 함께해용", thumbnailUrl: "http://tong.visitkorea.or.kr/cms/resource/85/3076985_image3_1.jpg", category: "MARKET"))
}
