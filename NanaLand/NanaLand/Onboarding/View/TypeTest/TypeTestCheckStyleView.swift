//
//  TypeTestCheckStyleView.swift
//  NanaLand
//
//  Created by 정현우 on 5/28/24.
//

import SwiftUI
import Lottie

struct TypeTestCheckStyleView: View {
    @EnvironmentObject var typeTestVM: TypeTestViewModel
    let nickname: String
    
    var body: some View {
        VStack(spacing: 0) {
            titlePart
                .padding(.bottom, 53)
            
            LottieView(jsonName: "TestLoading", loopMode: .loop)
                .frame(height: 250)
            
            Spacer()
            
            Button(action: {
                typeTestVM.action(.onTapLetsgoButton)
            }, label: {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
                    .frame(height: 48)
                    .overlay {
                        Text("Let's Go!")
                            .foregroundStyle(Color.baseWhite)
                            .font(.body_bold)
                    }

            })
        }
        .padding(.top, 110)
        .padding(.bottom, 24)
        .padding(.horizontal, 16)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    private var titlePart: some View {
        VStack(spacing: 16) {
            if LocalizationManager.shared.language == .korean {
                HStack(spacing: 0){
                    Text(AppState.shared.userInfo.nickname)
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text(.yourPreference)
                        .font(.largeTitle02_regular)
                        .foregroundStyle(Color.black)
                }
            }
            
            if LocalizationManager.shared.language == .english {
                HStack(spacing: 0){
                    Text("What is ")
                        .font(.largeTitle02_regular)
                        .foregroundStyle(Color.black)
                    
                    Text("\(AppState.shared.userInfo.nickname)")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text("'s taste")
                        .font(.largeTitle02_regular)
                        .foregroundStyle(Color.black)
                    
                    
                }
            }
            
            if LocalizationManager.shared.language == .chinese {
                HStack(spacing: 0){
                    Text(AppState.shared.userInfo.nickname)
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text("的 口味是什么?")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.black)
                }
            }
            
            if LocalizationManager.shared.language == .malaysia {
                HStack(spacing: 0){
                    
                    Text("Apakah rasa ")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.black)
                    
                    Text(AppState.shared.userInfo.nickname)
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text("?")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.black)
                }
            }
            
            if LocalizationManager.shared.language == .vietnam {
                HStack(spacing: 0){
                    Text("Sở thích của ")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.black)
                    
                    Text(AppState.shared.userInfo.nickname)
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text(" là gì?")
                        .font(.largeTitle02)
                        .foregroundStyle(Color.black)
                }
            }
            
            Text(.yourTravelStyle)
                .font(.largeTitle02_regular)
                .foregroundStyle(Color.black)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    TypeTestCheckStyleView(nickname: "현우")
        .environmentObject(TypeTestViewModel())
}

