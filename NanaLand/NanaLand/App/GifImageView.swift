//
//  GifImageView.swift
//  NanaLand
//
//  Created by jun on 5/28/24.
//

import SwiftUI
import WebKit
import SDWebImageSwiftUI

struct GifImageView: View {
    let name: String
    var body: some View {
        
        ZStack {
            GeometryReader { geometry in
                if let url = Bundle.main.url(forResource: name, withExtension: "gif") {
                    WebImage(url: url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: Constants.screenHeight)
                        .edgesIgnoringSafeArea(.all)
                    
                } else {
                    Text("GIF 파일을 찾을 수 없습니다.")
                }
            }
            
        
        }
    
        
    }
}

