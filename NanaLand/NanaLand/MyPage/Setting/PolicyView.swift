//
//  PolicyView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct PolicyView: View {
    @StateObject var viewModel = PolicyViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .termsAndPolicies, showBackButton: true)
                .padding(.bottom, 24)
            PolicyItemButtonView(title: LocalizedKey.marketingConsent.localized(for: localizationManager.language), isSelected: $viewModel.state.marketingAgree)
            PolicyItemButtonView(title: LocalizedKey.locationConsent.localized(for: localizationManager.language), isSelected: $viewModel.state.gpsAgree)
                .padding(.bottom, 24)
            HStack(spacing: 0) {
                Text(.noConsentError)
                    .font(.caption01)
                    .foregroundStyle(.gray1)
                Spacer()
                
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
                    .multilineTextAlignment(.leading)
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
