//
//  RegisterTermsAgreementView.swift
//  NanaLand
//
//  Created by 정현우 on 5/13/24.
//

import SwiftUI

struct RegisterTermsAgreementView: View {
	@EnvironmentObject var localizaionManager: LocalizationManager
	@EnvironmentObject var registerVM: RegisterViewModel
	
	@State var safariLink: String = ""
	@State var showTermsWithSafari: Bool = false
	
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
		.sheet(isPresented: $showTermsWithSafari) {
			if let url = URL(string: safariLink) {
				SafariView(url: url)
					.ignoresSafeArea()
			}
		}
		.onChange(of: safariLink) { _ in
			// subview에서 update한 링크가 SafariView에 반영되지 않아
			// body 업데이트를 위한 임시 코드
		}
	}
	
	private var titleView: some View {
		HStack {
			VStack(alignment: .leading, spacing: 16) {
				Image(.logoInCircle)
					.resizable()
					.frame(width: 64, height: 64)
				
				Text(.welcomeToNanaLand)
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
			
			Text(.allAgree)
				.font(.gothicNeo(.semibold, size: 16))
				.foregroundStyle(Color.baseBlack)
		}
	}
	
	private var agreements: some View {
		VStack(spacing: 24) {
			agreementItem(
				title: .termsOfUseAgree,
				isOptional: false,
				isChecked: registerVM.state.privacyAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapPrivacyAgreement)
					}
				},
				arrowAction: {
					safariLink = "https://marbled-melon-1d2.notion.site/1d159953c91a4f25967f5e44e9662d57?pvs=4"
					showTermsWithSafari = true
				}
			)
			
			agreementItem(
				title: .marketingAgree,
				isOptional: true,
				isChecked: registerVM.state.marketingAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapMarketingAgreement)
					}
				},
				arrowAction: {
					safariLink = "https://marbled-melon-1d2.notion.site/a46f94192c5a43269d784b1c940634f7?pvs=4"
					showTermsWithSafari = true
				}
			)
			
			agreementItem(
				title: .locationAgree,
				isOptional: true,
				isChecked: registerVM.state.locationAgreement,
				checkmarkAction: {
					Task {
						await registerVM.action(.onTapLocationAgreement)
					}
				},
				arrowAction: {
					safariLink = "https://marbled-melon-1d2.notion.site/55d9bfc40f6c41728b5b16f79ed9b08d?pvs=4"
					showTermsWithSafari = true
				}
			)
		}
		.padding(.horizontal, 16)
	}
	
	private func agreementItem(title: LocalizedKey, isOptional: Bool, isChecked: Bool, checkmarkAction: @escaping () -> Void, arrowAction: @escaping () -> Void) -> some View {
		HStack(spacing: 8) {
			Button(action: {
				checkmarkAction()
			}, label: {
				Image(isChecked ? .icCheckmarkFilled : .icCheckmark)
			})
			
			HStack(spacing: 0) {
				Text(title)
					.foregroundColor(Color.gray1)
				+
				Text(" ")
				+
				Text(isOptional ? .optionalWithBracket : .requiredWithBracket)
					.foregroundColor(isOptional ? Color.gray1 : Color.main)
			}
			.font(.body02)
			
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
					Text(.confirm)
						.foregroundStyle(Color.baseWhite)
						.font(.body_bold)
				}
		})
		
	}
}

#Preview {
	@StateObject var lm = LocalizationManager()
	lm.language = .malaysia
    return RegisterTermsAgreementView()
		.environmentObject(lm)
		.environmentObject(RegisterViewModel())
}
