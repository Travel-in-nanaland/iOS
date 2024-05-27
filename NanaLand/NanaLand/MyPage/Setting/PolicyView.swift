//
//  PolicyView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct PolicyView: View {
    @StateObject var viewModel = PolicyViewModel()
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: "약관 및 정책", showBackButton: true)
                .padding(.bottom, 24)
            PolicyItemButtonView(title: "마케팅 활용 동의", isSelected: $viewModel.state.marketingAgree)
            PolicyItemButtonView(title: "위치기반 서비스 약관 동의", isSelected: $viewModel.state.gpsAgree)
                .padding(.bottom, 24)
            HStack(spacing: 0) {
                Text("* 비동의시, 받지 못하는 서비스 또는 혜택이 있을 수 있으니 주의하시길 바랍니다.")
                    .font(.caption01)
                    .foregroundStyle(.gray1)
                
            }
            .frame(width: Constants.screenWidth - 32)
            
            Spacer()
        }
        .toolbar(.hidden)
        
       
    }
}

struct PolicyItemButtonView: View {
    var title = ""
    @Binding var isSelected: Bool
    var body: some View {
        Button {
            withAnimation(nil) {
                isSelected.toggle()
            }
        } label: {
            HStack(spacing: 0) {
                Text("\(title)")
                    .font(.body01)
                    .padding(.leading, 16)
                Spacer()
                Image(isSelected ? "icCheckmarkFilled" : "icCheckmark")
                    .padding(.trailing, 16)
            }
        }
        .frame(width: Constants.screenWidth, height: 48)

    }
}

#Preview {
    PolicyView()
}
