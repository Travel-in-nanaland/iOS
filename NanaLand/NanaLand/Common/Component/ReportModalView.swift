//
//  ReportModalView.swift
//  NanaLand
//
//  Created by juni on 8/1/24.
//

import SwiftUI

struct ReportModalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var reportReasonViewFlag: Bool
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = ExperienceDetailViewModel()
    @StateObject var appState = AppState.shared
    var body: some View {
        
        VStack(spacing: 0){
            HStack(spacing: 0) {
                Spacer()
                Button {
                    reportReasonViewFlag = false
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("icX")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
            }
            Spacer()
            HStack(spacing: 0) {
                Button {
                    reportReasonViewFlag = true
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("신고")
                        .padding(.leading, 16)

                }
                
                Spacer()
            }
            .frame(height: 48)
            .padding(.bottom, 11)
        }
    }
}

enum ReportModalViewType: Hashable {
    case report
}
//
//#Preview {
//    ReportModalView()
//}
