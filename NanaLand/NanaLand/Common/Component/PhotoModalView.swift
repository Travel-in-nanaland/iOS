//
//  PhotoModalView.swift
//  NanaLand
//
//  Created by wodnd on 2/14/25.
//

import SwiftUI
import Kingfisher

//사진 선택시 확대 되는 모달 뷰
struct PhotoModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var imageUrl: String
    @State private var localImageUrl: String = ""
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                
                KFImage(URL(string: localImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: Constants.screenWidth * ( 500 / 360))
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(.reduce)
                        .font(.title02_bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
            }
        }
        .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        .ignoresSafeArea()
        .onAppear(){
            localImageUrl = imageUrl
        }
    }
}

#Preview {
    PhotoModalView(imageUrl: .constant(""))
}
