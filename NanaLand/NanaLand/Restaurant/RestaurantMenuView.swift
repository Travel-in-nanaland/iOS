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
    @State private var menuModal = false
    
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
            
            Button {
                menuModal = true
            } label: {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .frame(width: 56, height: 56)
                    .cornerRadius(8)
                    .padding(.bottom, 10)
            }

        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
        .fullScreenCover(isPresented: $menuModal) {
            MenuModalView(imageUrl: imageUrl)
                .background(ClearBackgroundView())
        }
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

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct ClearBackgroundViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(ClearBackgroundView())
    }
}

extension View {
    func clearModalBackground()->some View {
        self.modifier(ClearBackgroundViewModifier())
    }
}

#Preview {
    RestaurantMenuView(title: "성게밥", price: "15000", imageUrl: "")
        .environmentObject(LocalizationManager())
}

