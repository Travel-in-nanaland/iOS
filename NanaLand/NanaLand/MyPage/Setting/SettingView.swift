//
//  SettingView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI
import UserNotifications

enum SettingViewType {
    case announcement
    case policy
    case authorize
    case language
    case withdraw
}

struct SettingView: View {
    @State private var showAlert = false
    @State var alertResult = false
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("provider") var provider: String = ""
    @State var toggleIsOn: Bool = false
    var body: some View {
        
        ZStack{
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
                    SettingItemButtonView(title: LocalizedKey.announcement.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    SettingItemButtonView(title: LocalizedKey.termsAndPolicies.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    SettingItemButtonView(title: LocalizedKey.accessPolicyGuide.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    SettingItemButtonView(title: LocalizedKey.notificationSettings.localized(for: localizationManager.language), toggleIsOn: $toggleIsOn)
                        .onChange(of: toggleIsOn) { newValue in
                            if newValue {
                                UNUserNotificationCenter.current().getNotificationSettings { settings in
                                    if settings.authorizationStatus == .notDetermined {
                                        // 권한 요청
                                        NotificationManager.nm.request_authorization()
                                    } else if settings.authorizationStatus == .denied {
                                        // 권한 거부된 상태: 설정 화면으로 안내
                                        DispatchQueue.main.async {
                                            toggleIsOn = false
                                             NotificationManager.nm.openAppSettings()
                                        }
                                    }
                                }
                            }
                        }
                    SettingItemButtonView(title: LocalizedKey.languageSetting.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    SettingItemButtonView(title: LocalizedKey.versionInfomation.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    
                    Divider()
                    
                    if provider == "GUEST" {
                        
                        Button {
                            AppState.shared.navigationPath.removeLast()
                            UserDefaults.standard.setValue(false, forKey: "isLogin")
                        } label: {
                            HStack(spacing: 0) {
                                Text(.join)
                                    .font(.body02)
                                    .padding(.leading, 16)
                                    .padding(.top, 20)
                                Spacer()
                            }
                        }
                        
                    } else {
                        // 로그아웃 alert창 띄울 버튼
                        Button {
                            showAlert = true
                        } label: {
                            HStack(spacing: 0) {
                                Text(.logout)
                                    .font(.body02)
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
                                    UserDefaults.standard.removeObject(forKey: "UserEmail")
                                },
                                rightButtonAction: {
                                    showAlert = false
                                }
                            )
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                        
                        SettingItemButtonView(title: LocalizedKey.memberWithdraw.localized(for: localizationManager.language), toggleIsOn: .constant(false))
                    }
                }
                Spacer()
            }
        }
        .toolbar(.hidden)
        .navigationDestination(for: SettingViewType.self) { viewType in
            switch viewType {
            case .announcement:
                NoticeMainView()
            case .policy:
                PolicyView()
            case .authorize:
                AuthorizeView()
            case .language:
                LanguageView()
            case .withdraw:
                WithdrawView()
            }
        }
        .onAppear {
            // 알림 권한 상태를 확인해 초기 토글 상태를 설정
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    toggleIsOn = settings.authorizationStatus == .authorized
                }
            }
        }
    }
}
// 설정창에 있는 버튼들
struct SettingItemButtonView: View {
    var title = ""
    var path: SettingViewType? = nil
    @EnvironmentObject var localizationManager: LocalizationManager
    @AppStorage("provider") var provider: String = ""
    @Binding var toggleIsOn: Bool
    var body: some View {
        Button {
            
            switch title {
            case LocalizedKey.announcement.localized(for: localizationManager.language):
                if provider == "GUEST" {
                    AppState.shared.showRegisterInduction = true
                } else {
                    AppState.shared.navigationPath.append(SettingViewType.announcement)
                }
            case LocalizedKey.termsAndPolicies.localized(for: localizationManager.language):
                if provider == "GUEST" {
                    AppState.shared.showRegisterInduction = true
                } else {
                    AppState.shared.navigationPath.append(SettingViewType.policy)
                }
            case LocalizedKey.accessPolicyGuide.localized(for: localizationManager.language):
                if provider == "GUEST" {
                    AppState.shared.showRegisterInduction = true
                } else {
                    AppState.shared.navigationPath.append(SettingViewType.authorize)
                }
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
                        .font(.body02)
                        .padding(.leading, 16)
                    Spacer()
                    // 현재 버전 가져오기
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text(version)
                            .padding(.trailing, 16)
                            .font(.body02)
                    }
                } else if title == LocalizedKey.notificationSettings.localized(for: localizationManager.language) {
                    
                    Text("\(title)")
                        .font(.body02)
                        .padding(.leading, 16)
                    
                    Spacer()
                    
                    Toggle(isOn: $toggleIsOn, label: {
                        
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color.main))
                    .padding(.trailing, 16)
                    
                    
                } else {
                    Text("\(title)")
                        .font(.body02)
                        .padding(.leading, 16)
                    Spacer()
                }
                
            }
            
        }
        .frame(width: Constants.screenWidth, height: 48)
    }
}

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let nm = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func request_authorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Request Authorization Error: \(error.localizedDescription)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(LocalizationManager())
}
