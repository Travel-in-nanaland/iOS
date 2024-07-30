//
//  ProfileArticleItemView.swift
//  NanaLand
//
//  Created by wodnd on 7/25/24.
//


import SwiftUI
import Kingfisher

struct ReviewArticleItemView: View {
    
    var review: ProfileMainModel.Review
    
    var body: some View {
        VStack{
            ZStack{
                if !review.images.isEmpty {
                    Rectangle()
                        .frame(width: 160, height: 220)
                        .foregroundColor(.white)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 8,
                                bottomLeadingRadius: 8,
                                bottomTrailingRadius: 8,
                                topTrailingRadius: 8
                            )
                        )
                        .shadow(radius: 1)
                        .overlay(
                            VStack{
                                KFImage(URL(string: ("")))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 160, height: 160)
                                    .background(.blue)
                                    .cornerRadius(8)
                                
                                VStack{
                                    HStack{
                                        Text(review.placeName)
                                            .font(.body02_bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.leading, 15)
                                    
                                    HStack{
                                        Text(review.createdAt)
                                            .font(.caption01)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.main)
                                        
                                        Text("\(review.heartCount)")
                                            .font(.caption01)
                                            .foregroundColor(.black)
                                            .padding(.leading, -5)
                                            .padding(.trailing, 15)
                                    }
                                }
                                
                                Spacer()
                            }
                        )
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 160, height: 90)
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .overlay(
                            VStack{
                                HStack{
                                    Text(review.placeName)
                                        .font(.body02_bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                HStack{
                                    Text(review.content)
                                        .font(.caption01)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.main)
                                    
                                    Text("\(review.heartCount)")
                                        .font(.caption01)
                                        .foregroundColor(.black)
                                        .padding(.leading, -5)
                                }
                            }.padding()
                        )
                }
            }
        }
    }
}

#Preview {
    ReviewArticleItemView(review: ProfileMainModel.Review(id: 1, postId: 1, category: "", placeName: "", rating: 3, content: "", createdAt: "", heartCount: 2, images: ["" : ""], reviewTypeKeywords: [""]))
}
