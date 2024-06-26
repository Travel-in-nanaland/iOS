//
//  RegisterNicknameAndProfileView.swift
//  NanaLand
//
//  Created by 정현우 on 5/15/24.
//

import SwiftUI
import PhotosUI

struct RegisterNicknameAndProfileView: View {
	@EnvironmentObject var registerVM: RegisterViewModel
	
	@State var pickedItem: PhotosPickerItem?

    var body: some View {
		VStack(spacing: 0) {
			titleText
				.padding(.top, 80)
				.padding(.bottom, 32)
			
			profilePic
				.padding(.bottom, 48)
			
			nicknameTextField
			
			Spacer()
			
			okButton
		}
		.toolbar(.hidden, for: .navigationBar)
		.padding(.bottom, 24)
    }
	
	private var titleText: some View {
		Text(.enterNicknameAndProfile)
			.font(.largeTitle02)
			.foregroundStyle(Color.baseBlack)
			.multilineTextAlignment(.center)
	}
	
	private var profilePic: some View {
		PhotosPicker(selection: $pickedItem, label: {
			if let imageData = registerVM.state.pickedImage,
			   let uiImage = UIImage(data: imageData) {
				Image(uiImage: uiImage)
					.resizable()
					.frame(width: 100, height: 100)
					.aspectRatio(contentMode: .fill)
					.clipShape(Circle())
					.overlay(alignment: .bottomTrailing) {
						Circle()
							.fill(Color.gray2)
							.frame(width: 32, height: 32)
							.overlay {
								Image(.icCamera)
									.resizable()
									.frame(width: 24, height: 24)
									.foregroundStyle(Color.baseWhite)
							}
					}
			} else {
				Circle()
					.fill(Color.gray2)
					.overlay {
						Image(.icCamera)
							.resizable()
							.frame(width: 50, height: 50)
							.foregroundStyle(Color.baseWhite)
					}
			}
		})
		.frame(width: 100, height: 100)
		.onChange(of: pickedItem) { item in
			if item == nil {return}
			
			Task {
				if let image = try? await item?.loadTransferable(type: Foundation.Data.self) {
					let compressedImage = UIImage(data: image)?.jpegData(compressionQuality: 0.2)
					registerVM.state.pickedImage = compressedImage
				} else {
					print("Image load failed")
				}
			}
		}
		
	}
	
	private var nicknameTextField: some View {
		VStack(spacing: 8) {
			HStack {
				Spacer()
				
				Text("\(registerVM.state.nickname.count) / 8 " + .charCount)
					.font(.caption01_semibold)
					.foregroundStyle(registerVM.state.showNicknameError ? Color.warning : Color.gray1)
			}
			
			TextField(text: $registerVM.state.nickname, label: {
				Text(.nicknameTextFieldPlaceHolder)
					.font(.body02)
					.foregroundStyle(Color.gray1)
			})
			.frame(width: Constants.screenWidth-64, height: 48)
			.padding(.horizontal, 16)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.stroke(registerVM.state.showNicknameError ? Color.warning : Color.gray2, lineWidth: 1)
					.frame(width: Constants.screenWidth-32, height: 48)
			)
			
			if registerVM.state.showNicknameError {
				HStack(spacing: 4) {
					Image(.icWarningCircle)
						.resizable()
						.frame(width: 20, height: 20)
						.foregroundStyle(Color.warning)
					
					Text(registerVM.state.nicknameErrorMessage ?? .invalidNickname)
						.font(.gothicNeo(.medium, size: 12))
						.foregroundStyle(Color.warning)
					
					Spacer()
				}
			}
		}
		.padding(.horizontal, 16)
	}
	
	private var okButton: some View {
		Button(action: {
			Task {
				await registerVM.action(.onTapOkButtonInNicknameAndProfile)
			}
		}, label: {
			RoundedRectangle(cornerRadius: 30)
				.fill(Color.main)
				.frame(width: Constants.screenWidth - 32, height: 48)
				.opacity(!registerVM.state.nickname.isEmpty ? 1.0 : 0.1)
				.overlay {
					Text(.confirm)
						.foregroundStyle(Color.baseWhite)
						.font(.body_bold)
				}
		})
	}
}

#Preview {
	@StateObject var lm = LocalizationManager()
	lm.language = .malaysia
	return RegisterNicknameAndProfileView()
		.environmentObject(lm)
		.environmentObject(RegisterViewModel())
    
}
