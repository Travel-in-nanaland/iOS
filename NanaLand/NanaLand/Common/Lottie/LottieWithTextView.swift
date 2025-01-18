//
//  LottieWithTextView.swift
//  NanaLand
//
//  Created by wodnd on 1/19/25.
//

import SwiftUI
import Lottie
import UIKit

struct LottieViewWithText: View {
    var name: String
    var loopMode: LottieLoopMode
    var message: String
    
    init(jsonName: String, message: String, loopMode: LottieLoopMode = .loop) {
        self.name = jsonName
        self.loopMode = loopMode
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 0) { // 애니메이션과 텍스트 사이 간격 설정
            // Lottie 애니메이션
            LottieAnimationViewRepresentable(name: name, loopMode: loopMode)
                .frame(width: Constants.screenWidth * (200 / 360), height: Constants.screenWidth * (200 / 360)) // 애니메이션 크기 조정
            
            // 텍스트 추가
            Text(message)
                .font(.body01) // 굵은 글씨체
                .foregroundColor(.white) // 텍스트 색상
                .multilineTextAlignment(.center) // 텍스트 가운데 정렬
        }
    }
}

// Lottie 애니메이션을 보여주는 Helper Struct
struct LottieAnimationViewRepresentable: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(name)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit // 애니메이션 비율 유지
        animationView.loopMode = loopMode
        animationView.play() // 애니메이션 실행
        animationView.backgroundBehavior = .pauseAndRestore // 백그라운드에서도 유지
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

#Preview {
    LottieViewWithText(
        jsonName: "loading", // Lottie 파일 이름
        message: "잠시만 기다려 주세요!\n여러분의 경험이\nNanaLand로 전달 중입니다 💜", // 메시지
        loopMode: .loop // 반복 설정
    )
}
