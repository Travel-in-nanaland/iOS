//
//  SettingView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        
        VStack(spacing: 0) {
            NanaNavigationBar(title: "설정", showBackButton: true)
                .padding(.bottom, 20)
            HStack(spacing: 0) {
                Text("사용 설정")
                    .font(.body02_bold)
                    .padding(.leading, 17)
                
                Spacer()
            }
            .padding(.bottom, 6)
            VStack(spacing: 0) {
                SettingItemButtonView(title: "약관 및 정책")
                SettingItemButtonView(title: "접근권한 안내")
                SettingItemButtonView(title: "언어 설정")
                SettingItemButtonView(title: "버전 정보")
                Divider()
                SettingItemButtonView(title: "로그아웃")
                SettingItemButtonView(title: "회원 탈퇴")

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
                PolicyView()
            case .language:
                PolicyView()
            case .version:
                PolicyView()
            case .logout:
                PolicyView()
            case .withdraw:
                PolicyView()
            }
            
        }
        
    }
}
// 설정창에 있는 버튼들
struct SettingItemButtonView: View {
    var title = ""
    var path: SettingViewType? = nil
    var body: some View {
        Button {
            switch title {
            case "약관 및 정책":
                AppState.shared.navigationPath.append(SettingViewType.policy)
            case "접근권한 안내":
                AppState.shared.navigationPath.append(SettingViewType.authorize)
            case "언어 설정":
                AppState.shared.navigationPath.append(SettingViewType.language)
            case "버전 정보":
                AppState.shared.navigationPath.append(SettingViewType.version)
            case "로그아웃":
                AppState.shared.navigationPath.append(SettingViewType.logout)
            case "회원 탈퇴":
                AppState.shared.navigationPath.append(SettingViewType.withdraw)
            default:
                break
            }
            
        } label: {
            HStack(spacing: 0) {
                Text("\(title)")
                    .font(.body01)
                    .padding(.leading, 16)
                Spacer()
            }
           
        }
        .frame(width: Constants.screenWidth, height: 48)

    }
}

enum SettingViewType {
    case policy
    case authorize
    case language
    case version
    case logout
    case withdraw
}

#Preview {
    SettingView()
}
