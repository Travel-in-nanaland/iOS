//
//  ActivityKeywordView.swift
//  NanaLand
//
//  Created by juni on 7/16/24.
//

import SwiftUI

struct ActivityKeywordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var keyword: String
    var address: String
    @ObservedObject var viewModel: ExperienceMainViewModel
    @State private var selectedKeywordItem = 0
    @State var selectedKeyword: [String] = [] // 선택된 키워드 이름 담을 배열
    // 눌려진 키워드 버튼 담을 배열(눌렸는지 안 눌렸는지)
    @State var buttonsToggled = Array(repeating: false, count: 6)
    var ActivityKeywordArray = ["LAND_LEISURE", "WATER_LEISURE", "AIR_LEISURE", "MARINE_EXPERIENCE", "RURAL_EXPERIENCE", "HEALING_THERAPY"]
    var ActivityKeywordButtonNameArray = ["지상레저", "수상레저", "항공레저", "해양체험", "농촌체험", "힐링테라피"]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack(spacing: 0) {
            titleAndCloseButtonView
                .padding(.top, 24)
                .padding(.leading, 16)
                .padding(.bottom, 12)
            HStack(spacing: 0) {
                Text("액티비티")
                    .font(.body_bold)
                Spacer()
            }
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
                for index in 0..<buttonsToggled.count {
                    if buttonsToggled[index] == true {
                        selectedKeyword.append(ActivityKeywordArray[index])
                    }
                }
                if selectedKeyword.count == 0 {
                    selectedKeyword = [""]
                }
                keyword = selectedKeyword.joined(separator: ",")
                Task {
                    viewModel.state.getExperienceMainResponse = ExperienceMainModel(totalElements: 0, data: [])
                    await getKeywordExperienceMainItem(keyword: keyword, address: address == LocalizedKey.allLocation.localized(for: LocalizationManager().language) ? "" : address, page: 0, size: 12)
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
    }
    
    private var titleAndCloseButtonView: some View {
        HStack(spacing: 0) {
            Text("키워드")
                .font(.title02_bold)
                .padding(.trailing, 8)
            Text("\(buttonsToggled.filter { $0 == true}.count) / \(ActivityKeywordArray.count)")
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
            ForEach(0...ActivityKeywordArray.count - 1, id: \.self) { index in
                Button {
                    toggleButton(index)
           
                } label: {
                    Text(ActivityKeywordButtonNameArray[index])
                        .font(.body02)
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
    
    func getKeywordExperienceMainItem(keyword: String, address: String, page: Int, size: Int) async {
        await viewModel.action(.getExperienceMainItem(experienceType: "ACTIVITY", keyword: keyword, address: address, page: 0, size: 12))
    }
}
