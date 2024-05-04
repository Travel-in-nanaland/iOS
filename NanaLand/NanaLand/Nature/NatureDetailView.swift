//
//  NatureDetailView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI

struct NatureDetailView: View {
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "7대 자연")
                .frame(height: 56)
                .padding(.bottom, 24)
            Spacer()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    NatureDetailView()
}
