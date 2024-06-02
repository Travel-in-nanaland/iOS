//
//  FestivalNoResultView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI

struct NoResultView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image("icNoResult")
            Text(.noResult)
                .font(.body02)
                .foregroundStyle(Color.gray1)
                .frame(height: 50)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    NoResultView()
}
