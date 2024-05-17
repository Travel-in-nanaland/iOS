//
//  RegisterTermsAgreementView.swift
//  NanaLand
//
//  Created by 정현우 on 5/13/24.
//

import SwiftUI

struct RegisterTermsAgreementView: View {
	@EnvironmentObject var registerVM: RegisterViewModel
	
    var body: some View {
		VStack(spacing: 0) {
			titleView
				.padding(.vertical, 80)
				.padding(.leading, 16)
			
			VStack(alignment: .leading, spacing: 20) {
				allAgreement
					.padding(.horizontal, 16)
				
				Rectangle()
					.fill(Color.gray2)
					.frame(width: Constants.screenWidth, height: 1)
				
				agreements
			}
			
			Spacer()
			
			okButton
		}
		.padding(.bottom, 24)
    }
	
	private var titleView: some View {
		HStack {
			VStack(alignment: .leading, spacing: 16) {
				Image(.logoInCircle)
					.resizable()
					.frame(width: 64, height: 64)
				
				Text("nanaland in Jeju에\n오신 것을 환영합니다.")
					.lineLimit(2)
					.multilineTextAlignment(.leading)
					.font(.largeTitle01)
					.foregroundStyle(Color.baseBlack)
				
			}
			
			Spacer()
		}
	}
	
	private var allAgreement: some View {
		HStack(spacing: 8) {
			Button(action: {
				Task {
					await registerVM.action(.onTapAllAgreement)
				}
			}, label: {
				Image(registerVM.isAllAgree() ? .icCheckmarkFilled : .icCheckmark)
			})
			
			Text("전체 동의")
				.font(.gothicNeo(.semibold, size: 16))
				.foregroundStyle(Color.baseBlack)
		}
	}
	
	private var agreements: some View {
		VStack(spacing: 24) {
			agreementItem(
				title: "이용약관 동의 및 개인정보 처리방침",
				isOptional: false,
				isChecked: registerVM.state.privacyAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapPrivacyAgreement)
					}
				},
				arrowAction: {
					
				}
			)
			
			agreementItem(
				title: "마케팅 활용 동의",
				isOptional: true,
				isChecked: registerVM.state.marketingAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapMarketingAgreement)
					}
				},
				arrowAction: {
					
				}
			)
			
			agreementItem(
				title: "위치기반 서비스 약관 동의",
				isOptional: true,
				isChecked: registerVM.state.locationAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapLocationAgreement)
					}
				},
				arrowAction: {
					
				}
			)
		}
		.padding(.horizontal, 16)
	}
	
	private func agreementItem(title: String, isOptional: Bool, isChecked: Bool, checkmarkAction: @escaping () -> Void, arrowAction: @escaping () -> Void) -> some View {
		HStack(spacing: 8) {
			Button(action: {
				checkmarkAction()
			}, label: {
				Image(isChecked ? .icCheckmarkFilled : .icCheckmark)
			})
			
			HStack(spacing: 0) {
				Text(title)
					.font(.body02)
					.foregroundStyle(Color.gray1)
				
				if isOptional {
					Text(" (선택)")
						.font(.body02)
						.foregroundStyle(Color.gray1)
				} else {
					Text(" (필수)")
						.font(.body02)
						.foregroundStyle(Color.main)
				}
			}
			
			Spacer()
			
			Button(action: {
				arrowAction()
			}, label: {
				Image(.icRight)
					.resizable()
					.frame(width: 16, height: 16)
					.foregroundStyle(Color.gray1)
			})
			
			
		}
	}
	
	private var okButton: some View {
		Button(action: {
			Task {
				await registerVM.action(.onTapOkButtonInAgreement)
			}
		}, label: {
			RoundedRectangle(cornerRadius: 30)
				.fill(Color.main)
				.frame(width: Constants.screenWidth - 32, height: 48)
				.opacity(registerVM.state.privacyAgreement ? 1.0 : 0.1)
				.overlay {
					Text("확인")
						.foregroundStyle(Color.baseWhite)
						.font(.body_bold)
				}
		})
		
	}
}

#Preview {
    RegisterTermsAgreementView()
}
