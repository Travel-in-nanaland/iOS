
//
//  ReviewDetailArticleItemView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI
import Kingfisher

struct MyReviewArticleItemView: View {
    
    var review: ProfileMainModel.Review

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Text(review.placeName)
                        .font(.body02_bold)
                        .foregroundColor(.black)

                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 3, height: 11)

                    Spacer()

                    Button(action: {

                    }, label: {
                        Text("수정")
                            .foregroundColor(.gray1)
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.gray3)
                            }
                    })

                    Button(action: {

                    }, label: {
                        Text("삭제")
                            .foregroundColor(.gray1)
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.gray3)
                            }
                    })
                }
                .padding()

                HStack {
                    ForEach(1...5, id: \.self) { number in
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                            .foregroundColor(number <= review.rating ? .yellow : .gray)
                    }

                    Spacer()
                }
                .padding(.top, -20)
                .padding(.leading, 15)

                if !review.images.isEmpty {
                    KFImage(URL(string: ("")))
                        .resizable()
                        .frame(width: 70, height: 70)
                        .cornerRadius(8)
                        .padding()
                        .padding(.top, -20)
                }

                HStack {
                    Text(review.content)
                        .font(.body02)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer()
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .padding(.top, -10)

                TagsCloudView(tags: review.reviewTypeKeywords)
                    .padding(.leading, 15)
                    .padding(.trailing, 15)
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(.main)
                    
                    Text("\(review.heartCount)")
                        .font(.body02)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(review.createdAt)
                        .font(.caption01)
                        .foregroundColor(.gray1)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
            }
            .padding(.bottom, 20)
            .background(){
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 1)
            }
        }
    }
}

struct TagsCloudView: View {
    var tags: [String]

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        VStack {
            GeometryReader { geo in
                self.generateContent(in: geo)
            }
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geo: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > geo.size.width) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if tag == tags.last! {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if tag == tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }

    private func item(for tag: String) -> some View {
        Text("#\(tag)")
            .font(.caption01)
            .foregroundColor(.main)
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

#Preview {
    MyReviewArticleItemView(review: ProfileMainModel.Review(id: 1, postId: 1, category: "NaNa", placeName: "연돈", rating: 3, content: "테스트입니다.", createdAt: "2024-06-12", heartCount: 3, images: ["" : ""], reviewTypeKeywords: [""]))
}
