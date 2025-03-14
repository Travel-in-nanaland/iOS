//
//  NoResultFilterView.swift
//  NanaLand
//
//  Created by wodnd on 1/8/25.
//

import SwiftUI
import SwiftUICalendar

// 카테고리내 필터를 적용시 결과가 없는 경우
struct NoResultFilterView: View {
    @Binding var keyword: String
    @Binding var location: String
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
    
            Text(.noContent)
                .font(.body01)
                .foregroundColor(.gray1)
                .frame(height: Constants.screenWidth * (26 / 360))
                .multilineTextAlignment(.center)
            
            Text(.filterAdjustment)
                .font(.body02)
                .foregroundColor(.gray2)
                .frame(height: Constants.screenWidth * (22 / 360))
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            Button(action: {
                keyword =  LocalizedKey.type.localized(for: LocalizationManager().language)
                location =  LocalizedKey.allLocation.localized(for: LocalizationManager().language)
                
                
            }, label: {
                Text(.filterReset)
                    .font(.body02_semibold)
                    .foregroundColor(.gray1)
                    .frame(height: Constants.screenWidth * (22 / 360))
                    .padding(EdgeInsets(top: Constants.screenWidth * (9 / 360), leading: Constants.screenWidth * (28 / 360), bottom: Constants.screenWidth * (9 / 360), trailing: Constants.screenWidth * (28 / 360)))
                    .background(content: {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.gray2)
                    })
            })
        }
    }
}

#Preview {
    NoResultFilterView(keyword: .constant(""), location: .constant(""))
}

