//
//  ExperienceMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI

struct ExperienceMainView: View {
    var body: some View {
        VStack {
			NanaNavigationBar(title: .experience, showBackButton: true)
            Spacer()
            VStack(spacing: 0) {
                Image("icAirplane")
                Text("해당 서비스 준비 중입니다. 다음에 만나요!")
                    .font(.body01)
                    .foregroundStyle(.gray1)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 169, height: 146)
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    ExperienceMainView()
}
