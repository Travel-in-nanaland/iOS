//
//  ReportInfoWritingView.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import SwiftUI
import PhotosUI

struct ReportInfoWritingView: View {
	@ObservedObject var reportInfoVM: ReportInfoViewModel
	
	@State var content: String = ""
	@State var email: String = ""
	
	@State var pickedItem: PhotosPickerItem?
	@State var pickedImage: Foundation.Data?
	
	enum FocusField {
		case content
		case email
	}
	@FocusState var focusedField: FocusField?
	
	
	var body: some View {
		VStack(spacing: 0) {
			NanaNavigationBar(title: .reportInfo, showBackButton: true)
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 0) {
					// TODO: 커스텀 앨범으로 변경
					PhotosPicker(selection: $pickedItem, matching: .images, label: {
						if let imageData = pickedImage,
						   let uiImage = UIImage(data: imageData) {
							Image(uiImage: uiImage)
								.resizable()
								.aspectRatio(contentMode: .fill)
								.overlay {
									Image(.icCamera)
										.resizable()
										.frame(width: 56, height: 56)
										.foregroundStyle(Color.baseWhite)

								}
							
						} else {
							ZStack(alignment: .center) {
								Rectangle()
									.fill(Color(hex: 0xC9C9C9))
									.frame(width: Constants.screenWidth, height: Constants.screenWidth / 9 * 5)
								
								VStack(spacing: 0) {
									Image(.icCamera)
										.resizable()
										.frame(width: 56, height: 56)
										.foregroundStyle(Color.baseWhite)
									
									Text(.addPhoto)
										.font(.body_bold)
										.foregroundStyle(Color.baseWhite)
										.padding(.bottom, 4)
									
									Text(.addPhotoDescription)
										.multilineTextAlignment(.center)
										.font(.caption)
										.foregroundStyle(Color.baseWhite)
								}
							}
						}
					})
					.tint(.main)
					.frame(width: Constants.screenWidth, height: Constants.screenWidth / 9 * 5)
					.clipped()
					.padding(.bottom, 24)
					.onChange(of: pickedItem) { item in
						if item == nil {return}
						
						Task {
							if let image = try? await item?.loadTransferable(type: Foundation.Data.self) {
								let compressedImage = UIImage(data: image)?.jpegData(compressionQuality: 0.2)
								pickedImage = compressedImage
							} else {
								print("image load failed")
							}
						}
					}
					
					VStack(alignment: .leading, spacing: 0) {
						Text(.reportInfoContentTitle)
							.font(.title02_bold)
							.padding(.bottom, 8)
						
						ZStack {
							RoundedRectangle(cornerRadius: 12)
								.stroke(Color.gray2, lineWidth: 1)
							
							if content.isEmpty {
								TextEditor(text: .constant(LocalizedKey.reportInfoContentPlaceHolder.localized(for: LocalizationManager.shared.language)))
									.padding(.horizontal, 16)
									.padding(.top, 10)
									.foregroundStyle(Color.gray2)
									.scrollContentBackground(.hidden)
									.font(.body02)
									.disabled(true)
							}
							TextEditor(text: $content)
								.focused($focusedField, equals: .content)
								.padding(.horizontal, 16)
								.padding(.top, 10)
								.scrollContentBackground(.hidden)
								.font(.body02)
						}
						.frame(height: 120)
						.padding(.bottom, 48)
						
						Text(.email)
							.font(.title02_bold)
							.padding(.bottom, 4)
						
						Text(.reportInfoEmailDescription)
							.font(.body02)
							.foregroundStyle(Color(hex: 0x717171))
							.padding(.bottom, 8)
						
						ZStack {
							RoundedRectangle(cornerRadius: 12)
								.stroke(reportInfoVM.state.showEmailErrorMessage ? Color.warning : Color.gray2, lineWidth: 1)
							
							if email.isEmpty {
								TextEditor(text: .constant("aaaaaaa@naver.com"))
									.padding(.horizontal, 16)
									.padding(.top, 6)
									.foregroundStyle(Color.gray2)
									.font(.body02)
									.disabled(true)
							}
							TextEditor(text: $email)
								.focused($focusedField, equals: .email)
								.padding(.horizontal, 16)
								.padding(.top, 6)
								.lineLimit(1)
								.scrollContentBackground(.hidden)
								.font(.body02)
                                .onChange(of: email) { newValue in
                                    if newValue.isValidEmail() {
                                        reportInfoVM.state.showEmailErrorMessage = false
                                    } else {
                                        reportInfoVM.state.showEmailErrorMessage = true
                                    }
                                }
						}
						.frame(height: 48)
						
					}
					.padding(.horizontal, 16)
					.padding(.bottom, 8)
        
					if reportInfoVM.state.showEmailErrorMessage {
						HStack(spacing: 4) {
							Image(.icWarningCircle)
								.resizable()
								.frame(width: 20, height: 20)
								.foregroundStyle(Color.warning)
							
							Text(.invalidEmail)
								.font(.gothicNeo(.medium, size: 12))
								.foregroundStyle(Color.warning)
							
							Spacer()
						}
						.padding(.horizontal, 16)
					}
					
					Spacer()
						.frame(height: 100)
				}
			}
			
			Button(action: {
				Task {
					await reportInfoVM.action(.onTapSendButton(image: [pickedImage], content: content, email: email))
				}
			}, label: {
				RoundedRectangle(cornerRadius: 12)
					.fill(Color.main)
					.opacity((!content.isEmpty && !email.isEmpty) ? 1 : 0.1)
					.frame(height: 48)
					.overlay {
						Text(.send)
							.font(.body_bold)
							.foregroundStyle(Color.baseWhite)
					}
			})
			.padding(.horizontal, 16)
			.padding(.bottom, 24)
			
		}
		.toolbar(.hidden, for: .navigationBar)
		.onTapGesture {
			focusedField = nil
		}
		.overlay {
			if reportInfoVM.state.isLoading {
				ProgressView()
			}
		}
	}
	
}

#Preview {
	ReportInfoWritingView(reportInfoVM: ReportInfoViewModel())
}
