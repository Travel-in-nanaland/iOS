//
//  ReportInfoMainView.swift
//  NanaLand
//
//  Created by 정현우 on 5/22/24.
//

import SwiftUI



struct ReportInfoMainView: View {
	let categories: [ReportInfoCategory] = [
		ReportInfoCategory(imageName: .icPhone, type: .numberAndHompage),
		ReportInfoCategory(imageName: .icClock, type: .operatinghour),
		ReportInfoCategory(imageName: .icPin, type: .placeNameAndLocation),
		ReportInfoCategory(imageName: .icMoney, type: .priceInfo),
		ReportInfoCategory(imageName: .icTrashcan, type: .deletePlace)
	]
	let id: Int64
	let category: Category
	@StateObject var reportInfoVM = ReportInfoViewModel()
	
	var body: some View {
		VStack(spacing: 0) {
			NanaNavigationBar(title: String(localized: "modifyInfo"), showBackButton: true)
				.padding(.bottom, 32)
			
			ScrollView(.vertical, showsIndicators: false) {
				VStack(alignment: .leading, spacing: 0) {
					Text(String(localized: "suggestInfoModificationTitle"))
						.font(.title01_bold)
						.padding(.bottom, 4)
					
					Text(String(localized: "suggestInfoModificationDescription"))
						.lineLimit(2)
						.font(.body02)
						.padding(.bottom, 32)
						.foregroundStyle(Color(hex: 0x717171))
					
					ForEach(categories, id: \.self) { category in
						Button(action: {
							Task {
								await reportInfoVM.action(.onTapReportItem(type: category.type))
							}
						}, label: {
							ReportInfoItemView(category: category)
								.padding(.bottom, 16)
						})
						
					}
					
					Text(String(localized: "shareETCInfo"))
						.font(.title01_bold)
						.padding(.top, 32)
						.padding(.bottom, 16)
					
					NavigationLink(destination: {
						ReportInfoWritingView(reportInfoVM: reportInfoVM)
					}, label: {
						ReportInfoItemView(category: ReportInfoCategory(imageName: .icGift, type: .provideService))
					})
					.simultaneousGesture(TapGesture().onEnded {
						Task {
							await reportInfoVM.action(.onTapReportItem(type: .provideService))
						}
					})
					
					
				}
			}
			.padding(.horizontal, 16)
		}
		.toolbar(.hidden, for: .navigationBar)
		.navigationDestination(for: ReportInfoViewType.self) { viewType in
			switch viewType {
			case .reportWriting:
				ReportInfoWritingView(reportInfoVM: reportInfoVM)
			case .reportResult:
				ReportInfoResultView(reportInfoVM: reportInfoVM)
			}
		}
		.onAppear {
			reportInfoVM.state.postId = id
			reportInfoVM.state.category = category
		}
	}
}

struct ReportInfoItemView: View {
	let category: ReportInfoCategory
	
	var body: some View {
		HStack(spacing: 8) {
			Image(category.imageName)
				.resizable()
				.frame(width: 28, height: 28)
				.foregroundStyle(Color.baseBlack)
			
			Text(String(localized: "\(category.type.rawValue)"))
				.font(.body02)
				.foregroundStyle(Color.baseBlack)
			
			Spacer()
			
			Image(.icRight)
				.resizable()
				.frame(width: 24, height: 20)
				.foregroundStyle(Color.baseBlack)
		}
		.padding(.horizontal, 12)
		.frame(height: 48)
		.background {
			RoundedRectangle(cornerRadius: 12)
				.stroke(Color.gray2, lineWidth: 1)
			
		}
		
	}
}

#Preview {
	NavigationStack {
		ReportInfoMainView(id: 0, category: .market)
	}
}
