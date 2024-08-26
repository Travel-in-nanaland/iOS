//
//  ReportInfoResultView.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import SwiftUI

struct ReportInfoResultView: View {
	@ObservedObject var reportInfoVM: ReportInfoViewModel
	let itemSize = Constants.screenWidth - 108
	
	var body: some View {
		VStack(spacing: 0) {
			Spacer()
			
			LottieView(jsonName: "report_complete")
				.frame(width: itemSize, height: itemSize)
				.padding(.leading, 59)
				.padding(.trailing, 49)
			
			Text(.thxForReportInfoTitle)
				.multilineTextAlignment(.center)
				.padding(.bottom, 8)
				.font(.largeTitle02)
				.foregroundStyle(Color.main)
			
			Text(.thxForReportInfoDescription)
				.multilineTextAlignment(.center)
				.font(.gothicNeo(.medium, size: 18))
				.foregroundStyle(Color.baseBlack)
				.padding(.bottom, 94)
			
			Button(action: {
				Task {
					await reportInfoVM.action(.onTapGoToContentButton)
				}
			}, label: {
				RoundedRectangle(cornerRadius: 50)
					.stroke(Color.main, lineWidth: 1)
					.frame(height: 48)
					.overlay {
						Text(.showContentAgain)
							.font(.body_bold)
							.foregroundStyle(Color.main)
					}
			})
			.padding(.bottom, 16)
			
			Button(action: {
				Task {
					await reportInfoVM.action(.onTapReportAgainButton)
				}
			}, label: {
				RoundedRectangle(cornerRadius: 50)
					.fill(Color.main)
					.frame(height: 48)
					.overlay {
						Text(.reportAgain)
							.font(.body_bold)
							.foregroundStyle(Color.baseWhite)
					}
			})
			.padding(.bottom, 24)
		}
		.padding(.horizontal, 16)
		.toolbar(.hidden, for: .navigationBar)
	}
}

#Preview {
	ReportInfoResultView(reportInfoVM: ReportInfoViewModel())
}
