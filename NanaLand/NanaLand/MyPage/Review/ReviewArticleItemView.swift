//
//  ProfileArticleItemView.swift
//  NanaLand
//
//  Created by wodnd on 7/25/24.
//


import SwiftUI
import Kingfisher

struct ReviewArticleItemView: View {
    
    var placeName: String
    var createdAt: String
    var heartCount: Int64
    var imageFileDto: String
    
    var body: some View {
        VStack{
            ZStack{
                if imageFileDto != "" {
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
                                KFImage(URL(string: imageFileDto))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 160, height: 160)
                                    .background(.blue)
                                    .cornerRadius(8)
                                
                                VStack{
                                    HStack{
                                        Text(placeName)
                                            .font(.body02_bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 5)
                                    .padding(.leading, 15)
                                    
                                    HStack{
                                        Text(createdAt)
                                            .font(.caption01)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.main)
                                        
                                        Text("\(heartCount)")
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
                                    Text(placeName)
                                        .font(.body02_bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                }
                                
                                Spacer()
                                
                                HStack{
                                    Text(createdAt)
                                        .font(.caption01)
                                        .foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.main)
                                    
                                    Text("\(heartCount)")
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
    ReviewArticleItemView(placeName: "", createdAt: "", heartCount: 3, imageFileDto: "")
}
