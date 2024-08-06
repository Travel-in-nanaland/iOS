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
            VStack(alignment: .leading){
                Text(title)
                    .font(.body_bold)
                    .foregroundColor(.black)
                Text(price)
                    .font(.body02)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
            }
            
            Spacer()
            
            KFImage(URL(string: imageUrl))
                .resizable()
                .frame(width: 56, height: 56)
                .cornerRadius(8)
                .padding(.bottom, 10)
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    RestaurantMenuView(title: "", price: "", imageUrl: "")
}

