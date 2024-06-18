//
//  ProfileUpdateView.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import SwiftUI
import UIKit
import Kingfisher

struct ProfileUpdateView: View {
    @EnvironmentObject var appState: AppState
    @State private var nickName: String = AppState.shared.userInfo.nickname
	@State private var introduceText: String = AppState.shared.userInfo.description
    @State private var showAlert = false
    @State private var warningLabel = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var duplicateText = "해당 닉네임은 다른사용자가 사용 중입니다."
    @StateObject var viewModel = ProfileUpdateViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    let specialCharacters = CharacterSet.punctuationCharacters.union(.symbols).union(.nonBaseCharacters)
    var body: some View {
        
        VStack(spacing: 0) {
            ZStack {
                NanaNavigationBar(title: .editProfile, showBackButton: false)
                    .padding(.bottom, 16)
                HStack(spacing: 0) {
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image("icLeft")
                            .renderingMode(.template)
                            .foregroundStyle(Color.black)
                    })
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(.deleteAlertTitle), message: Text(.deleteAlertSubTitle), primaryButton: .default(Text(.delete), action: {
                            dismiss()
                        }), secondaryButton: .cancel(Text(.cancel)))
                    }
                    .padding(.leading, 16)
                    Spacer()
                }
                .padding(.bottom, 12)
            }
        }
        .toolbar(.hidden)
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    ZStack() {
                        VStack(spacing: 0) {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    
                            } else {
                                KFImage(URL(string:"\(AppState.shared.userInfo.profileImageUrl)"))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            }
                        }
                        .frame(width: 100, height: 100)
                        VStack(spacing: 0) {
                            Spacer()
                            HStack(spacing: 0) {
                                Spacer()
                                Button(action: {
                                    self.isShowingImagePicker.toggle()
                                    
                                }, label: {
                                    Image("icCamera")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 32, height: 32)
                                        .foregroundStyle(Color.white)
                                        .padding(4)
                                        .background(.gray1)
                                        .clipShape(Circle())
                                })
                                .sheet(isPresented: $isShowingImagePicker) {
                                    ImagePicker(selectedImage: self.$selectedImage)
                                }
                            }
                            .frame(width: 100)
                            
                        }
                        .frame(width: 100, height: 100)
                    }
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 48)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(.nickName)
                                .font(.body_bold)
                            Spacer()
							Text("\(nickName.count) / 8 " + .charCount)
                                .font(.caption01)
                                .foregroundStyle(nickName.count > 8 ? Color.red : Color.gray1)
                            
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .padding(.bottom, 8)
                        
                        VStack(spacing: 0) {
                            TextField("", text: $nickName)
                                .padding(.leading, 16)
                                .frame(width: Constants.screenWidth - 32, height: 49)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray2, lineWidth: 1)
                                )
                                .onChange(of: nickName) { nickName in
                                    // 텍스트가 변경될 때마다 실행되는 코드
                                    viewModel.state.isDuplicate = false
                                }
                            
                            
                            HStack(spacing: 0) {
                                if (nickName.count > 8 || viewModel.state.isDuplicate || containsSpecialCharacter(nickName)) {
                                    Image("icWarningCircle")
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundStyle(Color.red)
                                        .padding(.leading, 16)
                                        .padding(.top, 8)
                                }
                                
                                Text(
                                    (nickName.count > 8 || containsSpecialCharacter(nickName)) ? LocalizedKey.nickNameTypingLimitError.localized(for: localizationManager.language) : (viewModel.state.isDuplicate ? LocalizedKey.nickNameDuplicateError.localized(for: localizationManager.language) : " ")
                                    
                                )
                                    .font(.caption01)
                                    .foregroundStyle(.red)
                                    .padding(.leading, 4)
                                    .padding(.top, 8)
                                    .frame(height: 30)
                                Spacer()
                            }
                        }
                       
                    }
                    .ignoresSafeArea(.keyboard)

                    HStack(spacing: 0) {
                        Text(.introduction)
                            .font(.body_bold)
                        Spacer()
                        Text("\(introduceText.count) / 70 " + .charCount)
                            .font(.caption01)
                            .foregroundStyle(introduceText.count > 70 ? Color.red : Color.gray1)
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
                    .padding(.top, 80)
                    
                    VStack(spacing: 0) {
                        TextEditor(text: $introduceText)
                            .padding()
                            .foregroundColor(Color.black)
                            .font(.body02)
                            .lineSpacing(5) // 줄 간격
                            .frame(width: Constants.screenWidth - 32, height: 80)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(introduceText.count > 70 ? .red : Color.gray2, lineWidth: 1))
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                            .padding(.bottom, 8)
                        if introduceText.count > 70 {
                            HStack(spacing: 0) {
                                Image("icWarningCircle")
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(Color.red)
                                Text(.introduceTypingLimitError)
                                    .font(.caption01)
                                    .foregroundStyle(.red)
                                    .padding(.leading, 4)
                                Spacer()
                            }
                            .padding(.leading, 16)
                        }
                        
                     
                        Spacer()
                    }
                    .ignoresSafeArea(.keyboard)
    
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await updateUserInfo(body: ProfileDTO(nickname: nickName, description: introduceText), multipartFile: [selectedImage?.jpegData(compressionQuality: 0.8)])
                            AppState.shared.userInfo.nickname = viewModel.state.updatedNickName
                            AppState.shared.userInfo.description = viewModel.state.updatedDescription
                            AppState.shared.userInfo.profileImageUrl = viewModel.state.updatedProfilImage
                          // 닉네임 중복이 아니면
                            if (!viewModel.state.isDuplicate) {
                                dismiss()
                            } else {
                                
                            }
                        }
                    }, label: {
                        Text(.complete)
                            .font(.body_bold)
                            .frame(width: Constants.screenWidth - 32, height: 48)
                            .foregroundStyle(.white)
                        
                    })
                    .tint(.baseWhite)
                    .background((nickName.count > 8 || nickName.count == 0) ? Color.main10P : Color.main)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.bottom, 24)
                    .disabled((nickName.count > 8 || nickName.count == 0 || introduceText.count > 70) ? true : false)
                }
                .frame(height: geometry.size.height)
                
            }
        }
       
        
    }
    
    // 문자열에 특수문자가 포함되어 있는지 확인하는 함수
    func containsSpecialCharacter(_ string: String) -> Bool {
        return string.rangeOfCharacter(from: specialCharacters) != nil
    }
    
    func updateUserInfo(body: ProfileDTO, multipartFile: [Foundation.Data?]) async {
        await viewModel.action(.getUpdatedUserInfo(body: ProfileDTO(nickname: body.nickname, description: body.description), multipartFile: multipartFile))
    }
}

#Preview {
    ProfileUpdateView()
}
