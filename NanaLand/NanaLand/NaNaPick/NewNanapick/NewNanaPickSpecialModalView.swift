//
//  NewNanaPickSpecialModalView.swift
//  NanaLand
//
//  Created by wodnd on 9/3/24.
//

import SwiftUI

struct NewNanaPickSpecialModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var content: String
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 328, height: 426)
                .foregroundColor(.white)
                .overlay(){
                    VStack(spacing: 0){
                        HStack(spacing: 0){
                            Text("이 장소만의 매력 포인트✨")
                                .font(.title02_bold)
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image("icSpecialBack")
                            }
                        }
                        
                        Text(content)
                            .font(.body02)
                            .foregroundColor(.black)
                            .padding(.top, 32)
                        
                        Spacer()
                    }
                    .padding()
                }
            
            
        }
        .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        .ignoresSafeArea()
    }
}

#Preview {
    NewNanaPickSpecialModalView(content: "높은 장소성 :넓은 마당과, 도립공원,오설록등 곳곳에 펼쳐진 제주 명소속에서 프라이빗한 독채 한옥을 즐길수 있다.\n침실 : 고재에서 풍겨오는 은은한 나무향과 한지와 같은 전통 소재를 활용한 전통성, 한편으론 편의를 위해 마련된 프리미엄 브랜드 소재의 침구")
}
