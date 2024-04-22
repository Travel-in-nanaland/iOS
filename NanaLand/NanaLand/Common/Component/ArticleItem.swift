//
//  ArticleItem.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ArticleItem: View {
	let article: Article
	
	let itemWidth = (Constants.screenWidth-40)/2
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
//			KFImage(URL(string: article.thumbnailUrl))
//				.clipShape(RoundedRectangle(cornerRadius: 12))
//				.frame(width: (Constants.screenWidth-40)/2, height: 148)
			Rectangle()
				.fill(Color.main)
				.clipShape(RoundedRectangle(cornerRadius: 12))
				.frame(width: itemWidth, height: itemWidth*120/175)
			
			Text(article.title)
				.font(.gothicNeo(.bold, size: 14))
				.foregroundStyle(Color.baseBlack)
		}
	}
}

#Preview {
	ArticleItem(article: Article(id: 0, thumbnailUrl: "", title: "", favorite: true))
}
