//
//  FestivalNoResultView.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI

struct FestivalNoResultView: View {
    var body: some View {
        VStack(spacing: 4) {
            Image("icNoResult")
            Text("해당 검색 결과가 없습니다.")
                .font(.body02)
                .foregroundStyle(Color.gray1)
        }
    }
}

#Preview {
    FestivalNoResultView()
}
