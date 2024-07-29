//
//  Toast.swift
//  NanaLand
//
//  Created by juni on 7/26/24.
//

import Foundation
import SwiftUI

struct Toast: View {
    let message: String
    @Binding var isShowing: Bool
    @State var isAnimating: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            if isShowing {
                Text(message)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(30)
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
    }
}
