//
//  TypeTestLoadingView.swift
//  NanaLand
//
//  Created by 정현우 on 5/28/24.
//

import SwiftUI
import Lottie

struct TypeTestLoadingView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let jsonName: String = ["loading_drink", "loading_tangerine"].randomElement()!
	
    var body: some View {
		VStack(spacing: 4) {
			LottieView(jsonName: jsonName, loopMode: .loop)
				.frame(height: 250)
			
			Text(.tangerineJuiced)
				.font(.largeTitle02)
				.foregroundStyle(Color.main)
			
			Text(.juiceCommingSoon)
				.font(.title2)
				.foregroundStyle(Color.black)
				.multilineTextAlignment(.center)
		}
		.onAppear {
			typeTestVM.action(.onAppearLoadingView)
		}
		.toolbar(.hidden, for: .navigationBar)
		.offset(y: -40)
    }
}

#Preview {
    TypeTestLoadingView()
		.environmentObject(TypeTestViewModel())
}
