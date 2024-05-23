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
			NanaNavigationBar(title: String(localized: "modifyInfo"), showBackButton: true)
			
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
									
									Text("사진 추가하기")
										.font(.body_bold)
										.foregroundStyle(Color.baseWhite)
										.padding(.bottom, 4)
									
									Text("실제 확인한 정보를 사진과 함께 첨부해주시면,\n좀 더 정확한 정보가 완성되어요")
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
						Text("정보 수정 제안")
							.font(.title02_bold)
							.padding(.bottom, 8)
						
						TextEditor(text: $content)
							.focused($focusedField, equals: .content)
							.padding(.horizontal, 16)
							.padding(.top, 12)
							.frame(height: 120)
							.background {
								RoundedRectangle(cornerRadius: 12)
									.stroke(Color.gray2, lineWidth: 1)
							}
							.scrollContentBackground(.hidden)
							.font(.body02)
							.overlay(alignment: .topLeading) {
								if content.isEmpty {
									Text("수정 요청하신 항목의 상세 내용이나 그 외 기타 사항이 있으시면 의견을 남겨주세요.")
										.padding(.top, 16)
										.padding(.horizontal, 16)
										.font(.body02)
										.foregroundStyle(Color.gray2)
										.multilineTextAlignment(.leading)
								}
							}
							.padding(.bottom, 48)
						
						Text("이메일")
							.font(.title02_bold)
							.padding(.bottom, 4)
						
						Text("정보 수정 제안 결과를 받을 이메일을 입력해주세요")
							.font(.body02)
							.foregroundStyle(Color(hex: 0x717171))
							.padding(.bottom, 8)
						
						TextEditor(text: $email)
							.focused($focusedField, equals: .email)
							.padding(.horizontal, 16)
							.padding(.top, 12)
							.frame(height: 48)
							.background {
								RoundedRectangle(cornerRadius: 12)
									.stroke(reportInfoVM.state.showEmailErrorMessage ? Color.warning : Color.gray2, lineWidth: 1)
							}
							.lineLimit(1)
							.scrollContentBackground(.hidden)
							.font(.body02)
							.overlay(alignment: .topLeading) {
								if email.isEmpty {
									Text(verbatim: "aaaaaaa@naver.com")
										.padding(.top, 16)
										.padding(.horizontal, 16)
										.font(.body02)
										.foregroundStyle(Color.gray2)
										.multilineTextAlignment(.leading)
								}
							}
					}
					.padding(.horizontal, 16)
					.padding(.bottom, 8)
					
					if reportInfoVM.state.showEmailErrorMessage {
						HStack(spacing: 4) {
							Image(.icWarningCircle)
								.resizable()
								.frame(width: 20, height: 20)
								.foregroundStyle(Color.warning)
							
							Text("이메일 형식이 잘못 되었습니다. 다시 입력해 주세요!")
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
						Text("보내기")
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
