//
//  NoticeDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI
import Kingfisher

struct NoticeDetailView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = NoticeDetailViewModel()
    var id: Int64
    @State private var isAPICalled = false
    var layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        NavigationBar(title: "")
            .frame(height: 56)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            .padding(.bottom, 10)
        
        ScrollView {
            if isAPICalled {
                ZStack {
                    VStack(alignment: .leading) {
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.state.getNoticeDetailResponse.title)
                                .font(.title02_bold)
                                .foregroundColor(.black)
                            
                            Text(viewModel.state.getNoticeDetailResponse.createdAt)
                                .font(.caption01)
                                .foregroundColor(.black)
                                .padding(.top, 1)
                        }
                        .padding()
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray2)
                            .padding(.top, 1)
                        
                        LazyVGrid(columns: layout) {
                            if let contents = viewModel.state.getNoticeDetailResponse.noticeContents {
                                ForEach(contents.indices, id: \.self) { index in
                                    let notice = contents[index]
                                    
                                    // 이미지와 내용 출력
                                    if let image = notice.image?.originUrl, !image.isEmpty {
                                        KFImage(URL(string: image))
                                            .resizable()
                                            .frame(width: Constants.screenWidth * 0.9, height: Constants.screenHeight * 0.3)
                                            .cornerRadius(8)
                                            .padding()
                                    }
                                    
                                    if let content = notice.content, !content.isEmpty {
                                        Text(content)
                                            .font(.body02)
                                            .foregroundColor(.black)
                                            .padding(.leading, 15)
                                            .padding(.trailing, 15)
                                    }
                                }
                            }
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                }
                .toolbar(.hidden)
            }
        }
        .onAppear {
            Task {
                await getNoticeDetailItem(id: id)
                isAPICalled = true
            }
        }
    }
    
    func getNoticeDetailItem(id: Int64) async {
        await viewModel.action(.getNoticeDetailItem(id: id))
    }
}

#Preview {
    NoticeDetailView(id: 1)
}
