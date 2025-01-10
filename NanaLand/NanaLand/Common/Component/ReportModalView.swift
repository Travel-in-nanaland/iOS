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
  
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                .shadow(radius: 1)
                .foregroundStyle(.white)
                .overlay {
                    VStack(spacing: 21) {
                        Button(action: {
                            reportReasonViewFlag = true
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text(.report)
                                .font(.body01)
                                .frame(height: Constants.screenWidth * (26 / 360))
                                .foregroundColor(.black)
                        })
                    }
                }
            Button(action: {
                reportReasonViewFlag = false
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                    .foregroundStyle(.gray3)
                    .shadow(radius: 1)
                    .overlay {
                        Text(.close)
                            .font(.body01)
                            .foregroundStyle(.black)
                    }
            })
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
