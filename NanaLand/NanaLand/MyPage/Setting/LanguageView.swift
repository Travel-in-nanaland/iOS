//
//  LanguageView.swift
//  NanaLand
//
//  Created by jun on 5/27/24.
//

import SwiftUI

struct LanguageView: View {
    var languageName = ["한국어", "English", "中国话", "Melayu"]
    @StateObject var viewModel = LanguageViewModel()
    @State var alertResult = true
    @State private var showAlert = false
    @State private var selectedButton: Int? = 0
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
                ForEach(0...languageName.count - 1, id: \.self) { index in
                    Button {
                        withAnimation(nil) {
                            alertResult = false
                            showAlert = true
                            selectedButton = index
                            
                        }
                        
                    } label: {
                        HStack(spacing: 0 ){
                            Text(languageName[index])
                                .padding(.leading, 16)
                                .font(selectedButton == index && alertResult ? .body_bold : .body01)
                                .foregroundStyle(selectedButton == index && alertResult ? .main : .black)
                            Spacer()
                        }
                    }
                    .frame(height: 50)
                    .background(selectedButton == index && alertResult ? .main10P : .white)
                    .fullScreenCover(isPresented: $showAlert) {
                        AlertView(title: "언어설정", alertTitle: "해당 언어로\n변경하시겠습니까?", showAlert: $showAlert, alertResult: $alertResult)
                    }
                    .transaction { transaction in
                        transaction.disablesAnimations = true
                    } //애니메이션 효과 없애기
                    

                }
            }
            
            
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}


#Preview {
    LanguageView()
}

