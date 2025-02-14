//
//  SplashView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI
import Lottie

struct SplashView: View {
    
    let splashs: [String] = ["splash_01", "splash_02", "splash_03", "splash_04"]
    @State private var splash: String = "splash_01"
    
    var body: some View {
        ZStack {
//            GifImageView(name: "splash")
            GeometryReader { geometry in
                Image(splash)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: Constants.screenHeight)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear(){
            splash = splashs.randomElement() ?? "splash_01" // 기본값을 제공하여 안전하게 처리
        }
    }
}

#Preview {
    SplashView()
}
