//
//  SearchReviewView.swift
//  NanaLand
//
//  Created by wodnd on 9/10/24.
//

import SwiftUI
import Kingfisher
import Combine

struct SearchReviewView: View {
    @StateObject var viewModel = ProfileReviewWriteViewModel()
    @State var placeSearch: String = ""
    @State var debouncedText: String = ""
    @State var skeletonFlag: Bool = false
    @State var itemIndex: Int = 0
    private var cancellable: AnyCancellable?
    
    var body: some View {
        VStack(spacing: 0) {
            SearchNavigationBar(title: .write, showBackButton: true)
                .padding(.bottom, 24)
            ZStack {
               
                TextField("장소를 검색하세요", text: $viewModel.searchText)
                    .padding()
                    .padding(.leading, 25)
                    .background(.white)
                    .cornerRadius(16)
                    .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 2) // 그림자 추가
                    .padding()
                    .onChange(of: viewModel.debouncedText) { newValue in
                        Task {
                            skeletonFlag = true
                                await getProfileReview(keyword: "\(newValue)")
                                skeletonFlag = false
                            }
                    }
                HStack(spacing: 0) {
                    Image("icSearch")
                        .padding(.leading, 24)
                    Spacer()
                }
            }
            
            if viewModel.state.getProfileReviewResponse.count >= 1 {
                if skeletonFlag {
                    ScrollView {
                        ForEach(0...viewModel.state.getProfileReviewResponse.count - 1, id: \.self) { idx in
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 0) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)))
                                        .frame(width: 56, height: 56)
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                    VStack(alignment: .leading, spacing: 8) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)))
                                            .frame(width: 44, height: 12)
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)))
                                            .frame(width: 80, height: 12)
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)))
                                            .frame(width: 156, height: 12)
                                    }
                                    Spacer()
                                }
                   
                            }
                            .frame(width: Constants.screenWidth, height: 80)
                     
                        }
                    }
                } else {
                    ScrollView {
                        ForEach(0...viewModel.state.getProfileReviewResponse.count - 1, id: \.self) { idx in
                            Button {
                                itemIndex = idx
                                AppState.shared.navigationPath.append(SearchReviewWriteViewType.review)
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        KFImage(URL(string: viewModel.state.getProfileReviewResponse[idx].firstImage?.thumbnailUrl ?? ""))
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                            .frame(width: 56, height: 56)
                                            .padding(.trailing, 16)
                                            .padding(.leading, 16)
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("\(viewModel.state.getProfileReviewResponse[idx].categoryValue!)")
                                                .padding(.leading, 12)
                                                .padding(.trailing, 12)
                                                .padding(.top, 1)
                                                .padding(.bottom, 1)
                                                .foregroundStyle(.main)
                                                .font(.caption02)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(Color.main10P)
                                                )
                                            Text("\(viewModel.state.getProfileReviewResponse[idx].title!)")
                                                .font(.body02_semibold)
                                            Text("\(viewModel.state.getProfileReviewResponse[idx].address!)")
                                                .font(.caption01)
                                           
                                        }
                                        Spacer()
                                    }
                                    .frame(width: Constants.screenWidth)
                                }
                                .frame(width: Constants.screenWidth, height: 80)
                            }

                      
                            
                        }
                    }
                }
            } else {
                Spacer()
                Text("해당 검색 결과가 없습니다.")
                    .font(.body01)
                    .foregroundStyle(.gray1)
                Spacer()
            }
            Spacer()
        }
        .toolbar(.hidden)
        .navigationDestination(for: SearchReviewWriteViewType.self) { viewType in
            switch viewType {
            case .review:
                ReviewWriteMain(reviewAddress: viewModel.state.getProfileReviewResponse[itemIndex].address ?? "", reviewImageUrl: viewModel.state.getProfileReviewResponse[itemIndex].firstImage?.originUrl ?? "", reviewTitle: viewModel.state.getProfileReviewResponse[itemIndex].title ?? "", reviewId: viewModel.state.getProfileReviewResponse[itemIndex].id ?? 0 , reviewCategory: viewModel.state.getProfileReviewResponse[itemIndex].category ?? "")
            }
        }
    }
    
    func getProfileReview(keyword: String) async {
        await viewModel.action(.getProfileReview(keyword: keyword))
    }
    
}

struct SearchNavigationBar: View {
    @Environment(\.dismiss) var dismiss
    
    let title: LocalizedKey
    let showBackButton: Bool
    
    init(title: LocalizedKey, showBackButton: Bool = false) {
        self.title = title
        self.showBackButton = showBackButton
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.clear)
                .frame(height:20)
                .background(
                    Color.white
                        .shadow(color: Color.baseBlack.opacity(0.05), radius: 8, y: 5)
                )
            
            
            HStack {
                Spacer()
                Text(title)
                    .font(.gothicNeo(.bold, size: 20))
                    .multilineTextAlignment(.center)
                Spacer(minLength: 0)
            }
            .frame(height: 56)
            .background(Color.white)
        }
        .frame(height: 56)
        .overlay(alignment: .leading) {
            if showBackButton {
                Button(action: {
                    AppState.shared.navigationPath.removeLast()
                    AppState.shared.navigationPath.removeLast()
                    AppState.shared.navigationPath.removeLast()
                    AppState.shared.navigationPath.removeLast()
                    AppState.shared.navigationPath.removeLast()
                    AppState.shared.currentTab = .profile
                }, label: {
                    Image("icLeft")
                        .resizable()
                        .frame(width: 32, height: 32)
                })
                .padding(.horizontal, 16)
                .tint(.baseBlack)
            }
        }
    }
}

enum SearchReviewWriteViewType: Hashable {
    case review
}

//#Preview {
//    SearchReviewView(placeSearch: "검색어를 입력하세요")
//}
