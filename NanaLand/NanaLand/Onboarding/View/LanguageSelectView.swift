//
//  LanguageSelectView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI

struct LanguageSelectView: View {
    @AppStorage("locale") var locale: String = ""
    var layout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack{
                    VStack(alignment: .leading, spacing: 4) {
                        Text("안녕하세요!")
                            .font(.gothicNeo(.regular, size: 22))
                            .foregroundColor(.white)

                        Text("언어를 선택해주세요")
                            .font(.largeTitle01)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding()
                
                LazyVGrid(columns: layout) {
                    ForEach(Language.allCases, id: \.self) { language in
                        languageButton(
                            title: language.name,
                            greeting: LocalizedKey.greeting.localized(for: language),
                            callback: {
                                locale = language.rawValue
                                LocalizationManager.shared.language = language
                            }
                        )
                        .padding(.bottom, 10)
                    }
                }
                .padding()
                Spacer()
                
                Image("logoInCircle")
            }
            .padding(.top, 60)
        }
        .background(Color.main)
    }
    
    private func languageButton(title: String, greeting: String, callback: @escaping () -> Void) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .frame(width: 170, height: 115)
            .overlay {
                VStack {
                    HStack {
                        Text(greeting)
                            .font(.body02_bold)
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text(title)
                            .font(.caption01)
                            .foregroundColor(.black)
                        Image("icArrow")
                    }
                }
                .padding()
            }
            .onTapGesture {
                callback()
            }
    }
}

#Preview {
    LanguageSelectView()
}
