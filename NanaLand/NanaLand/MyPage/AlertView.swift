//
//  AlertView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct AlertView: View {
    @Binding var showAlert: Bool
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Text("정말 로그아웃을\n하시겠습니까?")
                    .font(.title01_bold)
                    .padding(.top, 43)
                Spacer()
                Divider()
                HStack(spacing: 0) {
                 
                    Button {
                        showAlert = false
                        // 로그아웃 할 시
                        
                    } label: {
                        Text("네")
                            .font(.title02_bold)
                    }
                    .frame(width: 150)
                    Divider()
                    Button {
                        showAlert = false
                        // 로그아웃 안 할 시
                        
                    } label: {
                        Text("아니오")
                            .font(.title02_bold)
                            .foregroundStyle(.main)
                    }
                    .frame(width: 150)
                    
                }
                .frame(width: 300, height: 56)
            }
            .frame(width: 300, height: 200)
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


