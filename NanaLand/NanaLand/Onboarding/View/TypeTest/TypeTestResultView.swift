//
//  TypeTestResultView.swift
//  NanaLand
//
//  Created by 정현우 on 5/17/24.
//

import SwiftUI

struct TypeTestResultView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let nickname: String
	
    var body: some View {
		VStack(spacing: 0) {
			header
				.padding(.top, 54)
			
			Spacer()
			
			bottomButtons
				.padding(.bottom, 24)
		}
		.toolbar(.hidden, for: .navigationBar)
    }
	
	private var header: some View {
		VStack(spacing: 8) {
			Text("\(nickname) 님의 여행 유형은")
				.font(.gothicNeo(.bold, size: 16))
				.foregroundStyle(Color.baseBlack)
			
			Text(typeTestVM.state.userType?.rawValue ?? "")
				.font(.gothicNeo(.bold, size: 28))
				.foregroundStyle(Color.main)
		}
	}
	
	private var bottomButtons: some View {
		VStack(spacing: 16) {
			Button(action: {
				typeTestVM.action(.onTapGotoMainViewButton)
			}, label: {
				RoundedRectangle(cornerRadius: 30)
					.fill(Color.main)
					.frame(height: 48)
					.overlay {
						Text("메인 화면 바로가기")
							.foregroundStyle(Color.baseWhite)
							.font(.body_bold)
					}
			})
		}
		.padding(.horizontal, 16)
	}
}

#Preview {
    TypeTestResultView(nickname: "123")
}
