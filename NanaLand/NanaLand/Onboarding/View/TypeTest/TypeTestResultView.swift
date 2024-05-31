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
	let imageSize = Constants.screenWidth / 9 * 5
	
	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				header
					.padding(.top, 40)
					.padding(.bottom, 32)
				
				contentsPart
					.padding(.bottom, 40)
				
				bottomButtons
					.padding(.bottom, 24)
			}
			.scrollIndicators(.hidden)
		}
		.padding(.vertical, 1)
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
			Image(typeTestVM.state.userType?.image ?? .GAMGYUL_ICECREAM)
				.resizable()
				.frame(width: imageSize, height: imageSize)
				.clipShape(Circle())
			
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
	lm.language = .malaysia
	vm.state.userType = .GAMGYUL_ADE
    return TypeTestResultView(nickname: "현우")
		.environmentObject(lm)
		.environmentObject(vm)
}
