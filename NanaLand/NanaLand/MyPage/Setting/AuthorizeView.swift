//
//  AuthorizeView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct AuthorizeView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .accessPolicyGuide, showBackButton: true)
                .padding(.bottom, 32)
            ScrollView {
                HStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        
                        if localizationManager.language == .korean {
                            Text("나나랜드인제주 사용을 위해")
                                .font(.title02)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0){
                                Text("다음 ")
                                    .font(.title02)
                                    .foregroundColor(.black)
                                
                                Text("접근 권한 허용")
                                    .font(.title02_bold)
                                    .foregroundColor(.black)
                                    
                                Text("이 필요합니다.")
                                    .font(.title02)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        if localizationManager.language == .chinese {
                            Text("使用nanaland in Jeju")
                                .font(.title02)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0){
                                Text("需要以下")
                                    .font(.title02)
                                    .foregroundColor(.black)
                                
                                Text("访问权限")
                                    .font(.title02_bold)
                                    .foregroundColor(.black)
                                    
                                Text("。")
                                    .font(.title02)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        if localizationManager.language == .english {
                            Text("To use nanaland in Jeju")
                                .font(.title02)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0){
                                Text("The following ")
                                    .font(.title02)
                                    .foregroundColor(.black)
                                
                                Text("permission access ")
                                    .font(.title02_bold)
                                    .foregroundColor(.main)
                                    
                                Text("is required.")
                                    .font(.title02)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        if localizationManager.language == .malaysia {
                            Text("Untuk menggunakan nanaland di Jeju")
                                .font(.title02)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0){
                                Text("akses kebenaran ")
                                    .font(.title02_bold)
                                    .foregroundColor(.black)
                                
                                Text("berikut diperlukan.")
                                    .font(.title02)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        if localizationManager.language == .vietnam {
                            Text("Để sử dụng Nana Land tại đảo Jeju,")
                                .font(.title02)
                                .foregroundColor(.black)
                            
                            HStack(spacing: 0){
                                Text("Các ")
                                    .font(.title02)
                                    .foregroundColor(.black)
                                
                                Text("Cho phép quyền truy cập ")
                                    .font(.title02_bold)
                                    .foregroundColor(.black)
                                    
                                Text("sau đây là cần thiết.")
                                    .font(.title02)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    Spacer()
                }
                
                Divider()
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                
                VStack(spacing: 16) {
                    AuthorizeItemView(title: LocalizedKey.phoneTitle.localized(for: localizationManager.language), content: LocalizedKey.phoneDescription.localized(for: localizationManager.language), isRequired: true)
                    VStack(spacing: 4) {
                        HStack(alignment: .center, spacing: 0) {
                            Image("icWarningCircle")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.main)
                                .padding(.trailing, 4)
                            Text(.notificate)
                                .foregroundStyle(.main)
                                .font(.caption01_semibold)
                                .frame(height: 24)
                                
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.leading, 8)
                        
                        HStack(spacing: 0) {
                            Text(.requiredNotification)
                                .font(.caption01)
                                .padding(.leading, 8)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        
                    }
                    .frame(width: Constants.screenWidth - 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.main10P)
                    )
                    .padding(.bottom, 16)
                    
                    AuthorizeItemView(title: LocalizedKey.storageTitle.localized(for: localizationManager.language), content: LocalizedKey.storageDescription.localized(for: localizationManager.language))
                    AuthorizeItemView(title: LocalizedKey.locationTitle.localized(for: localizationManager.language), content: LocalizedKey.locationDescription.localized(for: localizationManager.language))
                    AuthorizeItemView(title: LocalizedKey.cameraTitle.localized(for: localizationManager.language), content: LocalizedKey.cameraDescription.localized(for: localizationManager.language))
                    AuthorizeItemView(title: LocalizedKey.notificationTitle.localized(for: localizationManager.language), content: LocalizedKey.notificationDescription.localized(for: localizationManager.language))
                    AuthorizeItemView(title: LocalizedKey.audioTitle.localized(for: localizationManager.language), content: LocalizedKey.audioDescription.localized(for: localizationManager.language))
                    VStack(spacing: 4) {
                        HStack(alignment: .center, spacing: 0) {
                            Image("icWarningCircle")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.main)
                                .padding(.trailing, 4)
                            Text(.notificate)
                                .foregroundStyle(.main)
                                .font(.caption01_semibold)
                                .frame(height: 24)
                                
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.leading, 8)
                        
                        HStack(spacing: 0) {
                            Text(.optionalNotification)
                                .font(.caption01)
                                .padding(.leading, 8)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        
                    }
                    .frame(width: Constants.screenWidth - 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.main10P)
                    )
                    .padding(.bottom, 16)
                }
            }
            
            
            
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}



struct AuthorizeItemView: View {
    var title = ""
    var content = ""
    var isRequired = false
    @EnvironmentObject var localizationManager: LocalizationManager
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                Text(title)
                    .font(.body02_semibold)
                    .padding(.leading, 16)
                Text(isRequired ? LocalizedKey.requiredWithBracket.localized(for: localizationManager.language) : LocalizedKey.optionalWithBracket.localized(for: localizationManager.language))
                    .font(.body02_semibold)
                    .foregroundStyle(isRequired ? .main : .black)
                Spacer()
            }
            HStack(spacing: 0) {
                Text(content)
                    .font(.caption01)
                    .foregroundStyle(.gray1)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                Spacer()
            }
        }
    }
}
#Preview {
    AuthorizeView()
}
