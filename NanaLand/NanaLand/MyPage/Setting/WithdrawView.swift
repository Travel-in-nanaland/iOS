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
    @EnvironmentObject var localizationManager: LocalizationManager
 
	let buttonType: [WithDrawType] = WithDrawType.allCases
	@State private var selectedIndex: Int? = nil
    @State private var showAlert = false
    @State private var alertResult = false
    var body: some View {
        VStack(spacing: 0) {
			NanaNavigationBar(title: .accountDeletion, showBackButton: true)
                .padding(.bottom, 32)
			
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
						Text(.withDrawNotification)
							.font(.title02_bold)
							.padding(.leading, 16)
							
						Spacer()
					}
					.padding(.bottom, 8)
					
					VStack(alignment: .leading, spacing: 8) {
						WithdrawViewItem(itemNumber: 1, contents: LocalizedKey.firstNotification.localized(for: localizationManager.language))
						WithdrawViewItem(itemNumber: 2, contents: LocalizedKey.secondNotification.localized(for: localizationManager.language))
						WithdrawViewItem(itemNumber: 3, contents: LocalizedKey.thirdNotification.localized(for: localizationManager.language))
						WithdrawViewItem(itemNumber: 4, contents: LocalizedKey.fourthNotification.localized(for: localizationManager.language))
						WithdrawViewItem(itemNumber: 5, contents: LocalizedKey.fifthNotification.localized(for: localizationManager.language))
					}
					.padding(.leading, 16)
					.padding(.trailing, 16)
					.padding(.bottom, 16)
					
					HStack(spacing: 0) {
						Text(.notificationConsent)
							.font(.body02_bold)
							.foregroundStyle(.gray1)
							.multilineTextAlignment(.center)
					}
					.padding(.bottom, 16)
					
					Divider()
						.padding(.bottom, 16)
					
					HStack(spacing: 2) {
						Text(.withDrawReason)
						Text(.requiredWithBracket)
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
					Spacer()
					
				}
			}
			.padding(.bottom, 16)
			
			HStack(spacing: 0) {
				Button(action: {
					if selectedIndex != nil {
						showAlert = true
					}
				}, label: {
					Text(.withdraw)
						.foregroundStyle(.gray1)
						.font(.body_bold)
				})
				.background(
					RoundedRectangle(cornerRadius: 50)
						.frame(width: (Constants.screenWidth - 48) / 2, height: 48)
						.foregroundStyle(.gray2)
				)
				.frame(width: (Constants.screenWidth - 48) / 2, height: 48)
				.padding(.leading, 16)
				
				
				Spacer()
				
				Button(action: {}, label: {
					Text(.cancel)
						.foregroundStyle(.white)
						.font(.body_bold)
				})
				.background(
					RoundedRectangle(cornerRadius: 50)
						.frame(width: (Constants.screenWidth - 48) / 2, height: 48)
						.foregroundStyle(.main)
				)
				.frame(width: (Constants.screenWidth - 48) / 2, height: 48)
				.padding(.trailing, 16)
				
				
			}
			.padding(.bottom, 15)
        }
		.toolbar(.hidden)
		.fullScreenCover(isPresented: $showAlert) {
			AlertView(
				title: .withdrawAlertTitle,
				message: .withdrawAlertMessage,
				leftButtonTitle: .yes,
				rightButtonTitle: .cancel,
				leftButtonAction: {
                    AuthManager(registerVM: RegisterViewModel()).withdraw(withdrawalType: buttonType[selectedIndex!].rawValue)
				},
				rightButtonAction: {
					// 회원탈퇴
                    showAlert = false	
				}
			)
		}
		.transaction { transaction in
			transaction.disablesAnimations = true
		} //애니메이션 효과 없애기
    }
}


struct WithdrawViewItem: View {
    var itemNumber: Int
    var contents = ""
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\(itemNumber).")
            Text(contents)
                .padding(.leading, 0)
                .padding(.trailing, 16)
                .multilineTextAlignment(.leading)
                
               
        }
        .font(.caption01)
        .foregroundStyle(.gray1)
    }
    
    
}

#Preview {
    WithdrawView()
}
