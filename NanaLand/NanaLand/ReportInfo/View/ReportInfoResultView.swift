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
			
			LottieView(jsonName: "report_complete_comment")
				.frame(width: itemSize, height: itemSize)
				.padding(.leading, 59)
				.padding(.trailing, 49)
			
			Text(.thxForReportInfoTitle)
				.multilineTextAlignment(.center)
                .padding(.bottom, Constants.screenWidth * (22 / 360))
				.font(.title01_bold)
				.foregroundStyle(Color.main)
			
			Text(.thxForReportInfoDescription1)
				.multilineTextAlignment(.center)
				.font(.body01)
				.foregroundStyle(Color.baseBlack)
				.padding(.bottom, Constants.screenWidth * (24 / 360))
            
            Text(.thxForReportInfoDescription2)
                .multilineTextAlignment(.center)
                .font(.body01)
                .foregroundStyle(Color.baseBlack)
            
            Spacer()
			
			Button(action: {
				Task {
					await reportInfoVM.action(.onTapGoToContentButton)
				}
			}, label: {
				RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.main)
					.frame(height: 48)
					.overlay {
						Text(.showContentAgain)
							.font(.body_bold)
							.foregroundStyle(Color.white)
					}
			})
			.padding(.bottom, 16)
		}
		.padding(.horizontal, 16)
		.toolbar(.hidden, for: .navigationBar)
	}
}

#Preview {
	ReportInfoResultView(reportInfoVM: ReportInfoViewModel())
}
