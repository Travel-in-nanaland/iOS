//
//  ProfileUpdateModal.swift
//  NanaLand
//
//  Created by wodnd on 12/27/24.
//

import SwiftUI

struct ProfileUpdateModal: View {
    @State private var isShowingImagePicker = false
    @Binding var selectedImage: UIImage?
    @Binding var basicProfileName: String?
    @Binding var isBasicProfile: Bool
    
    var arrayBasicProfile: [String] = ["Gray", "LightGray", "DeepBlue", "LightPurple"]
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (96 / 360))
                    .shadow(radius: 1)
                    .foregroundColor(.white)
                    .overlay {
                        VStack(spacing: 21){
                            Button(action: {
                                self.isShowingImagePicker.toggle()
                                isBasicProfile = false
                            }, label: {
                                Text("앨범에서 선택")
                                    .font(.body01)
                                    .frame(height: Constants.screenWidth * (26 / 360))
                                    .foregroundColor(.black)
                            })
                            .sheet(isPresented: $isShowingImagePicker) {
                                ImagePicker(selectedImage: self.$selectedImage)
                            }
                            
                            Button(action: {
                                isBasicProfile = true
                                if let randomImageName = arrayBasicProfile.randomElement() {
                                    basicProfileName = randomImageName
                                    selectedImage = UIImage(named: randomImageName) // 랜덤 이미지 설정
                                }
                            }, label: {
                                Text("프로필 사진 삭제")
                                    .font(.body01)
                                    .frame(height: Constants.screenWidth * (26 / 360))
                                    .foregroundColor(.black)
                            })
                        }
                    }
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                    .foregroundColor(.gray3)
                    .shadow(radius: 1)
                    .overlay {
                        Text("닫기")
                            .font(.body01)
                            .foregroundColor(.black)
                    }
            }
        }
    }
}

#Preview {
    ProfileUpdateModal(selectedImage: .constant(nil), basicProfileName: .constant(""), isBasicProfile: .constant(false))
}
