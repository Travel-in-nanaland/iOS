//
//  NavigationHeartDeepLinkBar.swift
//  NanaLand
//
//  Created by wodnd on 8/22/24.
//

import SwiftUI

struct NavigationHeartDeepLinkBar: View {
    @StateObject var viewModel: NewNanaPickDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            HStack {
                Button (action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("icLeftWhite")
                        .padding(.leading, 16)
                }
                )
                
                Spacer()
            
                
                Button {
                    Task {
                        print(viewModel.state.getNanaPickDetailResponse.favorite)
                        await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getNanaPickDetailResponse.id), category: .nanaPick))
                        print(viewModel.state.getNanaPickDetailResponse.favorite)
                    }
                } label: {
                    Image(viewModel.state.getNanaPickDetailResponse.favorite == true ? "icHeartFillMain" : "icHeartWhite")
                }
                
                ShareLink(item: DeepLinkManager.shared.makeLink(category: .nanaPick, id: Int(viewModel.state.getNanaPickDetailResponse.id)), label: {
                    Image("icShare3")
                        .padding(.trailing, 10)
                })
            }
            .background(.clear)
        }
    }
    
    func toggleFavorite(body: FavoriteToggleRequest) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            await MainActor.run {
                            AppState.shared.showRegisterInduction = true
                        }
            return
        }
        await viewModel.action(.toggleFavorite(body: body))
    }
    
}
#Preview {
    NavigationHeartDeepLinkBar(viewModel: NewNanaPickDetailViewModel())
}
