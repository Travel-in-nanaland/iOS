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
			
			LottieView(jsonName: "report_info_star")
				.frame(width: itemSize, height: itemSize)
				.padding(.leading, 59)
				.padding(.trailing, 49)
			
			Text("정보 수정 제안 감사드립니다")
				.padding(.bottom, 8)
				.font(.largeTitle02)
				.foregroundStyle(Color.main)
			
			Text("정보 수정 제안으로\n여행지의 매력도 함께 올라갔어요!\n\n점점 기대될 것 같아요🧚‍♀️")
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
						Text("콘텐츠 다시 보러 가기")
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
						Text("다른 항목 추가하기")
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
