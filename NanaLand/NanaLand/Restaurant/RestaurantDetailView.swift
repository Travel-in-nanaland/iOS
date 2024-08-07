//
//  RestaurantDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import SwiftUI
import Kingfisher

struct RestaurantDetailView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = RestaurantDetailViewModel()
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    @State private var contentIsOn = [false, false, false] // 댓글 더보기 버튼 클릭 여부(더 보기 클릭한 댓글만 라인 제한 풀기)
    @State private var isExpanded = false
    
    @State private var isAPICalled = false
    
    var layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        VStack{
            ZStack{
                NavigationDeepLinkBar(title: LocalizedKey.restaurant.localized(for: localizationManager.language))
                    .frame(height: 56)
            }
            
            ZStack{
                ScrollViewReader{ reader in
                    ScrollView{
                        VStack{
                            if isAPICalled {
                                VStack{
                                    KFImage(URL(string: viewModel.state.getRestaurantDetailResponse.images.first!.originUrl))
                                        .resizable()
                                        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                                        .padding(.bottom, 24)
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                            .frame(maxWidth: Constants.screenWidth - 40, maxHeight: .infinity) // 뷰의 크기를 지정합니다.
                                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                                        
                                        VStack(){
                                            HStack(spacing: 0) {
                                                
                                                Text(viewModel.state.getRestaurantDetailResponse.addressTag)
                                                    .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 30)
                                                            .foregroundStyle(Color.main10P)
                                                    )
                                                    .font(.gothicNeo(.regular, size: 12))
                                                    .padding(.leading, 40)
                                                    .padding(.trailing, 10)
                                                    .foregroundStyle(Color.main)
                                                
                                                LazyHGrid(rows: layout) {
                                                    ForEach(viewModel.state.getRestaurantDetailResponse.keywords!, id: \.self) { keyword in
                                                        Text(keyword)
                                                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 30)
                                                                    .foregroundStyle(Color.main10P)
                                                            )
                                                            .font(.gothicNeo(.regular, size: 12))
                                                            .foregroundStyle(Color.main)
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                            .padding(.bottom, 10)
                                            HStack(spacing: 0) {
                                                Text(viewModel.state.getRestaurantDetailResponse.title)
                                                    .font(.gothicNeo(.bold, size: 20))
                                                    .padding(.leading, 40)
                                                Spacer()
                                            }
                                            .padding(.bottom, 8)
                                            Text(viewModel.state.getRestaurantDetailResponse.content)
                                                .fixedSize(horizontal: false, vertical: true) // 세로 방향으로 확장 허용
                                                .lineLimit(isExpanded ? nil : 5)
                                                .padding(.leading, 35)
                                                .padding(.trailing, 30)
                                                .padding(.bottom, 20)
                                            
                                            if viewModel.state.getRestaurantDetailResponse.content.count > 90 {
                                                HStack{
                                                    Spacer()
                                                    Button(action: {
                                                        isExpanded.toggle()
                                                    }, label: {
                                                        Text(isExpanded ? "접기" : "더 보기")
                                                            .font(.caption01)
                                                            .foregroundColor(.gray1)
                                                    })
                                                }
                                                .padding(.trailing, 30)
                                                .padding(.bottom, 20)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.top, 16)
                                    }
                                    .padding(.bottom, 20)
                                    
                                    VStack{
                                        
                                        HStack{
                                            Text(.menu)
                                                .font(.title02_bold)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 0))
                                        
                                        ForEach(viewModel.state.getRestaurantDetailResponse.menus, id: \.menuName) { menuItem in
                                            RestaurantMenuView(title: menuItem.menuName, price: menuItem.price, imageUrl: menuItem.firstImage.originUrl)
                                                .environmentObject(LocalizationManager())
                                            Rectangle()
                                                .frame(width: Constants.screenWidth, height: 1)
                                                .foregroundColor(.gray3)
                                        }
                                        .padding(.leading, 5)
                                    }
                                    .padding(.bottom, 10)
                                    
                                    VStack(spacing: 24) {
                                        if viewModel.state.getRestaurantDetailResponse.address != "" {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailPin")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.address)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(viewModel.state.getRestaurantDetailResponse.address)
                                                        .font(.body02)
                                                    
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let contantData = viewModel.state.getRestaurantDetailResponse.contact{
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailPhone")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.phoneNumber)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(contantData)
                                                        .font(.body02)
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let timeData = viewModel.state.getRestaurantDetailResponse.time {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailClock")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.time)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(timeData)
                                                        .font(.body02)
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let serviceData = viewModel.state.getRestaurantDetailResponse.service {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icService")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.service)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(serviceData)
                                                        .font(.body02)
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let homepageData = viewModel.state.getRestaurantDetailResponse.homepage {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailHomepage")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.homepage)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(homepageData)
                                                        .font(.body02)
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let instaData = viewModel.state.getRestaurantDetailResponse.instagram {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icInsta")
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.instagram)
                                                        .font(.gothicNeo(.bold, size: 14))
                                                    Text(instaData)
                                                        .font(.body02)
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40, height: (Constants.screenWidth - 40) * (42 / 358))
                                            .padding(.bottom, 32)
                                        }
                                        
                                        Button {
                                            AppState.shared.navigationPath.append(ArticleDetailViewType.reportInfo(id: viewModel.state.getRestaurantDetailResponse.id, category: .restaurant))
                                        } label: {
                                            Text(.proposeUpdateInfo)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 50.0)
                                                        .foregroundStyle(Color.gray2)
                                                        .frame(width: 120, height: 40)
                                                )
                                                .foregroundStyle(Color.white)
                                                .font(.body02_bold)
                                                .padding(.bottom, 10)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Text("후기")
                                                    .font(.title01_bold)
                                                    .padding(.trailing, 2)
                                                Text("\(viewModel.state.getReviewDataResponse.totalElements)")
                                                    .font(.title02_bold)
                                                    .foregroundStyle(Color.main)
                                                Spacer()
                                                ForEach(1...5, id: \.self) { number in
                                                    Image(systemName: "star.fill")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 24)
                                                        .foregroundColor((Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating) < 0 || (Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating <= 0.5 && Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating >= 0) ? .yellow : .gray2)
                                                }
                                                Text("\(String(format: "%.1f" , viewModel.state.getReviewDataResponse.totalAvgRating))")
                                                    .font(.body02_bold)
                                            }
                                            .padding(.bottom, 24)
                                        }
                                        .padding(.leading, 16)
                                        .padding(.trailing, 16)
                                        
                                        if viewModel.state.getReviewDataResponse.totalElements >= 1 {
                                            ForEach(0...viewModel.state.getReviewDataResponse.totalElements - 1, id: \.self) { index in
                                                if index < 3 {
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
                                                                    AppState.shared.navigationPath.append(ReviewType.userProfile(id: Int64(viewModel.state.getReviewDataResponse.data[index].memberId!)))
                                                                } label: {
                                                                    Text(viewModel.state.getReviewDataResponse.data[index].nickname ?? "")
                                                                        .font(.body02_bold)
                                                                }
                                                                
                                                                HStack(spacing: 0) {
                                                                    Text("리뷰 \(viewModel.state.getReviewDataResponse.data[index].memberReviewCount ?? 0)")
                                                                        .font(.caption01)
                                                                    Text(" ㅣ ")
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
                                                                ForEach(0..<viewModel.state.getReviewDataResponse.data[index].images!.count) { idx in
                                                                    KFImage(URL(string: viewModel.state.getReviewDataResponse.data[index].images![idx].originUrl))
                                                                        .resizable()
                                                                        .frame(width: 70, height: 70)
                                                                        .cornerRadius(8)
                                                                        .padding(.leading, 10)
                                                                        .padding(.bottom, 5)
                                                                }
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        HStack(alignment: .bottom, spacing: 0) {
                                                            Text("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")")
                                                                .lineLimit(contentIsOn[index] ? nil : 2)
                                                                .padding(.leading, 16)
                                                                .padding(.trailing, 2)
                                                            
                                                            Button {
                                                                contentIsOn[index].toggle()
                                                            } label: {
                                                                Text(contentIsOn[index] ? "접기" : "더 보기")
                                                                    .foregroundStyle(Color.gray1)
                                                                    .font(.caption01)
                                                            }
                                                            .padding(.trailing, 16)
                                                        }
                                                        Spacer()
                                                        HStack(spacing: 0) {
                                                            Text("\(((viewModel.state.getReviewDataResponse.data[index].reviewTypeKeywords ?? [""]).map {"#\($0) "}).joined(separator: ", "))")
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
                                                                .padding(.trailing, 16)
                                                                .padding(.bottom, 16)
                                                            
                                                        }
                                                    }
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 12) // 모서리가 둥근 테두리
                                                            .stroke(Color.gray1, lineWidth: 1) // 테두리 색상과 두께
                                                    )
                                                    .padding(.leading, 16)
                                                    .padding(.trailing, 16)
                                                }
                                            }
                                        }
                                        Button {
                                            AppState.shared.navigationPath.append(ReviewType.allReview(id: id))
                                        } label: {
                                            Text("후기 더보기")
                                                .foregroundStyle(Color.white)
                                                .font(.body_bold)
                                        }
                                        .frame(width: Constants.screenWidth - 32, height: 48)
                                        .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.main))
                                        .padding(.bottom, 66)
                                        
                                    }
                                }
                            }
                        }
                        .id("Scroll_To_Top")
                        .onAppear {
                            Task {
                                await getRestaurantDetail(id: id, isSearch: false)
                                await getReviewData(id: id, category: "RESTAURANT", page: 0, size: 12)
                                isAPICalled = true
                            }
                        }
                    }
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // 10. withAnimation 과함께 함수 작성
                                    withAnimation(.default) {
                                        // ScrollViewReader의 proxyReader을 넣어줌
                                        reader.scrollTo("Scroll_To_Top", anchor: .top)
                                    }
                                    
                                }, label: {
                                    Image("icScrollToTop")
                                    
                                })
                                .frame(width: 80, height: 80)
                                .padding(.trailing)
                                .padding(.bottom, getSafeArea().bottom == 0 ? 76 : 60)
                            }
                        }
                    )
                    .navigationDestination(for: ArticleDetailViewType.self) { viewType in
                        switch viewType {
                        case let .reportInfo(id, category):
                            ReportInfoMainView(id: id, category: category)
                        }
                    }
                }
                VStack(spacing: 0) {
                    Spacer()
                    HStack(spacing: 0) {
                        Button {
                            Task {
                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getRestaurantDetailResponse.id), category: .restaurant))
                            }
                        } label: {
                            viewModel.state.getRestaurantDetailResponse.favorite ?
                            Image("icHeartFillMain")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(Color.main)
                                .padding(.leading, 16) : Image("icFavoriteHeart")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 36, height: 36)
                                .foregroundStyle(Color.main)
                                .padding(.leading, 16)
                        }
                        Spacer()
                        Button {
                            // Todo - 리뷰 작성
                            AppState.shared.navigationPath.append(ReviewType.review)
                        } label: {
                            Text("리뷰 작성하기")
                                .padding(.leading, (Constants.screenWidth) * (96 / 360))
                                .padding(.trailing, (Constants.screenWidth) * (96 / 360))
                                .font(.body_bold)
                                .foregroundStyle(Color.white)
                                .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.main).frame(width: Constants.screenWidth * (28 / 36), height: 40))
                            
                            
                        }
                        .frame(width: Constants.screenWidth * (28 / 36), height: 40)
                        .padding(.trailing, 16)
                        
                        
                    }
                    .frame(width: Constants.screenWidth, height: 56)
                    .background(Color.white)
                    .shadow(color: Color.gray.opacity(0.7), radius: 10, x: 0, y: 10)
                }
            }
            .navigationDestination(for: ReviewType.self) { viewType in
                switch viewType {
                case let .review:
                    ReviewWriteMain(reviewAddress: viewModel.state.getRestaurantDetailResponse.address ?? "", reviewImageUrl: viewModel.state.getRestaurantDetailResponse.images[0].originUrl ?? "", reviewTitle: viewModel.state.getRestaurantDetailResponse.title ?? "", reviewId: viewModel.state.getRestaurantDetailResponse.id ?? 0, reviewCategory: "RESTAURANT")
                case let .allReview(id):
                    ReviewAllDetailMainView(id: id, reviewCategory: "RESTAURANT")
                case let .userProfile(id):
                    UserProfileMainView(memberId: id)
                    
                }
            }
            .toolbar(.hidden)
        }
    }
    
    func getRestaurantDetail(id: Int64, isSearch: Bool) async {
        await viewModel.action(.getRestaurantDetailItem(id: id, isSearch: isSearch))
        
    }
    
    func getReviewData(id: Int64, category: String, page: Int, size: Int) async {
        await viewModel.action(.getReviewData(id: id, category: category, page: page, size: size))
    }
    
    func toggleFavorite(body: FavoriteToggleRequest) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body))
    }
    
    func getSafeArea() ->UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

enum ReviewType: Hashable {
    case review
    case allReview(id: Int64)
    case userProfile(id: Int64)
}

#Preview {
    RestaurantDetailView(id: 1)
        .environmentObject(LocalizationManager())
}


