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
            if LocalizationManager.shared.language == .malaysia {
                Text(.yourPreference)
                    .font(.largeTitle02_regular)
                    .foregroundStyle(Color.black)
                
                Text(AppState.shared.userInfo.nickname)
                    .font(.largeTitle02)
                    .foregroundStyle(Color.main)
            } else {
                HStack{
                    Text(AppState.shared.userInfo.nickname)
                        .font(.largeTitle02)
                        .foregroundStyle(Color.main)
                    
                    Text("님의")
                        .font(.largeTitle02_regular)
                        .foregroundStyle(Color.black)
                }
                
                Text(.yourPreference)
                    .font(.largeTitle02_regular)
                    .foregroundStyle(Color.black)
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

