//
//  TypeTestProfileView.swift
//  NanaLand
//
//  Created by wodnd on 7/25/24.
//

import SwiftUI

struct TypeTestProfileView: View {
    @EnvironmentObject var typeTestVM: TypeTestViewModel
    @StateObject var appState = AppState.shared
    let nickname: String
    let imageSize = Constants.screenWidth / 9 * 5
    
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
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            // 서버에서 불러온 travelType을 userType에 저장
            if let travelTypeRawValue = appState.userInfo.travelType {
                print("travelTypeRawValue: \(travelTypeRawValue)")  // 여기서 rawValue 출력
                if let travelType = TripType.localizedKeyMapping[travelTypeRawValue] {
                    typeTestVM.state.userType = travelType
                } else {
                    print("Error: Could not convert travelTypeRawValue to TripType")
                }
            }
        }
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
                
                Text(typeTestVM.state.userType?.localizedKey ?? .GAMGYUL)
                    .font(.largeTitle01)
                    .foregroundStyle(Color.main)
            }
        }
    }
    
    private var contentsPart: some View {
        VStack(spacing: 32) {
            Image(typeTestVM.state.userType?.image ?? .GAMGYUL_ICECREAM)
                .resizable()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Circle())
            
            Text(typeTestVM.state.userType?.descriptionLocalizedKey ?? .GAMGYUL_DESCRIPTION)
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
                typeTestVM.action(.onTapGotoRecommendPlaceView)
            }, label: {
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.main, lineWidth: 1)
                    .frame(height: 48)
                    .overlay {
                        Text(typeTestVM.state.userType?.localizedKey ?? .GAMGYUL)
                            .font(.body_bold)
                            .foregroundColor(Color.main)
                        +
                        Text(" ")
                        +
                        Text(.destination)
                            .font(.body_bold)
                            .foregroundColor(Color.main)
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
    @StateObject var lm = LocalizationManager()
    @StateObject var vm = TypeTestViewModel()
    lm.language = .malaysia
    vm.state.userType = .GAMGYUL_ADE
    return TypeTestProfileView(nickname: "현우")
        .environmentObject(lm)
        .environmentObject(vm)
}

