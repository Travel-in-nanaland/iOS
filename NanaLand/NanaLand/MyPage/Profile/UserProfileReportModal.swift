//
//  UserProfileReportModal.swift
//  NanaLand
//
//  Created by wodnd on 12/28/24.
//

import SwiftUI
import CustomAlert

struct UserProfileReportModal: View {
    
    var id: Int64
    @Binding var isShowingReport: Bool
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                    .shadow(radius: 1)
                    .foregroundColor(.white)
                    .overlay {
                        VStack(spacing: 21){
                            Button(action: {
                                isShowingReport = false
                                AppState.shared.navigationPath.append(UserProfileViewType.reportReview(id: id, isReport: false))
                            }, label: {
                                Text(.report)
                                    .font(.body01)
                                    .frame(height: Constants.screenWidth * (26 / 360))
                                    .foregroundColor(.black)
                            })
                        }
                    }
                
                Button(action: {
                    isShowingReport.toggle()
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                        .foregroundColor(.gray3)
                        .shadow(radius: 1)
                        .overlay {
                            Text(.close)
                                .font(.body01)
                                .foregroundColor(.black)
                        }
                })
            }
        }
    }
}

#Preview {
    UserProfileReportModal(id: 0, isShowingReport: .constant(false))
}
