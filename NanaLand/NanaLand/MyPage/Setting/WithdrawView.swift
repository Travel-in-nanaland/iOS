//
//  WithdrawView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct WithdrawView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    var buttonName = [LocalizedKey.contentLack.localized(for: LocalizationManager().language), LocalizedKey.serviceInconvenience.localized(for: LocalizationManager().language), LocalizedKey.communityInconvenience.localized(for: LocalizationManager().language), LocalizedKey.fewVisit.localized(for: LocalizationManager().language)]
 
    @State private var buttonSelected = [false, false, false, false]
    @State private var showAlert = false
    @State private var alertResult = false
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: LocalizedKey.accountDeletion.localized(for: localizationManager.language), showBackButton: true)
                .padding(.bottom, 32)
        }
        
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("nanaland in Jeju")
                            .font(.largeTitle01)
                            .foregroundStyle(Color.main)
                            .padding(.leading, 16)
                            
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 0) {
                        Text(.withDrawNotification)
                            .font(.title02_bold)
                            .padding(.leading, 16)
                            
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        WithdrawViewItem(itemNumber: 1, contents: LocalizedKey.firstNotification.localized(for: localizationManager.language))
                        WithdrawViewItem(itemNumber: 2, contents: LocalizedKey.secondNotification.localized(for: localizationManager.language))
                        WithdrawViewItem(itemNumber: 3, contents: LocalizedKey.thirdNotification.localized(for: localizationManager.language))
                        WithdrawViewItem(itemNumber: 4, contents: LocalizedKey.fourthNotification.localized(for: localizationManager.language))
                        WithdrawViewItem(itemNumber: 5, contents: LocalizedKey.fifthNotification.localized(for: localizationManager.language))
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 0) {
                        Text(.notificationConsent)
                            .font(.body02_bold)
                            .foregroundStyle(.gray1)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.bottom, 16)
                    
                    Divider()
                        .padding(.bottom, 16)
                    
                    HStack(spacing: 2) {
                        Text(.withDrawReason)
                        Text(.requiredWithBracket)
                            .foregroundStyle(.main)
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                    .font(.title02_bold)
                    
                    VStack(spacing: 0) {
                        ForEach(0...3, id: \.self) { index in
                            Button(action: {
                                withAnimation(nil) {
                                    buttonSelected[index].toggle()
                                }
                                
                            }, label: {
                                HStack(spacing: 0){
                                    Image(buttonSelected[index] ? "icCheckmarkFilled" : "icCheckmark")
                                        .padding(.trailing, 8)
                                    Text(buttonName[index])
                                        .font(.body02)
                                        .foregroundStyle(buttonSelected[index] ? .main : .gray1 )
                                    Spacer()
                                }
                                .frame(height: 48)
                                .padding(.leading, 16)
                                
                            })
               
                        }
                        
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            showAlert = true
                        }, label: {
                            Text(.withdraw)
                                .foregroundStyle(.gray1)
                                .font(.body_bold)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: (Constants.screenWidth - 48) / 2, height: 48)
                                .foregroundStyle(.gray2)
                        )
                        .frame(width: (Constants.screenWidth - 48) / 2, height: 48)
                        .padding(.leading, 16)
                        .fullScreenCover(isPresented: $showAlert) {
                            AlertView(title: "회원탈퇴", alertTitle: "정말 제주도 여행 정보와 혜택을 받지 않으시겠습니까? 😢", subAlertTitle: "*90일 이내에 재가입 시, 기존 계정으로 로그인이 됩니다.", showAlert: $showAlert, alertResult: $alertResult)
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        } //애니메이션 효과 없애기
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Text(.cancel)
                                .foregroundStyle(.white)
                                .font(.body_bold)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: (Constants.screenWidth - 48) / 2, height: 48)
                                .foregroundStyle(.main)
                        )
                        .frame(width: (Constants.screenWidth - 48) / 2, height: 48)
                        .padding(.trailing, 16)
                        
                        
                    }
                    .padding(.bottom, 15)
                    
                }
                .toolbar(.hidden)
            
                .frame(height: Constants.screenHeight)
                
            }
            .frame(maxHeight: Constants.screenHeight)
           
        }
    }
}


struct WithdrawViewItem: View {
    var itemNumber: Int
    var contents = ""
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\(itemNumber).")
            Text(contents)
                .padding(.leading, 0)
                .padding(.trailing, 16)
                .multilineTextAlignment(.leading)
                
               
        }
        .font(.caption01)
        .foregroundStyle(.gray1)
    }
    
    
}

#Preview {
    WithdrawView()
}
