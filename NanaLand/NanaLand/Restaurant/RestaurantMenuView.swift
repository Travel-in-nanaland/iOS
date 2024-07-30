//
//  RestaurantMenuView.swift
//  NanaLand
//
//  Created by wodnd on 7/23/24.
//

import SwiftUI
import Kingfisher

struct RestaurantMenuView: View {
    
    @StateObject var viewModel = RestaurantDetailViewModel()
    let title: String
    let price: String
    let imageUrl: String
    
    var body: some View {
        HStack{
            VStack{
                Text(title)
                    .font(.body_bold)
                    .foregroundColor(.black)
                    .padding(.bottom, 5)
                Text(price)
                    .font(.body02)
                    .foregroundColor(.black)
                    .padding(.bottom, 20)
            }
            
            Spacer()
            
            KFImage(URL(string: imageUrl))
                .resizable()
                .frame(width: Constants.screenWidth * (26 / 120), height: Constants.screenWidth * (26 / 120))
                .cornerRadius(8)
                .padding(.bottom, 24)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    RestaurantMenuView(title: "", price: "", imageUrl: "")
}
