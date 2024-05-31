//
//  SettingView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct SettingView: View {
    @State private var showAlert = false
    @State var alertResult = false
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        
        VStack(spacing: 0) {
			NanaNavigationBar(title: .settings, showBackButton: true)
                .padding(.bottom, 20)
            HStack(spacing: 0) {
                Text(.setUsage)
                    .font(.body02_bold)
                    .padding(.leading, 17)
                
                Spacer()
            }
            .padding(.bottom, 6)
            VStack(spacing: 0) {
                SettingItemButtonView(title: LocalizedKey.termsAndPolicies.localized(for: localizationManager.language))
                SettingItemButtonView(title: LocalizedKey.accessPolicyGuide.localized(for: localizationManager.language))
                SettingItemButtonView(title: LocalizedKey.languageSetting.localized(for: localizationManager.language))
                SettingItemButtonView(title: LocalizedKey.versionInfomation.localized(for: localizationManager.language))
                Divider()
                // 로그아웃 alert창 띄울 버튼
                Button {
                    showAlert = true
                } label: {
                    HStack(spacing: 0) {
                        Text(.logout)
                            .font(.body01)
                            .padding(.leading, 16)
                        Spacer()
                    }
                }
                .frame(width: Constants.screenWidth, height: 48)
                .fullScreenCover(isPresented: $showAlert) {
					AlertView(
						title: .logoutAlertTitle,
						leftButtonTitle: .yes,
						rightButtonTitle: .no,
						leftButtonAction: {
							// 로그아웃
							AuthManager(registerVM: RegisterViewModel()).logout()
						},
						rightButtonAction: {
							showAlert = false
						}
					)
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }

                SettingItemButtonView(title: LocalizedKey.memberWithdraw.localized(for: localizationManager.language))
            }
            Spacer()
        }
        .toolbar(.hidden)
        .navigationDestination(for: SettingViewType.self) { viewType in
            switch viewType {
            case .policy:
                PolicyView()
            case .authorize:
                // 각 viewType에 맞는 뷰로 추후 수정 예정
                AuthorizeView()
            case .language:
                LanguageView()
            case .withdraw:
                WithdrawView()
            }
            
        }
        
    }
}
// 설정창에 있는 버튼들
struct SettingItemButtonView: View {
    var title = ""
    var path: SettingViewType? = nil
    @EnvironmentObject var localizationManager: LocalizationManager
    var body: some View {
        Button {

            switch title {
            case LocalizedKey.termsAndPolicies.localized(for: localizationManager.language):
                AppState.shared.navigationPath.append(SettingViewType.policy)
            case LocalizedKey.accessPolicyGuide.localized(for: localizationManager.language):
                AppState.shared.navigationPath.append(SettingViewType.authorize)
            case LocalizedKey.languageSetting.localized(for: localizationManager.language):
                AppState.shared.navigationPath.append(SettingViewType.language)
            case LocalizedKey.versionInfomation.localized(for: localizationManager.language):
                break
            case LocalizedKey.memberWithdraw.localized(for: localizationManager.language):
                AppState.shared.navigationPath.append(SettingViewType.withdraw)
            default:
                break
            }
            
        } label: {
            HStack(spacing: 0) {
                if title == LocalizedKey.versionInfomation.localized(for: localizationManager.language){
                    Text("\(title)")
                        .font(.body01)
                        .padding(.leading, 16)
                    Spacer()
                    // 현재 버전 가져오기
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text(version)
                            .padding(.trailing, 16)
                            .font(.body01)
                    }
                } else {
                    Text("\(title)")
                        .font(.body01)
                        .padding(.leading, 16)
                    Spacer()
                }
                
            }
           
        }
        .frame(width: Constants.screenWidth, height: 48)

    }
}

enum SettingViewType {
    case policy
    case authorize
    case language
    case withdraw
}

#Preview {
    SettingView()
}
