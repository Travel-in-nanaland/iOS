//
//  NavigationDeepLinkBar.swift
//  NanaLand
//
//  Created by wodnd on 7/23/24.
//

import SwiftUI

struct NavigationDeepLinkBar: View {
    @StateObject var viewModel = RestaurantDetailViewModel()
    var title: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            HStack {
                Button (action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("icLeft")
                        .padding(.leading, 16)
                }
                )
                
                Spacer()
                
                Text("\(title)")
                    .font(.gothicNeo(.bold, size: 20))
                
                Spacer()
                
                ShareLink(item: DeepLinkManager.shared.makeLink(category: .restaurant, id: Int(viewModel.state.getRestaurantDetailResponse.id)), label: {
                    Image("icShare2")
                        .padding(.trailing, 10)
                })
            }
        }
    }
}

#Preview {
    NavigationDeepLinkBar(title: "hello")
}
