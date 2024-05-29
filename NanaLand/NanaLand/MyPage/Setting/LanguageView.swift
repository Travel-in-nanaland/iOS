//
//  LanguageView.swift
//  NanaLand
//
//  Created by jun on 5/27/24.
//

import SwiftUI

struct LanguageView: View {
    @StateObject var viewModel = LanguageViewModel()
    @State private var selectedButton = 0
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: "언어설정", showBackButton: true)
                .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                Text("맨위에 있는 언어로\n기본 설정 되어 있습니다.")
                    .padding(.leading, 16)
                    .font(.title2)
                Spacer()
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 0) {
            
                LanguageButtonView(buttonTitle: "한국어")
                LanguageButtonView(buttonTitle: "English")
                LanguageButtonView(buttonTitle: "中国话")
                LanguageButtonView(buttonTitle: "Melayu")
                
            }
            
            
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

struct LanguageButtonView: View {
    var buttons = [0 , 1 , 2, 3]
    var buttonTitle = ""
   
    @State private var showAlert = false
    @State private var alertResult = false

    
    var body: some View {
        Button {
            showAlert = true
           
        } label: {
            HStack(spacing: 0 ){
                Text(buttonTitle)
                    .padding(.leading, 16)
                    .font(.body01)
                    .foregroundStyle(.black)
                Spacer()
            }
        }
        .frame(height: 50)
        .background(alertResult ? .main10P : .white)
        .fullScreenCover(isPresented: $showAlert) {
            LanguageAlertView(title: "언어설정", alertTitle: "해당 언어로\n변경하시겠습니까?", showAlert: $showAlert, alertResult: $alertResult)
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        } //애니메이션 효과 없애기

    }
}

#Preview {
    LanguageView()
}

