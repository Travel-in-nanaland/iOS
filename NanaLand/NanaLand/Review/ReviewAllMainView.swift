//
//  ReviewAllMainView.swift
//  NanaLand
//
//  Created by juni on 8/4/24.
//

import SwiftUI
import Kingfisher
// 모든 리뷰 보기 뷰(타 유저 프로필 리뷰 or 마이페이지에서 자신의 리뷰 볼 때)
struct ReviewAllMainView: View {
    @StateObject var viewModel = ReviewAllMainViewModel()
    @State private var isOn = false
    @State private var contentIsOn: [Bool] = []
    @State private var isAPICalled = false
    var memberId: Int64 = 11
    var page: Int = 0
    var size: Int = 30
    var body: some View {
        ZStack() {
            VStack(spacing: 0) {
                NanaNavigationBar(title: .review, showBackButton: true)
                    .padding(.bottom, 24)
                if isAPICalled {
                    if viewModel.state.getReviewAllMainResponse.totalElements >= 1 {
                       
                        ScrollView {
                            
                            ForEach(0...Int(viewModel.state.getReviewAllMainResponse.totalElements) - 1, id: \.self) { index in
                              
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].placeName)")
                                            .padding(.top, 16)
                                            .padding(.leading, 16)
                                            .font(.body02_bold)
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Image("icReviewHeart")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 18, height: 18)
                                                .padding(.trailing, 2)
                                            Text("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].heartCount)")
                                        }
                                        .frame(width: 48, height: 28)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .overlay(
                                                   RoundedRectangle(cornerRadius: 30) // 모서리가 둥근 테두리
                                                       .stroke(Color.gray2, lineWidth: 1) // 테두리 색상과 두께
                                               )
                                        .padding(.top, 16)
                                        .padding(.trailing, 16)
                                        
                                    }
                                    HStack(spacing: 0) {
                                        ForEach(1...5, id: \.self) { number in
                                            Image(systemName: "star.fill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 16)
                                                .foregroundStyle(number <= viewModel.state.getReviewAllMainResponse.data![Int(index)].rating ? .yellow : .gray2)
                                        }
                                    }
                                    .padding(.top, 4)
                                    .padding(.leading, 16)
                                    .padding(.bottom, 12)
                                    if viewModel.state.getReviewAllMainResponse.data![Int(index)].images!.count > 0 {
                                        HStack(spacing: 0) {
                                            KFImage(URL(string: viewModel.state.getReviewAllMainResponse.data![Int(index)].images![0].thumbnailUrl))
                                                .resizable()
                                                .frame(width: 70, height: 70)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .padding(.leading, 16)
                                                .padding(.bottom, 12)
                                        }
                                    }
                                    
                                    HStack(alignment: .bottom, spacing: 0) {
                                        //                                        Text("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].content)")
                                        //                                            .lineLimit(contentIsOn[index] ? nil : 2)
                                        //                                            .padding(.leading, 16)
                                        //                                        Button {
                                        //                                            withAnimation(nil) {
                                        //                                                contentIsOn[index].toggle()
                                        //                                            }
                                        //                                        } label: {
                                        //                                            Text(contentIsOn[index] ? "접기" : "더 보기")
                                        //                                                .font(.caption01)
                                        //                                                .foregroundStyle(Color.gray1)
                                        //                                        }
                                        
                                        ExpandableText("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].content)", lineLimit: 2)
                                            .font(.body02)
                                            .padding(.leading, 16)
                                            .padding(.trailing, 16)
                                        
                                        
                                        
                                    }
                                    HStack(spacing: 0) {
                                        Text("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].reviewTypeKeywords.map {"#\($0)"}.joined(separator: " "))")
                                            .font(.caption01)
                                            .foregroundStyle(Color.main)
                                    }
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .multilineTextAlignment(.leading)
                                    .padding(.bottom, 8)
                                    .padding(.top, 12)
                                    
                                    HStack(spacing: 0) {
                                        Spacer()
                                        Text("\(viewModel.state.getReviewAllMainResponse.data![Int(index)].createdAt)")
                                            .font(.caption01)
                                            .foregroundStyle(Color.gray1)
                                            .padding(.trailing, 16)
                                            .padding(.bottom, 16)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                                        .shadow(color: .gray.opacity(0.3), radius: 1, x: 0, y: 0)
                                    )
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .padding(.bottom, 16)
                            }
                        }
                        
                    }
                    Spacer()
                }
            }
       
        }
        .toolbar(.hidden)
        .onAppear {
            Task {
                await getUserAllReviewItem(memberId: memberId, page: page, size: size)
                if viewModel.state.getReviewAllMainResponse.totalElements >= 1{
                    for i in 0...Int(viewModel.state.getReviewAllMainResponse.totalElements - 1) {
                        contentIsOn.append(false)
                    }
                }
                isAPICalled = true
            }
        }
        
    }
    
    func getUserAllReviewItem(memberId: Int64, page: Int, size: Int) async {
        await viewModel.action(.getUserAllReviewItem(memberId: memberId, page: page, size: size))
    }
}



#Preview {
    ReviewAllMainView()
}
