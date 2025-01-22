//
//  NewNanaPickSpecialModalView.swift
//  NanaLand
//
//  Created by wodnd on 9/3/24.
//

import SwiftUI

struct NewNanaPickSpecialModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var content: String
    var body: some View {
        VStack(spacing: 0){
            HStack(spacing: 0){
                ZStack {
                    HStack(spacing: 0) {
                        Text(.locationPoint)
                            .font(.title02_bold)
                            .foregroundColor(.black)
                        Text("✨")
                            .font(.title02_bold)
                      
                    }
                }
                
                Spacer()
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("icSpecialBack")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.screenWidth * (32 / 360))
                }
            }
            .frame(width: Constants.screenWidth * (296 / 360))
            
            Text(content)
                .font(.body02)
                .frame(width: Constants.screenWidth * (296 / 360))
                .lineSpacing(10)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .padding(.top, Constants.screenWidth * (32 / 360))
        }
        .padding(.leading, Constants.screenWidth * (32 / 360))
        .padding(.trailing, Constants.screenWidth * (32 / 360))
        .padding(.top, Constants.screenWidth * (24 / 360))
        .padding(.bottom, Constants.screenWidth * (16 / 360))
        .background(){
            RoundedRectangle(cornerRadius: 10)
                .frame(width: Constants.screenWidth * (328 / 360))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    NewNanaPickSpecialModalView(content: .constant("높은 장소성 :넓은 마당과, 도립공원,오설록등 곳곳에 펼쳐진 제주 명소속에서 프라이빗한 독채 한옥을 즐길수 있다.\n침실 : 고재에서 풍겨오는 은은한 나무향과 한지와 같은 전통 소재를 활용한 전통성, 한편으론 편의를 위해 마련된 프리미엄 브랜드 소재의 침구"))
}
