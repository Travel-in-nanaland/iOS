//
//  WithdrawView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

enum WithDrawType: String, CaseIterable {
	case INSUFFICIENT_CONTENT  // 콘텐츠 내용 부족
	case INCONVENIENT_SERVICE  // 서비스 이용 불편
	case INCONVENIENT_COMMUNITY  // 커뮤니티 사용 불편
	case RARE_VISITS  // 방문 횟수 거의 없음
	
	var localizedKey: LocalizedKey {
		switch self {
		case .INSUFFICIENT_CONTENT:
			return .INSUFFICIENT_CONTENT
		case .INCONVENIENT_SERVICE:
			return .INCONVENIENT_SERVICE
		case .INCONVENIENT_COMMUNITY:
			return .INCONVENIENT_COMMUNITY
		case .RARE_VISITS:
			return .RARE_VISITS
		}
	}
}

struct WithdrawView: View {
	let buttonType: [WithDrawType] = WithDrawType.allCases
	@State private var selectedIndex: Int? = nil
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
						ForEach(Array(zip(buttonType.indices, buttonType)), id: \.0) { (index, type) in
                            Button(action: {
                                withAnimation(nil) {
									if selectedIndex == index {
										selectedIndex = nil
									} else {
										selectedIndex = index
									}
                                }
                                
                            }, label: {
                                HStack(spacing: 0){
                                    Image(selectedIndex == index ? "icCheckmarkFilled" : "icCheckmark")
                                        .padding(.trailing, 8)
									Text(type.localizedKey)
                                        .font(.body02)
                                        .foregroundStyle(selectedIndex == index ? .main : .gray1 )
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
							if selectedIndex != nil {
								showAlert = true
							}
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
							AlertView(
								title: .withdrawAlertTitle,
								message: .withdrawAlertMessage,
								leftButtonTitle: .cancel,
								rightButtonTitle: .delete,
								leftButtonAction: {
									showAlert = false
								},
								rightButtonAction: {
									// 회원탈퇴
									AuthManager(registerVM: RegisterViewModel()).withdraw(withdrawalType: buttonType[selectedIndex!].rawValue)
								}
							)
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
