//
//  RestaurantKeywordView.swift
//  NanaLand
//
//  Created by wodnd on 7/30/24.
//


import SwiftUI

struct RestaurantKeywordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var keyword: String
    var address: String
    @ObservedObject var viewModel: RestaurantMainViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @State var selectedKeyword: [String] // 선택된 키워드 이름 담을 배열
    @State var selectedKeywordName: [String] = []
    // 눌려진 키워드 버튼 담을 배열(눌렸는지 안 눌렸는지)
    @State var buttonsToggled = Array(repeating: false, count: 14)
    var RestaurantKeyword = ["KOREAN", "CHINESE", "JAPANESE", "WESTERN", "SNACK", "SOUTH_AMERICAN", "SOUTHEAST_ASIAN", "VEGAN", "HALAL", "MEAT_BLACK_PORK", "SEAFOOD", "CHICKEN_BURGER", "CAFE_DESSERT", "PUB_FOOD_PUB"]
//    var RestaurantKeywordArray = ["한식", "중식", "일식", "양식", "분식", "남미 음식", "동남아 음식", "비건푸드", "할랄푸드", "육류/흑돼지", "해산물", "치킨/버거", "카페/디저트", "펍/요리주점"]
    var RestaurantKeywordArray: [String] {
        [
            LocalizedKey.koreanFood.localized(for: localizationManager.language),
            LocalizedKey.chineseFood.localized(for: localizationManager.language),
            LocalizedKey.japaneseFood.localized(for: localizationManager.language),
            LocalizedKey.westernFood.localized(for: localizationManager.language),
            LocalizedKey.snacks.localized(for: localizationManager.language),
            LocalizedKey.southAmericanFood.localized(for: localizationManager.language),
            LocalizedKey.southeastAsianFood.localized(for: localizationManager.language),
            LocalizedKey.vegan.localized(for: localizationManager.language),
            LocalizedKey.halalFood.localized(for: localizationManager.language),
            LocalizedKey.meatblackpork.localized(for: localizationManager.language),
            LocalizedKey.seaFood.localized(for: localizationManager.language),
            LocalizedKey.chickenBurger.localized(for: localizationManager.language),
            LocalizedKey.cafeDessert.localized(for: localizationManager.language),
            LocalizedKey.pubRestaurant.localized(for: localizationManager.language)
        ]
    }
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            titleAndCloseButtonView
                .padding(.top, 24)
                .padding(.leading, 16)
                .padding(.bottom, 12)
            
            keywordVGridView
                .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Button {
                    for index in 0..<buttonsToggled.count {
                        if buttonsToggled[index] == false {
                            buttonsToggled[index].toggle()
                        }
                    }
                } label: {
                    HStack(spacing: 0) {
                        Image("icCheck")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.allSelect)
                            .font(.body02)
                    }
                }
                .frame(height: 36)
                .padding(.leading, 58)
                Spacer()
                
                Button {
                    for index in 0..<buttonsToggled.count {
                        if buttonsToggled[index] == true {
                            buttonsToggled[index].toggle()
                        }
                        selectedKeyword = []
                        selectedKeywordName = []
                    }
                } label: {
                    HStack(spacing: 0) {
                        Image("icRe")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.reset)
                            .font(.body02)
                    }
                }
                .frame(height: 36)
                .padding(.trailing, 58)
            }
            .padding(.bottom, 24)
            Button {
                selectedKeyword = []
                selectedKeywordName = []
                
                for index in 0..<buttonsToggled.count {
                    if buttonsToggled[index] == true {
                        selectedKeyword.append(RestaurantKeyword[index])
                        selectedKeywordName.append(RestaurantKeywordArray[index])
                    }
                }
                if selectedKeyword.count == 0 {
                    selectedKeyword = [""]
                    selectedKeywordName = [""]
                }
                keyword = selectedKeywordName.joined(separator: ",")
                Task {
                    viewModel.state.getRestaurantMainResponse = RestaurantMainModel(totalElements: 0, data: [])
                    await getKeywordRestaurantMainItem(keyword: selectedKeyword.joined(separator: ","), address: address == LocalizedKey.allLocation.localized(for: LocalizationManager().language) ? "" : address, page: 0, size: 12)
                    viewModel.state.page = 0
                    if keyword.isEmpty {
                        keyword = LocalizedKey.type.localized(for: localizationManager.language)
                    }
                }
               
                dismiss()
                print("\(keyword)")
            } label: {
                Text(.apply)
                    .font(.body_bold)
                    .foregroundStyle(Color.white)
            }
            .frame(width: Constants.screenWidth - 32, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
            )
            .padding(.bottom, 24)
            Spacer()
        }
        .onAppear(){
            updateButtonsToggled()
        }
    }
    
    private var titleAndCloseButtonView: some View {
        HStack(spacing: 0) {
            Text(.type)
                .font(.title02_bold)
                .padding(.trailing, 8)
            Text("\(buttonsToggled.filter { $0 == true}.count) / \(RestaurantKeyword.count)")
                .font(.body02)
                .foregroundStyle(Color.gray1)
            Spacer()
            Button {
                dismiss()
            } label: {
                Image("icX")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .padding(.trailing, 16)
            }
        }
    }
    
    private var keywordVGridView: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0...RestaurantKeyword.count - 1, id: \.self) { index in
                Button {
                    toggleButton(index)
           
                } label: {
                    Text(RestaurantKeywordArray[index])
                        .font(.gothicNeo(.regular, size: 12))
                        .foregroundStyle(buttonsToggled[index] ? Color.main : Color.gray1)
                }
                .frame(width: 95, height: 36)
                .background(
                    buttonsToggled[index] ? (RoundedRectangle(cornerRadius: 30)
                        .fill(Color.main10P).overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.main, lineWidth: 1))) : RoundedRectangle(cornerRadius: 30).fill(Color.white).overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.gray2, lineWidth: 1))
                )
            }
        }
    }
    
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
    }
    
    // 버튼 상태 업데이트
    func updateButtonsToggled() {
        for (index, category) in RestaurantKeyword.enumerated() {
            buttonsToggled[index] = selectedKeyword.contains(category)
        }
    }
    
    func getKeywordRestaurantMainItem(keyword: String, address: String, page: Int, size: Int) async {
        await viewModel.action(.getRestaurantMainItem(keyword: keyword, address: address, page: 0, size: 12))
        viewModel.state.selectedKeyword = selectedKeyword
    }
}

