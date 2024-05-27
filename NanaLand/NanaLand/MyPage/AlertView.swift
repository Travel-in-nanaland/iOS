//
//  AlertView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct AlertView: View {
    var title = "" // 어떤 얼럿창인지
    var alertTitle = "" // 얼럿 창에 띄울 제목 메세지
    var subAlertTitle = ""
    @Binding var showAlert: Bool
    @Binding var alertResult: Bool // 언어변경 true면 변경
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 0) {
                if title == "회원탈퇴" {
                    Text(alertTitle)
                        .multilineTextAlignment(.center)
                        .font(.title01_bold)
                        .padding(.top, 28)
           
                } else {
                    Text(alertTitle)
                        .font(.title01_bold)
                        .padding(.top, 53)
                }
                
                Spacer()
                if subAlertTitle != "" {
                    Text(subAlertTitle)
                        .multilineTextAlignment(.center)
                        .font(.body01)
                        .foregroundStyle(.gray1)
                        .padding(.bottom, 24)
                }
                
                Divider()
                HStack(spacing: 0) {
                 //첫 번째 버튼
                    Button {
                        showAlert = false
                        // 로그아웃 할 시
                        alertResult = false
                    } label: {
                        if title == "로그아웃" {
                            Text("네")
                                .font(.title02_bold)
                        } else if title == "언어설정" {
                            Text("아니오")
                                .font(.title02_bold)
                        } else if title == "회원탈퇴" {
                            Text("취소")
                                .font(.title02_bold)
                        }
                        
                    }
                    .frame(width: 150)
                    Divider()
                    // 두 번째 버튼
                    Button {
                        showAlert = false
                        // 로그아웃 안 할 시
                        alertResult = true
                        
                    } label: {
                        if title == "로그아웃" {
                            Text("아니오")
                                .font(.title02_bold)
                                .foregroundStyle(.main)
                        } else if title == "언어설정" {
                            Text("네")
                                .font(.title02_bold)
                                .foregroundStyle(.main)
                        } else if title == "회원탈퇴" {
                            Text("삭제")
                                .font(.title02_bold)
                                .foregroundStyle(.main)
                        }
                        
                    }
                    .frame(width: 150)
                    
                }
                .frame(width: 300, height: 56)
            }
            .frame(width: Constants.screenWidth - 60, height: 220)

            .background(Color.white)
            .cornerRadius(10)
            
        }
        .background(ClearBackground())
        
    }
}
// alert창 배경색 투명하게
struct ClearBackground: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


