//
//  ReportReasonView.swift
//  NanaLand
//
//  Created by juni on 8/16/24.
//

import SwiftUI

struct ReportReasonView: View {
    var id: Int64
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .report, showBackButton: true)
                .frame(height: 56)
                .padding(.bottom, 24)
            VStack(spacing: 0) {
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 0) {
   
                        Text("신고하는 이유를 알려주세요!")
                            .padding(.bottom, 4)
                            .font(.title01_bold)
                        Text("타당한 근거 없이 신고된 내용은 관리자 확인 후 반영되지 않을 수 있습니다.")
                            .font(.body02)
                            .foregroundStyle(Color.gray1)
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 32)
                            .padding(.trailing, 88)
                        VStack(spacing: 16) {
                            ReportReasonItemButtonView(id: id, title: "영리목적 / 홍보성")
                            ReportReasonItemButtonView(id: id, title: "마음에 들지 않습니다")
                            ReportReasonItemButtonView(id: id, title: "욕설/인신공격")
                            ReportReasonItemButtonView(id: id, title: "개인정보 노출")
                            ReportReasonItemButtonView(id: id, title: "음란 / 선정성")
                            ReportReasonItemButtonView(id: id, title: "시설 폐업 및 다른 시설에 대한 리뷰")
                            ReportReasonItemButtonView(id: id, title: "약물")
                            ReportReasonItemButtonView(id: id, title: "학대 / 폭력")
                            ReportReasonItemButtonView(id: id, title: "기타")
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
            case let .write(claimType, id):
                ReportWriteView(claimType: claimType, id: id)
            }
        }
    }
}

struct ReportReasonItemButtonView: View {
    var id: Int64
    var title: String
    var body: some View {
        VStack(spacing: 0) {
            Button {
                AppState.shared.navigationPath.append(ReportReasonViewType.write(claimType: title, id: id))
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
    case write(claimType: String, id: Int64)
}

#Preview {
    ReportReasonView(id: 0)
}
