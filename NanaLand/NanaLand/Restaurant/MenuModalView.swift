//
//  MenuModalView.swift
//  NanaLand
//
//  Created by wodnd on 8/25/24.
//

import SwiftUI
import Kingfisher

struct MenuModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var imageUrl: String
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("축소하기")
                        .font(.title02_bold)
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
            }
        }
        .frame(width: Constants.screenWidth, height: Constants.screenHeight)
        .ignoresSafeArea()
    }
}

#Preview {
    MenuModalView(imageUrl: "")
}
