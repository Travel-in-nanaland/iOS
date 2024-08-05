//
//  ReviewAllDetailMainView.swift
//  NanaLand
//
//  Created by juni on 8/5/24.
//

import SwiftUI
import Kingfisher
// (디테일페이지 -> 후기 더보기 눌렀을 때 나오는 모든 후기 뷰)
struct ReviewAllDetailMainView: View {
    @StateObject var viewModel = ReviewAllDetailMainViewModel()
    @State private var isAPICalled = false
    @State private var contentIsOn: [Bool] = []
    var id: Int64
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .review, showBackButton: true)
                .padding(.bottom, 26)
            ScrollView {
                if isAPICalled {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text("후기")
                                .font(.title01_bold)
                                .padding(.trailing, 2)
                            Text("\(viewModel.state.getReviewDataResponse.totalElements)")
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 24)
                        HStack(spacing: 0) {
                            ForEach(1...5, id: \.self) { number in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24)
                                    .foregroundColor(.yellow)
                            }
                            Spacer()
                        }
                        .padding(.leading, 16)
                        .padding(.bottom, 24)
                        // 리뷰가 최소 1개 이상 있다면
                        if viewModel.state.getReviewDataResponse.totalElements >= 1 {
                            ForEach((0...viewModel.state.getReviewDataResponse.data.count - 1), id: \.self) { index in
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].profileImage?.thumbnailUrl ?? ""))
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 42, height: 42)
                                            .clipShape(Circle())
                                            .padding(.leading, 16)
                                            .padding(.trailing, 8)
                                        VStack(alignment: .leading, spacing: 0) {
                                            Button {
                                                AppState.shared.navigationPath.append(ExperienceViewType.userProfile(id: Int64(viewModel.state.getReviewDataResponse.data[index].memberId!)))
                                            } label: {
                                                Text(viewModel.state.getReviewDataResponse.data[index].nickname ?? "")
                                                    .font(.body02_bold)
                                            }
                                            
                                            HStack(spacing: 0) {
                                                Text("리뷰 \(viewModel.state.getReviewDataResponse.data[index].memberReviewCount ?? 0)")
                                                    .font(.caption01)
                                                Image("icRatingStar")
                                                Text("\(String(format: "%.1f", viewModel.state.getReviewDataResponse.data[index].rating ?? 0))")
                                                    .font(.caption01)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                    .padding(.bottom, 12)
                                    HStack(spacing: 0) {
                                        if viewModel.state.getReviewDataResponse.data[index].images!.count != 0 {
                                            ScrollView(.horizontal, showsIndicators: false) {
                                                HStack(spacing: 16) {
                                                    ForEach(0..<viewModel.state.getReviewDataResponse.data[index].images!.count, id: \.self) { idx in
                                                        KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].images![idx].thumbnailUrl))
                                                            .resizable()
                                                            .frame(width: 70, height: 70)
                                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    }
                                                }
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 16)
                                            .padding(.bottom, 12)
                                        }
                                    }
                                    HStack(alignment: .bottom, spacing: 0) {
                                        Text("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")")
                                            .lineLimit(contentIsOn[index] ? nil : 2)
                                            .padding(.leading, 16)
                                        Button {
                                            withAnimation(nil) {
                                                contentIsOn[index].toggle()
                                            }
                                        } label: {
                                            Text(contentIsOn[index] ? "접기" : "더 보기")
                                                .font(.caption01)
                                                .foregroundStyle(Color.gray1)
                                                .padding(.leading, 2)
                                        }
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Text("\((viewModel.state.getReviewDataResponse.data[index].reviewTypeKeywords ?? [""]).map {"#\($0)"}.joined(separator: ","))")
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
                                        Text("\(viewModel.state.getReviewDataResponse.data[index].createdAt ?? "")")
                                            .font(.caption01)
                                            .foregroundStyle(Color.gray1)
                                            .padding(.trailing, 16)
                                            .padding(.bottom, 16)
                                    }
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray1, lineWidth: 1)
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
                await getReviewData(id: id, category: "EXPERIENCE", page: 0, size: 100)
                for i in 0...Int(viewModel.state.getReviewDataResponse.totalElements - 1) {
                    contentIsOn.append(false)
                }
                isAPICalled = true
            }
        }
    }
    
    func getReviewData(id: Int64, category: String, page: Int, size: Int) async {
        await viewModel.action(.getReviewData(id: id, category: category, page: page, size: size))
    }
}

//#Preview {
//    ReviewAllDetailMainView()
//}
