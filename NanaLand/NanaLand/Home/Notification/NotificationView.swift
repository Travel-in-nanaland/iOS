//
//  NotificationView.swift
//  NanaLand
//
//  Created by 정현우 on 6/4/24.
//

import SwiftUI
// 푸시알림 알림 뷰 
struct NotificationView: View {
    @StateObject var viewModel = NotificationViewModel()
    var layout: [GridItem] = [GridItem(.flexible())]
    @State private var isAPICalled = false
    var body: some View {
		VStack {
			NanaNavigationBar(title: .notification, showBackButton: true)
                .padding(.bottom, 24)

                if Int(viewModel.state.getNotificationResponse.totalElements!) > 0 {
                    ScrollView {
                        if isAPICalled {
                            if viewModel.state.getNotificationResponse.totalElements == 0 {
                                NoResultView()
                                    .frame(height: 70)
                                    .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                            } else {
                                LazyVGrid(columns: layout) {
                                    ForEach(0...Int(viewModel.state.getNotificationResponse.data?.count ?? 0 ) - 1, id: \.self) { idx in
                                        VStack(spacing: 0) {
                                            HStack(alignment: .top, spacing: 0) {
                                                Image("logoInCircle")
                                                    .resizable()
                                                    .frame(width: 32, height: 32)
                                                    .padding(.leading, 16)
                                                    .padding(.trailing, 12)
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text("\(viewModel.state.getNotificationResponse.data![idx].title)")
                                                        .padding(.bottom, 6)
                                                        .font(.body02_bold)
                                                        .foregroundStyle(Color.main)
                                                    Text("\(viewModel.state.getNotificationResponse.data![idx].content)")
                                                        .font(.caption01)
                                                    Text("\(viewModel.state.getNotificationResponse.data![idx].createdAt)")
                                                        .font(.caption02)
                                                        .foregroundStyle(Color.gray1)
                                                }
                                             
                                                Spacer()
                                            }
                                            .padding(.top, 4)
                                            Spacer()
                                        }
                                        .frame(height: 74)
                                    }
                                    
                                    if viewModel.state.page < (viewModel.state.getNotificationResponse.totalElements ?? 0 ) / 12 {
                                        Text("\(viewModel.state.page)")
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    await getNotificationItem(page: viewModel.state.page + 1, size: 12)
                                                    viewModel.state.page += 1
                                                }
                                               
                                            }
                                    }
                                }

                        }
                        
              
                        }
                        
                    }
                }
			Spacer()
		}
		.toolbar(.hidden)
        .onAppear {
            Task {
                await getNotificationItem(page: 0, size: 12)
                isAPICalled = true
            }
        }

    }
    
    func getNotificationItem(page: Int, size: Int) async {
        print("페이지 요청:\(page)")
        await viewModel.action(.getNotificationItem(page: page, size: size))
    }
}

#Preview {
    NotificationView()
}
