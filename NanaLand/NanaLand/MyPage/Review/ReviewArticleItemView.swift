//
//  ProfileArticleItemView.swift
//  NanaLand
//
//  Created by wodnd on 7/25/24.
//


import SwiftUI
import Kingfisher

struct ReviewArticleItemView: View {
    
    var id: Int64
    @Binding var deleteId: Int64
    var category: String
    var placeName: String
    var createdAt: String
    var heartCount: Int64
    var imageFileDto: String
    @Binding var isShowingModify: Bool
    
    var body: some View {
        VStack{
            ZStack{
                if imageFileDto != "" {
                    Rectangle()
                        .frame(width: Constants.screenWidth * (160 / 360), height: Constants.screenWidth * (214 / 360))
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
                            VStack(spacing: 0){
                                KFImage(URL(string: imageFileDto))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: Constants.screenWidth * (160 / 360), height: Constants.screenWidth * (136 / 360))
                                    .clipShape(
                                        .rect(
                                            topLeadingRadius: 8,
                                            bottomLeadingRadius: 0,
                                            bottomTrailingRadius: 0,
                                            topTrailingRadius: 8
                                        )
                                    )
                                
                                VStack(spacing: 0){
                                    HStack(spacing: 0){
                                        Text(getLocalizedCategory(for: category))
                                            .font(.caption02)
                                            .foregroundColor(.main)
                                            .padding(EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6))
                                            .background(){
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundColor(.main10P)
                                            }
                                        
                                        Spacer()
                                        
                                        Button {
                                            deleteId = id
                                            isShowingModify.toggle()
                                        } label: {
                                            Image("ReviewModifyDot")
                                                .resizable()
                                                .frame(width: Constants.screenWidth * (20 / 360), height: Constants.screenWidth * (20 / 360))
                                        }
                                        .padding(.trailing, -Constants.screenWidth * (10/360))

                                    }
                                    .padding(.top, 5)
                                    
                                    Button(action: {
                                        AppState.shared.navigationPath.append(MyPageViewType.selectReview(id: id))
                                    }, label: {
                                        HStack(spacing: 0){
                                            Text(placeName)
                                                .font(.body02_semibold)
                                                .foregroundColor(.black)
                                            
                                            Spacer()
                                        }
                                    })
                                    
                                    Spacer()
                                    
                                    HStack(spacing: 0){
                                        Text(createdAt)
                                            .font(.caption01)
                                            .foregroundColor(.gray1)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "heart.fill")
                                            .foregroundColor(.main)
                                        
                                        Text("\(heartCount)")
                                            .font(.caption01)
                                            .foregroundColor(.black)

                                    }
                                    .padding(.bottom, 10)
                                }
                                .padding(.trailing)
                                .padding(.leading)
                                
                            }
                        )
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: Constants.screenWidth * (160 / 360), height: Constants.screenWidth * (103 / 360))
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .overlay(
                            VStack(spacing: 0){
                                HStack(spacing: 0){
                                    Text(getLocalizedCategory(for: category))
                                        .font(.caption02)
                                        .foregroundColor(.main)
                                        .padding(EdgeInsets(top: 3, leading: 6, bottom: 3, trailing: 6))
                                        .background(){
                                            RoundedRectangle(cornerRadius: 30)
                                                .foregroundColor(.main10P)
                                        }
                                    
                                    Spacer()
                                    
                                    Button {
                                        deleteId = id
                                        isShowingModify.toggle()
                                    } label: {
                                        Image("ReviewModifyDot")
                                            .resizable()
                                            .frame(width: Constants.screenWidth * (20 / 360), height: Constants.screenWidth * (20 / 360))
                                    }
                                    .padding(.trailing, -Constants.screenWidth * (10/360))
                                }
                                .padding(.top, 8)
                                
                                Button(action: {
                                    AppState.shared.navigationPath.append(MyPageViewType.selectReview(id: id))
                                }, label: {
                                    HStack(spacing: 0){
                                        Text(placeName)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .font(.body02_bold)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                    }
                                    .padding(.top, 2)
                                })
                                
                                Spacer()
                                
                                HStack(spacing: 0){
                                    Text(createdAt)
                                        .frame(height: 16)
                                        .font(.caption01)
                                        .foregroundColor(.gray1)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.main)
                                    
                                    Text("\(heartCount)")
                                        .font(.caption01)
                                        .foregroundColor(.black)
                                }
                                .padding(.bottom, 10)
                            }.padding(.trailing)
                                .padding(.leading)
                        
                        )
                }
            }
        }
    }
    
    /// 서버에서 받아온 `category`를 번역된 텍스트로 반환
    func getLocalizedCategory(for category: String) -> String {
        if let localizedKey = LocalizedKey(rawValue: category.lowercased()) {
            return localizedKey.localized(for: LocalizationManager.shared.language)
        } else {
            return category // 매핑되지 않는 경우 기본값 반환
        }
    }
}

#Preview {
    ReviewArticleItemView(id: 0, deleteId: .constant(1) ,category: "", placeName: "", createdAt: "", heartCount: 3, imageFileDto: "", isShowingModify: .constant(false))
}
