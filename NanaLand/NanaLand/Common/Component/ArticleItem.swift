//
//  ArticleItem.swift
//  NanaLand
//
//  Created by 정현우 on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ArticleItem: View {
    let category: Category
    let article: Article
    let onTapHeart: () -> Void
    
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
                .truncationMode(.tail) // 글자가 길 경우 ...으로 표시
                .frame(width: itemWidth, alignment: .leading) // 너비를 지정하고 왼쪽 정렬
                .multilineTextAlignment(.leading) // 왼쪽 정렬 추가
        }
        .overlay(alignment: .topTrailing) {
            Button(action: {
                onTapHeart()
            }, label: {
                Image(article.favorite ? .icHeartFillMain : .icHeartDefault)
                    .padding(.top, 4)
                    .padding(.trailing, 4)
            })
        }
    }
	}
}

#Preview {
    ArticleItem(category: .experience, article: Article(id: 0, thumbnailUrl: "http://tong.visitkorea.or.kr/cms/resource/85/3076985_image3_1.jpg", title: "근하신뇽! 새해도 9.81파크와 함께해용", favorite: true, category: .experience), onTapHeart: {})
}
