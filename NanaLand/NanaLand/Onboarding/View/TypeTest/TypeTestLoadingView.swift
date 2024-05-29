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
	@State var jsonName: String = ""
	
    var body: some View {
		VStack(spacing: 0) {
			
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
			jsonName = ["loading_drink", "loading_tangerine"].randomElement()!
			typeTestVM.action(.onAppearLoadingView)
		}
		.toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    TypeTestLoadingView()
		.environmentObject(TypeTestViewModel())
}
