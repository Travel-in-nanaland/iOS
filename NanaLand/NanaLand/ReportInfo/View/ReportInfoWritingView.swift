//
//  ReportInfoWritingView.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import SwiftUI
import PhotosUI
import Kingfisher
import UIKit
import CustomAlert

struct ReportInfoWritingView: View {
	@ObservedObject var reportInfoVM: ReportInfoViewModel
	
	@State var content: String = ""
	@State var email: String = ""
	
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []
    @State private var showToast = false
    @State private var toastMessage = ""
    
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
						
                        Text(.addPhoto)
                            .font(.title02_bold)
                            .foregroundColor(.black)
                            .padding(.top, 50)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray2)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                    .padding(.leading, -5)
                                
                                PhotosPicker(
                                    selection: $selectedItems,
                                    maxSelectionCount: 5,
                                    matching: .images,
                                    photoLibrary: .shared()
                                ) {
                                    if reportInfoVM.imageCnt == 5{
                                        Button { // 사진이 5장인 상태(최대상태) 에서 또 클릭 할 시 토스트 메시지 띄우기
                                            toastMessage = "사진은 최대 5장까지 선택 가능합니다"
                                            showToast = true
                                        } label: {
                                            VStack {
                                                Image(systemName: "camera")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 26)
                                                Text("\(reportInfoVM.imageCnt) / 5")
                                                    .font(.gothicNeo(.light, size: 15))
                                            }
                                            .foregroundColor(.white)
                                        }
                                    }
                                    else {
                                        VStack {
                                            Image(systemName: "camera")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 26)
                                            Text("\(reportInfoVM.imageCnt) / 5")
                                                .font(.gothicNeo(.light, size: 15))
                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                                .padding(.leading, -5)
                            }
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(Array(selectedImageData.enumerated()), id: \.element) { index, imageData in
                                        if let uiImage = UIImage(data: imageData) {
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .cornerRadius(8)
                                                
                                                Button {
                                                    selectedImageData.remove(at: index)
                                                    selectedItems.remove(at: index)
                                                    reportInfoVM.updateImageCount(selectedImageData.count)
                                                } label: {
                                                    Image("icRemovePhoto")
                                                        .padding(.trailing, 2)
                                                        .padding(.top, 2)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 20))
					}
					.padding(.horizontal, 16)
                    .padding(.top, 20)
					.padding(.bottom, 8)
                    .onChange(of: selectedItems) { newItems in
                        Task {
                            
                            selectedImageData.removeAll()
                            for newItem in newItems {
                                if let data = try? await newItem.loadTransferable(type: Data.self) {
                                    if selectedImageData.count < 5 {
                                        selectedImageData.append(data) // 선택된 이미지 추가
                                    }
                                }
                    
                            }
                            reportInfoVM.updateImageCount(selectedImageData.count)
                        }
                    }
                    .overlay(
                        Toast(message: toastMessage, isShowing: $showToast, isAnimating: true)
                    )
					
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
					await reportInfoVM.action(.onTapSendButton(image: selectedImageData, content: content, email: email))
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
