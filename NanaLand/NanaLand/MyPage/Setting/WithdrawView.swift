//
//  WithdrawView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct WithdrawView: View {
    var buttonName = ["콘텐츠 내용 부족", "서비스 이용 불편", "커뮤니티 사용 불편", "방문 횟수 거의 없음"]
    @State private var buttonSelected = [false, false, false, false]
    @State private var showAlert = false
    @State private var alertResult = false
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: "회원탈퇴", showBackButton: true)
                .padding(.bottom, 32)
        }
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Text("nanaland in Jeju")
                            .font(.largeTitle01)
                            .foregroundStyle(Color.main)
                            .padding(.leading, 16)
                            
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    HStack(spacing: 0) {
                        Text("서비스 탈퇴 안내 사항")
                            .font(.title02_bold)
                            .padding(.leading, 16)
                            
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        WithdrawViewItem(itemNumber: 1, contents: "본 서비스를 탈퇴하시면 나나랜드인제주 서비스 기반으로 제공되는 모든 서비스로부터 해지 및 소멸되는 점을 안내드립니다.")
                        WithdrawViewItem(itemNumber: 2, contents: "회원 탈퇴를 하시면, 보유하고 계신 각종 쿠폰, 포인트는 자동 소멸되며 재가입하실 경우에도 복원되지 않습니다.")
                        WithdrawViewItem(itemNumber: 3, contents: "서비스 탈퇴 후 전자상거래법에 의해 보존해야 하는 거래기록은 90일간 보관됩니다.")
                        WithdrawViewItem(itemNumber: 4, contents: "회원 탈퇴 시 회원가입 이벤트에는 재 참여하실 수 없습니다.")
                        WithdrawViewItem(itemNumber: 5, contents: "탈퇴 후 90일 이내에 재가입을 하시면, 기존 계정으로 사용하실 수 있습니다.")
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 16 )
                    
                    HStack(spacing: 0) {
                        Text("안내사항을 확인하였으며 동의합니다.")
                            .font(.body02_bold)
                            .foregroundStyle(.gray1)
                    }
                    .padding(.bottom, 16)
                    
                    Divider()
                        .padding(.bottom, 16)
                    
                    HStack(spacing: 0) {
                        Text("서비스 탈퇴 사유")
                        Text("(필수)")
                            .foregroundStyle(.main)
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                    .font(.title02_bold)
                    
                    VStack(spacing: 0) {
                        ForEach(0...3, id: \.self) { index in
                            Button(action: {
                                withAnimation(nil) {
                                    buttonSelected[index].toggle()
                                }
                                
                            }, label: {
                                HStack(spacing: 0){
                                    Image(buttonSelected[index] ? "icCheckmarkFilled" : "icCheckmark")
                                        .padding(.trailing, 8)
                                    Text(buttonName[index])
                                        .font(.body02)
                                        .foregroundStyle(buttonSelected[index] ? .main : .gray1 )
                                    Spacer()
                                }
                                .frame(height: 48)
                                .padding(.leading, 16)
                                
                            })
               
                        }
                        
                    }
                    .padding(.bottom, 16)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Button(action: {
                            showAlert = true
                        }, label: {
                            Text("탙퇴")
                                .padding(.top, 13)
                                .padding(.bottom, 13)
                                .padding(.leading, 63)
                                .padding(.trailing, 63)
                                .foregroundStyle(.gray1)
                                .font(.body_bold)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundStyle(.gray2)
                        )
                        .padding(.leading, 16)
                        .fullScreenCover(isPresented: $showAlert) {
                            AlertView(title: "회원탈퇴", alertTitle: "정말 제주도 여행 정보와 혜택을 받지 않으시겠습니까? 😢", subAlertTitle: "*90일 이내에 재가입 시, 기존 계정으로 로그인이 됩니다.", showAlert: $showAlert, alertResult: $alertResult)
                        }
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        } //애니메이션 효과 없애기
                        
                        Spacer()
                        
                        Button(action: {}, label: {
                            Text("취소")
                                .padding(.top, 13)
                                .padding(.bottom, 13)
                                .padding(.leading, 63)
                                .padding(.trailing, 63)
                                .foregroundStyle(.white)
                                .font(.body_bold)
                        })
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .foregroundStyle(.main)
                        )
                        .padding(.trailing, 16)
                        
                        
                    }
                    .padding(.bottom, 15)
                    
                }
                .toolbar(.hidden)
            
                .frame(height: geometry.size.height)
                
            }
            .frame(maxHeight: geometry.size.height)
           
        }
        
        
       
    }
}


struct WithdrawViewItem: View {
    var itemNumber: Int
    var contents = ""
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\(itemNumber).")
            Text(contents)
               
        }
        .font(.caption01)
        .foregroundStyle(.gray1)
    }
    
    
}

#Preview {
    WithdrawView()
}
