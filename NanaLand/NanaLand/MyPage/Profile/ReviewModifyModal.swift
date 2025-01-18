//
//  ReviewModifyModal.swift
//  NanaLand
//
//  Created by wodnd on 12/27/24.
//

import SwiftUI
import CustomAlert

struct ReviewModifyModal: View {
    
    var id: Int64
    var category: String
    @Binding var isShowingModify: Bool
    @Binding var showAlert: Bool//삭제하기 alert 여부
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                RoundedRectangle(cornerRadius: 12)
                    .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (96 / 360))
                    .shadow(radius: 1)
                    .foregroundColor(.white)
                    .overlay {
                        VStack(spacing: 21){
                            Button(action: {
                                isShowingModify = false
                                AppState.shared.navigationPath.append(MyPageViewType.detailReview(id: id, category: category))
                            }, label: {
                                Text(.modify)
                                    .font(.body01)
                                    .frame(height: Constants.screenWidth * (26 / 360))
                                    .foregroundColor(.black)
                            })
                            
                            Button(action: {
                                isShowingModify = false
                                showAlert = true
                            }, label: {
                                Text(.delete)
                                    .font(.body01)
                                    .frame(height: Constants.screenWidth * (26 / 360))
                                    .foregroundColor(.black)
                            })
                        }
                    }
                
                Button(action: {
                    isShowingModify.toggle()
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
    ReviewModifyModal(id: 0, category: "", isShowingModify: .constant(false), showAlert: .constant(false))
}
