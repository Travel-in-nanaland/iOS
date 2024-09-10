//
//  Toast.swift
//  NanaLand
//
//  Created by juni on 7/26/24.
//

import Foundation
import SwiftUI
import Combine

struct Toast: View {
    let message: String
    @Binding var isShowing: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                if isShowing {
                    Spacer()
                    Text(message)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .cornerRadius(30)
                        .offset(y: -20)
                        .animation(.easeInOut(duration: 0.5), value: isAnimating)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isShowing = false
                                }
                            }
                        }
                }
            }
            .onAppear(perform: {
                isAnimating = true
            })
            .padding()
            .frame(maxWidth: .infinity, alignment: .bottom)
            .onChange(of: keyboardHeight) { _ in
                withAnimation {
                    
                }
            }
        }
        .onReceive(Publishers.keyboardHeight) { height in
            keyboardHeight = height
        }
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let notificationCenter = NotificationCenter.default
        let willShow = notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return 0
                }
                return keyboardFrame.height
            }
        let willHide = notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                return 0
            }
        return Publishers.Merge(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
