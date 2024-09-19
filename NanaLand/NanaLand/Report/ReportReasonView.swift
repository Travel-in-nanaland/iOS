//
//  ReportReasonView.swift
//  NanaLand
//
//  Created by juni on 8/16/24.
//

import SwiftUI

struct ReportReasonView: View {
    var id: Int64
    @Binding var isReport: Bool
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .report, showBackButton: true)
                .frame(height: 56)
                .padding(.bottom, 24)
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
     
                        Text(.reportReason)
                            .padding(.bottom, 4)
                            .font(.title01_bold)
                        Text(.reportWarning)
                            .font(.body02)
                            .foregroundStyle(Color.gray1)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 32)
                            .padding(.trailing, 88)
                        VStack(spacing: 16) {
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.profitPromotionalPurpose.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.unlike.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.personalAttack.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.personalInformationExposure.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.obscenitySensuality.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.facilityClosures.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.medication.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.AbuseViolence.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                            ReportReasonItemButtonView(id: id, title: LocalizedKey.etc.localized(for: LocalizationManager.shared.language), isReport: $isReport)
                        }
                    }
                }
                
            }
        }
        .toolbar(.hidden)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .navigationDestination(for: ReportReasonViewType.self) { viewType in
            switch viewType {
            case let .write(claimType, id, isReport):
                ReportWriteView(isReport: $isReport, claimType: claimType, id: id)
            }
        }
    }
}

struct ReportReasonItemButtonView: View {
    var id: Int64
    var title: String
    @Binding var isReport: Bool
    var body: some View {
        VStack(spacing: 0) {
            Button {
                AppState.shared.navigationPath.append(ReportReasonViewType.write(claimType: title, id: id, isReport: isReport))
            } label: {
                HStack(spacing: 0) {
                    Text("\(title)")
                        .foregroundStyle(.black)
                        .padding(.leading, 12)
                        .font(.body02)
                    Spacer()
                    Image("icRight")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.black)
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 16)
                }
            }
        }
        .frame(width: Constants.screenWidth - 32, height: 48)
        .overlay(
            RoundedRectangle(cornerRadius: 12) // 동일한 코너 반경 설정
                .stroke(Color.gray2, lineWidth: 1) // 테두리 색상과 두께 설정
        )
    }
}

enum ReportReasonViewType: Hashable {
    case write(claimType: String, id: Int64, isReport: Bool)
}

//#Preview {
//    ReportReasonView(id: 0)
//}
