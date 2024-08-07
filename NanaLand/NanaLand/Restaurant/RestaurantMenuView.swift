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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    let title: String
    let price: String
    let imageUrl: String
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .font(.body_bold)
                    .foregroundColor(.black)
                HStack{
                    Text("\(formatPrice(price))\(LocalizedKey.currency.localized(for: localizationManager.language))")
                        .font(.body02)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                }
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
    
    // 가격을 포맷팅하는 함수
       func formatPrice(_ priceString: String) -> String {
           // 문자열을 Double로 변환
           if let price = Double(priceString) {
               let formatter = NumberFormatter()
               formatter.numberStyle = .decimal
               // 포맷팅된 문자열 반환
               return formatter.string(from: NSNumber(value: price)) ?? priceString
           } else {
               // 변환 실패 시 원래 문자열 반환
               return priceString
           }
       }
}

#Preview {
    RestaurantMenuView(title: "성게밥", price: "15000", imageUrl: "")
        .environmentObject(LocalizationManager())
}

