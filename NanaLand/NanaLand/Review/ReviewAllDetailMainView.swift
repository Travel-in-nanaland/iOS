//
//  ReviewAllDetailMainView.swift
//  NanaLand
//
//  Created by juni on 8/5/24.
//

import SwiftUI
import Kingfisher
import CustomAlert

// (디테일페이지 -> 후기 더보기 눌렀을 때 나오는 모든 후기 뷰)
struct ReviewAllDetailMainView: View {
    @StateObject var viewModel = ReviewAllDetailMainViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var isAPICalled = false
    @State private var contentIsOn: [Bool] = []
    @State private var reportModal = false
    @State var reportReasonViewFlag = false
    @State var showAlert: Bool = false//삭제하기 alert 여부
    var id: Int64
    @State private var idx: Int64 = 0
    var reviewCategory: String = ""
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .review, showBackButton: true)
                .padding(.bottom, 26)
            ScrollView {
                if isAPICalled {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Text(.review)
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
                                if viewModel.state.getReviewDataResponse.data[index].myReview {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(spacing: 0) {
                                            KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].profileImage?.originUrl ?? ""))
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
                                                    Text(.review)
                                                        .font(.caption01) +
                                                    Text(" \(viewModel.state.getReviewDataResponse.data[index].memberReviewCount ?? 0)")
                                                        .font(.caption01)
                                                    Text(" | ")
                                                        .font(.caption01)
                                                    Image("icStarFill")
                                                        .resizable()
                                                        .frame(width: 11, height: 11)
                                                    Text("\(String(format: "%.1f", viewModel.state.getReviewDataResponse.data[index].rating ?? 0))")
                                                        .font(.caption01)
                                                }
                                                
                                            }
                                            Spacer()
                                            
                                            HStack(spacing: 0){
                                                Button(action: {
                                                    AppState.shared.navigationPath.append(ExperienceViewType.detailReivew(id: viewModel.state.getReviewDataResponse.data[index].id, category: reviewCategory))
                                                }, label: {
                                                    Text(.modify)
                                                        .font(.caption01)
                                                        .foregroundColor(.gray1)
                                                        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 30)
                                                                .foregroundColor(.gray3)
                                                        }
                                                })
                                                
                                                Button(action: {
                                                    showAlert = true
                                                }, label: {
                                                    Text(.delete)
                                                        .font(.caption01)
                                                        .foregroundColor(.gray1)
                                                        .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                                        .background {
                                                            RoundedRectangle(cornerRadius: 30)
                                                                .foregroundColor(.gray3)
                                                        }
                                                })
                                                .customAlert(LocalizedKey.reviewDeleteMessage.localized(for: localizationManager.language), isPresented: $showAlert) {
                                                    
                                                } actions: {
                                                    MultiButton{
                                                        Button {
                                                            showAlert = false
                                                            Task {
                                                                await deleteMyReview(id: viewModel.state.getReviewDataResponse.data[index].id)
                                                                await getReviewData(id: id, category: reviewCategory, page: 0, size: 12)
                                                            }
                                                        } label: {
                                                            Text(.yes)
                                                                .font(.title02_bold)
                                                                .foregroundStyle(Color.black)
                                                        }
                                                        
                                                        Button {
                                                            showAlert = false
                                                        } label: {
                                                            Text(.no)
                                                                .font(.title02_bold)
                                                                .foregroundStyle(Color.main)
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                            .padding(.trailing, 10)
                                        }
                                        .padding(.top, 15)
                                        .padding(.bottom, 12)
                                        HStack(spacing: 0) {
                                            if viewModel.state.getReviewDataResponse.data[index].images!.count != 0 {
                                                
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 16) {
                                                        ForEach(0..<viewModel.state.getReviewDataResponse.data[index].images!.count, id: \.self) { idx in
                                                            KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].images![idx].originUrl))
                                                                .resizable()
                                                                .frame(width: 70, height: 70)
                                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                        }
                                                    }
                                                }
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                            }
                                            
                                        }
                                        
                                        HStack(alignment: .bottom, spacing: 0) {
                                            //                                                        Text("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")")
                                            //                                                            .lineLimit(contentIsOn[index] ? nil : 2)
                                            //                                                            .padding(.leading, 16)
                                            //                                                            .padding(.trailing, 2)
                                            //
                                            //                                                        Button {
                                            //                                                            contentIsOn[index].toggle()
                                            //                                                        } label: {
                                            //                                                            Text(contentIsOn[index] ? "접기" : "더 보기")
                                            //                                                                .foregroundStyle(Color.gray1)
                                            //                                                                .font(.caption01)
                                            //                                                        }
                                            //                                                        .padding(.trailing, 16)
                                            ExpandableText("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")", lineLimit: 2)
                                                .font(.body02)
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                        }
                                        
                                        
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Text("\(((viewModel.state.getReviewDataResponse.data[index].reviewTypeKeywords ?? [""]).map {"#\($0) "}).joined(separator: " "))")
                                                .font(.caption01)
                                                .foregroundStyle(Color.main)
                                            
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom, 4)
                                        HStack(spacing: 0) {
                                            Spacer()
                                            Text("\(viewModel.state.getReviewDataResponse.data[index].createdAt ?? "")")
                                                .font(.caption01)
                                                .foregroundStyle(Color.gray1)
                                        }
                                        .padding(.trailing, 16)
                                        .padding(.bottom, 16)
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12) // 모서리가 둥근 테두리
                                            .stroke(Color.gray.opacity(0.1), lineWidth: 1) // 테두리 색상과 두께
                                            .shadow(color: .gray.opacity(0.3), radius: 1, x: 0, y: 0)
                                    )
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 15)
                                } else {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(spacing: 0) {
                                            KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].profileImage?.originUrl ?? ""))
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
                                                    Text(.review)
                                                        .font(.caption01) +
                                                    Text(" \(viewModel.state.getReviewDataResponse.data[index].memberReviewCount ?? 0)")
                                                        .font(.caption01)
                                                    Text(" | ")
                                                        .font(.caption01)
                                                    Image("icStarFill")
                                                        .resizable()
                                                        .frame(width: 11, height: 11)
                                                    Text("\(String(format: "%.1f", viewModel.state.getReviewDataResponse.data[index].rating ?? 0))")
                                                        .font(.caption01)
                                                }
                                                
                                            }
                                            Spacer()
                                            
                                            RoundedRectangle(cornerRadius: 30)
                                                .stroke(lineWidth: 1)
                                                .frame(width: 48, height: 28)
                                                .foregroundColor(viewModel.state.getReviewDataResponse.data[index].reviewHeart == true ? .main : .gray2)
                                                .overlay(){
                                                    HStack(spacing: 0){
                                                        
                                                        Button {
                                                            Task{
                                                                await reviewFavorite(id: viewModel.state.getReviewDataResponse.data[index].id)
                                                            }
                                                        } label: {
                                                            Image(viewModel.state.getReviewDataResponse.data[index].reviewHeart == true ? "icReviewHeartMain" : "icReviewHeart")
                                                        }

                                                        
                                                        Text("\(viewModel.state.getReviewDataResponse.data[index].heartCount)")
                                                            .font(.caption01)
                                                            .foregroundColor(.black)
                                                            .padding(.bottom, 2)
                                                    }
                                                }
                                                .padding()
                                        }
                                        .padding(.top, 10)
                                        .padding(.bottom, 12)
                                        HStack(spacing: 0) {
                                            if viewModel.state.getReviewDataResponse.data[index].images!.count != 0 {
                                                
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 16) {
                                                        ForEach(0..<viewModel.state.getReviewDataResponse.data[index].images!.count, id: \.self) { idx in
                                                            KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].images![idx].originUrl))
                                                                .resizable()
                                                                .frame(width: 70, height: 70)
                                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                        }
                                                    }
                                                }
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                            }
                                            
                                        }
                                        
                                        HStack(alignment: .bottom, spacing: 0) {
                                            //                                                        Text("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")")
                                            //                                                            .lineLimit(contentIsOn[index] ? nil : 2)
                                            //                                                            .padding(.leading, 16)
                                            //                                                            .padding(.trailing, 2)
                                            //
                                            //                                                        Button {
                                            //                                                            contentIsOn[index].toggle()
                                            //                                                        } label: {
                                            //                                                            Text(contentIsOn[index] ? "접기" : "더 보기")
                                            //                                                                .foregroundStyle(Color.gray1)
                                            //                                                                .font(.caption01)
                                            //                                                        }
                                            //                                                        .padding(.trailing, 16)
                                            ExpandableText("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")", lineLimit: 2)
                                                .font(.body02)
                                                .padding(.leading, 16)
                                                .padding(.trailing, 16)
                                        }
                                        
                                        
                                        Spacer()
                                        HStack(spacing: 0) {
                                            Text("\(((viewModel.state.getReviewDataResponse.data[index].reviewTypeKeywords ?? [""]).map {"#\($0) "}).joined(separator: " "))")
                                                .font(.caption01)
                                                .foregroundStyle(Color.main)
                                            
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        .multilineTextAlignment(.leading)
                                        .padding(.bottom, 4)
                                        HStack(spacing: 0) {
                                            Spacer()
                                            Text("\(viewModel.state.getReviewDataResponse.data[index].createdAt ?? "")")
                                                .font(.caption01)
                                                .foregroundStyle(Color.gray1)
                                           
                                            Button {
                                                reportModal = true
                                                idx = viewModel.state.getReviewDataResponse.data[index].id
                                     
                                            } label: {
                                                Image("icPointBtn")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .frame(width: 20, height: 20)
                                                    .foregroundStyle(Color.gray1)
                                            }
                                        }
                                        .padding(.trailing, 16)
                                        .padding(.bottom, 16)
                                    }
                                    .sheet(isPresented: $reportModal, onDismiss: {
                                        if reportReasonViewFlag {
                                            AppState.shared.navigationPath.append(AllReviewViewType.report(id: idx))
                                        }
                                    }) {
                                        ReportModalView(reportReasonViewFlag: $reportReasonViewFlag)
                                            .presentationDetents([.height(Constants.screenWidth * (103 / Constants.screenWidth))])
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12) // 모서리가 둥근 테두리
                                            .stroke(Color.gray.opacity(0.1), lineWidth: 1) // 테두리 색상과 두께
                                            .shadow(color: .gray.opacity(0.3), radius: 1, x: 0, y: 0)
                                    )
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .padding(.bottom, 15)
                                }
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
                await getReviewData(id: id, category: reviewCategory, page: 0, size: 100)
                if viewModel.state.getReviewDataResponse.totalElements >= 1 {
                    for i in 0...Int(viewModel.state.getReviewDataResponse.totalElements - 1) {
                        contentIsOn.append(false)
                    }
                }
                isAPICalled = true
            }
        }
        .navigationDestination(for: AllReviewViewType.self) { view in
            switch view {
            case let .userProfile(id):
                UserProfileMainView(memberId: id)
            case let .report(id):
                ReportReasonView(id: id)
            case let .detailReivew(id, category):
                MyReviewDetailView(reviewId: id, reviewCategory: category)
                    .environmentObject(LocalizationManager())
            }
        }
    }
    
    func getReviewData(id: Int64, category: String, page: Int, size: Int) async {
        await viewModel.action(.getReviewData(id: id, category: category, page: page, size: size))
    }
    
    func reviewFavorite(id: Int64) async {
        await viewModel.action(.reviewFavorite(id: id))
    }
    
    func deleteMyReview(id: Int64) async {
        await viewModel.action(.deleteMyReview(id: id))
    }
}

enum AllReviewViewType: Hashable {
    case userProfile(id: Int64)
    case report(id: Int64) // 신고하기
    case detailReivew(id: Int64, category: String)
}

//#Preview {
//    ReviewAllDetailMainView()
//}
