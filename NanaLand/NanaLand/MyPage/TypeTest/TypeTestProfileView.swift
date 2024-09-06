//
//  TypeTestProfileView.swift
//  NanaLand
//
//  Created by wodnd on 7/25/24.
//

import SwiftUI

enum testType: Hashable{
    case recommend(nickname: String)
}

struct TypeTestProfileView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var appState = AppState.shared
    var type: String
    var nickname: String
    let imageSize = Constants.screenWidth / 9 * 5
    
    var localizedKeyMapping: [String: TripType] {
            return [
                LocalizedKey.GAMGYUL_ICECREAM.localized(for: localizationManager.language): .GAMGYUL_ICECREAM,
                LocalizedKey.GAMGYUL_RICECAKE.localized(for: localizationManager.language): .GAMGYUL_RICECAKE,
                LocalizedKey.GAMGYUL.localized(for: localizationManager.language): .GAMGYUL,
                LocalizedKey.GAMGYUL_CIDER.localized(for: localizationManager.language): .GAMGYUL_CIDER,
                LocalizedKey.GAMGYUL_AFFOKATO.localized(for: localizationManager.language): .GAMGYUL_AFFOKATO,
                LocalizedKey.GAMGYUL_HANGWA.localized(for: localizationManager.language): .GAMGYUL_HANGWA,
                LocalizedKey.GAMGYUL_JUICE.localized(for: localizationManager.language): .GAMGYUL_JUICE,
                LocalizedKey.GAMGYUL_CHOCOLATE.localized(for: localizationManager.language): .GAMGYUL_CHOCOLATE,
                LocalizedKey.GAMGYUL_COCKTAIL.localized(for: localizationManager.language): .GAMGYUL_COCKTAIL,
                LocalizedKey.TANGERINE_PEEL_TEA.localized(for: localizationManager.language): .TANGERINE_PEEL_TEA,
                LocalizedKey.GAMGYUL_YOGURT.localized(for: localizationManager.language): .GAMGYUL_YOGURT,
                LocalizedKey.GAMGYUL_FLATCCINO.localized(for: localizationManager.language): .GAMGYUL_FLATCCINO,
                LocalizedKey.GAMGYUL_LATTE.localized(for: localizationManager.language): .GAMGYUL_LATTE,
                LocalizedKey.GAMGYUL_SIKHYE.localized(for: localizationManager.language): .GAMGYUL_SIKHYE,
                LocalizedKey.GAMGYUL_ADE.localized(for: localizationManager.language): .GAMGYUL_ADE,
                LocalizedKey.GAMGYUL_BUBBLE_TEA.localized(for: localizationManager.language): .GAMGYUL_BUBBLE_TEA
            ]
        }
    
    var body: some View {
        VStack(spacing: 0) {
            
            NavigationBar(title: "")
                .frame(height: 56)
            
            ScrollView {
                header
                    .padding(.bottom, 32)
                
                contentsPart
                    .padding(.bottom, 40)
                
                bottomButtons
                    .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .padding(.vertical, 1)
        .toolbar(.hidden)
        .navigationDestination(for: testType.self, destination: { page in
            switch page{
            case let .recommend(nickname):
                ProfileRecommendView(nickname: nickname)
            }
        })
    }
    
    private var header: some View {
        ZStack{
            Circle()
                .frame(width: 85, height: 85)
                .padding(.trailing, 150)
                .padding(.bottom, 20)
                .foregroundColor(.main10P)
            
            VStack(spacing: 8) {
                Text(.yourTravelStyleIs, arguments: [nickname])
                    .font(.body01)
                    .foregroundStyle(Color.baseBlack)
                
                Text(type)
                    .font(.largeTitle01)
                    .foregroundStyle(Color.main)
            }
        }
    }
    
    // Convert type string to TripType using localizedKeyMapping
    private var convertedTripType: TripType? {
        return localizedKeyMapping[type]
    }
    
    private var contentsPart: some View {
        VStack(spacing: 32) {
            Image(convertedTripType?.image ?? .GAMGYUL_ICECREAM)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
            
            Text(convertedTripType?.descriptionLocalizedKey ?? .GAMGYUL_DESCRIPTION)
                .foregroundColor(Color.main)
                .multilineTextAlignment(.center)
                .frame(width: Constants.screenWidth * 0.8)

            Text(.nanalandMadeYouJuice)
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center)
                .frame(width: Constants.screenWidth * 0.8)
            
        }
        .font(.body01)
        .multilineTextAlignment(.center)
    }
    
    private var bottomButtons: some View {
        VStack(spacing: 16) {
            Button(action: {
                AppState.shared.navigationPath.append(testType.recommend(nickname: nickname))
            }, label: {
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.main, lineWidth: 1)
                    .frame(height: 48)
                    .overlay {
                        
                        if localizationManager.language == .korean {
                            Text(type)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                            +
                            Text(" ")
                            +
                            Text(.destination)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                        } else if localizationManager.language == .english {
                            Text(type)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                            +
                            Text(" ")
                            +
                            Text(.destination)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                        } else if localizationManager.language == .chinese {
                            Text(type)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                            +
                            Text(" ")
                            +
                            Text(.destination)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                        } else if localizationManager.language == .malaysia {
                            Text(.destination)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                            +
                            Text(" ")
                            +
                            Text(type)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                        } else {
                            Text(.destination)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                            +
                            Text(" ")
                            +
                            Text(type)
                                .font(.body_bold)
                                .foregroundColor(Color.main)
                        }
                    }
            })
            
            Button(action: {
                appState.showTypeTest = true
            }, label: {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
                    .frame(height: 48)
                    .overlay {
                        Text(.testAgain)
                            .foregroundStyle(Color.baseWhite)
                            .font(.body_bold)
                    }
            })
        }
        .padding(.horizontal, 16)
    }    
}

#Preview {
    TypeTestProfileView(type:"감귤", nickname: "현우")
}

