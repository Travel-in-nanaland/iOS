//
//  SplashView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI
import Lottie

struct SplashView: View {
    var body: some View {
        ZStack {
            GifImageView(name: "splash")
        }
    }
}

#Preview {
    SplashView()
}
