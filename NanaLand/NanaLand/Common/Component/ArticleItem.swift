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
        VStack(alignment: .leading, spacing: 8){
            ZStack {
                KFImage(URL(string: article.firstImage.originUrl))
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if let onGoing = article.onGoing, !onGoing {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.black.opacity(0.4))
                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                        .overlay(
                            Text("내년에 다시 만나요🖐")
                                .font(.body02_bold)
                                .foregroundColor(.white)
                        )
                }
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        Button {
                            onTapHeart()
                            
                        } label: {
                            article.favorite ?? false ?  Image("icHeart_Fill").animation(nil) : Image("icHeart_Blank").animation(nil)
                        }
                    }
                    .padding(.top, 8)
                    Spacer()
                }
                .padding(.trailing, 8)
            }
            
            Text(article.title)
                .font(.body02_semibold)
                .foregroundStyle(.black)
                .lineLimit(1)
            
            Spacer()
        }
        
        //        VStack(alignment: .leading, spacing: 8) {
        //            KFImage(URL(string: article.firstImage.originUrl))
        //                .resizable()
        //                .aspectRatio(contentMode: .fill)
        //                .frame(width: itemWidth, height: itemWidth*120/175)
        //                .clipped()
        //                .clipShape(RoundedRectangle(cornerRadius: 12))
        //
        //            Text(article.title)
        //                .font(.gothicNeo(.bold, size: 14))
        //                .foregroundStyle(Color.baseBlack)
        //                .lineLimit(1)
        //                .truncationMode(.tail) // 글자가 길 경우 ...으로 표시
        //                .frame(width: itemWidth, alignment: .leading) // 너비를 지정하고 왼쪽 정렬
        //                .multilineTextAlignment(.leading) // 왼쪽 정렬 추가
        //        }
        //        .overlay(alignment: .topTrailing) {
        //            Button(action: {
        //                onTapHeart()
        //            }, label: {
        //                Image(article.favorite ? .icHeartFillMain : .icHeartDefault)
        //                    .padding(.top, 4)
        //                    .padding(.trailing, 4)
        //            })
        //        }
    }
}
#Preview {
    ArticleItem(category: .activity, article: Article(id: 0, firstImage: ArticleImageList(originUrl: "http://tong.visitkorea.or.kr/cms/resource/85/3076985_image3_1.jpg", thumbnailUrl: "http://tong.visitkorea.or.kr/cms/resource/85/3076985_image3_1.jpg"), title: "근하신뇽! 새해도 9.81파크와 함께해용", favorite: true, category: .activity, onGoing: false), onTapHeart: {})
}
