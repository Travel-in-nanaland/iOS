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
				.padding(.top, 40)
				.padding(.bottom, 32)
			
			Spacer(minLength: 0)
			contentsPart
			Spacer(minLength: 0)
			
			bottomButtons
				.padding(.bottom, 24)
		}
		.toolbar(.hidden, for: .navigationBar)
    }
	
	private var header: some View {
		VStack(spacing: 8) {
			Text(.yourTravelStyleIs, arguments: [nickname])
				.font(.body01)
				.foregroundStyle(Color.baseBlack)
			
			Text(typeTestVM.state.userType?.localizedKey ?? .GAMGYUL)
				.font(.largeTitle01)
				.foregroundStyle(Color.main)
		}
	}
	
	private var contentsPart: some View {
		VStack(spacing: 32) {
			Rectangle()
				.fill(Color.gray2)
				.frame(width: Constants.screenWidth, height: Constants.screenWidth/3*2)
			
			Text(typeTestVM.state.userType?.descriptionLocalizedKey ?? .GAMGYUL_DESCRIPTION)
				.foregroundColor(Color.main)
			+
			Text("\n\n")
			+
			Text(.nanalandMadeYouJuice)
				.foregroundColor(Color.baseBlack)
			
		}
		.font(.body01)
		.multilineTextAlignment(.center)
	}
	
	private var bottomButtons: some View {
		VStack(spacing: 16) {
			Button(action: {

			}, label: {
				RoundedRectangle(cornerRadius: 50)
					.stroke(Color.main, lineWidth: 1)
					.frame(height: 48)
					.overlay {
						Text(typeTestVM.state.userType?.localizedKey ?? .GAMGYUL)
							.font(.body_bold)
							.foregroundColor(Color.main)
						+
						Text(" ")
						+
						Text(.destination)
							.font(.body_bold)
							.foregroundColor(Color.main)
					}
			})
			
			Button(action: {
				typeTestVM.action(.onTapGotoMainViewButton)
			}, label: {
				RoundedRectangle(cornerRadius: 30)
					.fill(Color.main)
					.frame(height: 48)
					.overlay {
						Text(.gotoMainScreen)
							.foregroundStyle(Color.baseWhite)
							.font(.body_bold)
					}
			})
		}
		.padding(.horizontal, 16)
	}
}

#Preview {
	@StateObject var lm = LocalizationManager()
	@StateObject var vm = TypeTestViewModel()
	lm.setLanguage(.korean)
	vm.state.userType = .GAMGYUL_ADE
    return TypeTestResultView(nickname: "현우")
		.environmentObject(lm)
		.environmentObject(vm)
}
