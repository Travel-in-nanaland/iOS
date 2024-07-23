//
//  RestaurantKeywordView.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import SwiftUI

struct RestaurantKeywordView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var viewModel: RestaurantMainViewModel
    @Binding var keyword: String
    @Binding var isModalShown: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedKeyword: [LocalizedKey] = []
    @State var buttonsToggled = Array(repeating: false, count: 14)
    
    var title: String
    
    var keywordArray: [LocalizedKey] = [
        .koreanFood,
        .chineseFood,
        .japaneseFood,
        .westernFood,
        .snacks,
        .southAmericanFood,
        .southeastAsianFood,
        .vegan,
        .halalFood,
        .meatblackpork,
        .seaFood,
        .chickenBurger,
        .cafeDessert,
        .pubRestaurant
    ]
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(.location)
                    .font(.title02_bold)
                    .padding(.leading, 16)
                    .padding(.top, 24)
                
                Text("\(selectedKeyword.count)/14")
                    .font(.body02)
                    .foregroundColor(.gray1)
                    .padding(.top, 24)
                    .padding(.leading, 10)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("icX")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding(.trailing, 16)
                        .padding(.top, 24)
                })
            }
            .padding(.bottom, 24)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<keywordArray.count, id: \.self) { index in
                    Button(action: {
                        toggleButton(index)
                    }, label: {
                        Text(keywordArray[index].localized(for: localizationManager.language))
                            .font(.body02)
                            .foregroundStyle(buttonsToggled[index] ? Color.main : Color.gray1)
                            .padding(.leading, 7)
                            .padding(.trailing, 7)
                    })
                    .frame(width: 100, height: 40)
                    .background(
                        buttonsToggled[index] ? (RoundedRectangle(cornerRadius: 30)
                            .fill(Color.main10P).overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.main, lineWidth: 1))) : RoundedRectangle(cornerRadius: 30).fill(Color.white).overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray2, lineWidth: 1))
                    )
                }
            }
            .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Button(action: {
                    for index in 0..<buttonsToggled.count {
                        if !buttonsToggled[index] {
                            buttonsToggled[index].toggle()
                        }
                    }
                    selectedKeyword = [LocalizedKey.Hangyeong,LocalizedKey.Daejeong, LocalizedKey.Hallim, LocalizedKey.Aewol, LocalizedKey.jejuCity, LocalizedKey.Jocheon, LocalizedKey.Gunjwa, LocalizedKey.Andeok, LocalizedKey.SeogwipoCity, LocalizedKey.Namwon, LocalizedKey.Pyoseon, LocalizedKey.Seongsan, LocalizedKey.Chuja, LocalizedKey.Udo]
                }, label: {
                    HStack(spacing: 0) {
                        Image("icCheck")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.allSelect)
                            .font(.body02)
                    }
                })
                .padding(.leading, 58)
                
                Spacer()
                
                Button(action: {
                    for index in 0..<buttonsToggled.count {
                        if buttonsToggled[index] {
                            buttonsToggled[index].toggle()
                        }
                    }
                    selectedKeyword = []
                }, label: {
                    HStack(spacing: 0) {
                        Image("icRe")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.reset)
                            .font(.body02)
                    }
                })
                .padding(.trailing, 58)
            }
            .padding(.bottom, 24)
            
            Spacer()
            
            Button(action: {
                // 눌린 버튼을 selectedLocation에 추가
                selectedKeyword.removeAll()
                for index in 0..<buttonsToggled.count {
                    if buttonsToggled[index] {
                        selectedKeyword.append(keywordArray[index])
                    }
                }
                if selectedKeyword.isEmpty {
                    selectedKeyword = []
                }

                Task {
                    let selectedKeywordStrings = selectedKeyword.map { $0.rawValue }
                    if title == "제주 맛집" { // 전통시장
                        viewModel.state.getRestaurantMainResponse = RestaurantMainModel(totalElements: 0, data: [])
                        await getKeywordRestaurantMainItem(page: 0, size: 18, filterName: selectedKeywordStrings.joined(separator: ","))
                        viewModel.state.page = 0
                    }
                    
                    keyword = selectedKeywordStrings.joined(separator: ",")
                    viewModel.state.keyword = keyword
                    print(keyword)
                    // 장소 선택 안 할시 전 지역
                    if keyword.isEmpty {
                        keyword = LocalizedKey.keyword.localized(for: localizationManager.language)
                    }
                }

                isModalShown = false
            }, label: {
                Text(.apply)
                    .font(.body_bold)
                    .foregroundStyle(Color.white)
            })
            .frame(width: Constants.screenWidth - 32, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
            )
            .padding(.bottom, 24)
        }
    }
    
    func getKeywordRestaurantMainItem(page: Int64, size: Int64, filterName: String) async {
        await viewModel.action(.getRestaurantMainItem(page: page, size: size, filterName: filterName))
    }
    
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
        if buttonsToggled[index] {
            selectedKeyword.append(keywordArray[index])
        } else {
            if let selectedIndex = selectedKeyword.firstIndex(of: keywordArray[index]) {
                selectedKeyword.remove(at: selectedIndex)
            }
        }
    }
}

#Preview {
    RestaurantKeywordView(viewModel: RestaurantMainViewModel(), keyword: .constant(""), isModalShown: .constant(true), title: "제주 맛집")
        .environmentObject(LocalizationManager())
}
