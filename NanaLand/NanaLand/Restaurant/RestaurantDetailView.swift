//
//  RestaurantDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import SwiftUI
import CustomAlert
import Kingfisher

struct RestaurantDetailView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = RestaurantDetailViewModel()
    @State private var roundedHeight: CGFloat = (Constants.screenWidth - 40) * (224.0 / 358.0)
    var id: Int64
    @State private var isOn = false // 더보기 버튼 클릭 여부
    @State private var isContentExpandable = false // content가 4줄 이상인지 여부
    @State private var contentIsOn = [false, false, false] // 댓글 더보기 버튼 클릭 여부(더 보기 클릭한 댓글만 라인 제한 풀기)
    @State private var isExpanded = false
    @State private var isAPICalled = false
    @State var showAlert: Bool = false//삭제하기 alert 여부
    @State private var reportModal = false
    @State private var reportReasonViewFlag = false // 신고하기로 네비게이션 하기 위한 플래그(신고 모달이 sheet형태라 navigation stack에 포함 안됨)
    @State private var idx: Int64 = 0
    @State private var isReport = false
    @State private var selectedIndex: Int? = nil // 리뷰 삭제 시 index 참조하기 위해서
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
                                    KFImage(URL(string:
                                                    viewModel.state.getRestaurantDetailResponse.images![0].originUrl!))
                                        .resizable()
                                        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (26 / 39))
                                        .padding(.bottom, Constants.screenWidth * (24 / 360))
                                    
                                    ZStack{
                                        if !isOn { // 더보기 버튼이 안 눌렸을 때
                                            VStack(spacing: 0) {
                                                HStack(spacing: Constants.screenWidth * (12 / 360)) {
                                                    Text(viewModel.state.getRestaurantDetailResponse.addressTag ?? "")
                                                        .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                            .foregroundStyle(Color.main10P)
                                                            .frame(height: Constants.screenWidth * (20 / 360))
                                                        )
                                                        .frame(height: Constants.screenWidth * (20 / 360))
                                                        .font(.gothicNeo(.regular, size: 12))
                                                        .foregroundStyle(Color.main)
                                                    
                                                    ForEach(0...viewModel.state.getRestaurantDetailResponse.keywords!.count - 1, id: \.self) { index in
                                                        Text(viewModel.state.getRestaurantDetailResponse.keywords![index])
                                                            .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                                            .background(RoundedRectangle(cornerRadius: 30)
                                                                .foregroundStyle(Color.main10P)
                                                                .frame(height: Constants.screenWidth * (20 / 360))
                                                            )
                                                            .frame(height: Constants.screenWidth * (20 / 360))
                                                            .font(.gothicNeo(.regular, size: 12))
                                                            .foregroundStyle(Color.main)
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                                .padding(.bottom, Constants.screenWidth * (12 / 360))
                                                
                                                HStack(spacing: 0) {
                                                    Text(viewModel.state.getRestaurantDetailResponse.title)
                                                        .font(.title02_bold)
                                                        .frame(height: Constants.screenWidth * (28 / 360))
                                                    Spacer()
                                                }
                                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                                .padding(.bottom, 8)
                                                
                                                HStack(spacing: 0){
                                                    Text(viewModel.state.getRestaurantDetailResponse.content ?? "")
                                                        .font(.body02)
                                                        .lineLimit(4)
                                                        .lineSpacing(10)
                                                        .background(GeometryReader { geometry in
                                                            Color.clear.onAppear {
                                                                let textHeight = estimateTextHeight(
                                                                    text: viewModel.state.getRestaurantDetailResponse.content ?? "",
                                                                    font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize),
                                                                    width: geometry.size.width
                                                                )
                                                                DispatchQueue.main.async {
                                                                    isContentExpandable = textHeight > (4 * UIFont.preferredFont(forTextStyle: .body).lineHeight)
                                                                }
                                                            }
                                                        })
                                                    
                                                    Spacer()
                                                }
                                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                                .padding(.trailing, Constants.screenWidth * (16 / 360))
                                                
                                                Spacer()
                                                
                                                HStack {
                                                    Spacer()
                                                    VStack {
                                                        if isContentExpandable {
                                                            Button {
                                                                isOn.toggle()
                                                            } label: {
                                                                Text(.unfoldView)
                                                                    .foregroundStyle(Color.gray1)
                                                                    .font(.gothicNeo(.regular, size: 12))
                                                            }
                                                        }
                                                        
                                                    }
                                                    .padding(.trailing, Constants.screenWidth * (16 / 360))
                                                    .padding(.top, Constants.screenWidth * (16 / 360))
                                                    .padding(.bottom, Constants.screenWidth * (16 / 360))
                                                }
                                            }
                                            .padding(.leading, Constants.screenWidth * (16 / 360))
                                            .padding(.trailing, Constants.screenWidth * (16 / 360))
                                            .padding(.top, Constants.screenWidth * (16 / 360))
                                            .background(){
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white)
                                                    .frame(width: Constants.screenWidth * (328/360))
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                            }
                                        }
                                        
                                        if isOn { // 더 보기 눌렀을 때
                                            VStack(spacing: 0) {
                                                HStack(spacing: Constants.screenWidth * (12 / 360)) {
                                                    Text(viewModel.state.getRestaurantDetailResponse.addressTag ?? "")
                                                        .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                                        .background(RoundedRectangle(cornerRadius: 30)
                                                            .foregroundStyle(Color.main10P)
                                                            .frame(height: Constants.screenWidth * (20 / 360))
                                                        )
                                                        .frame(height: Constants.screenWidth * (20 / 360))
                                                        .font(.gothicNeo(.regular, size: 12))
                                                        .foregroundStyle(Color.main)
                                                    
                                                    ForEach(0...viewModel.state.getRestaurantDetailResponse.keywords!.count - 1, id: \.self) { index in
                                                        Text(viewModel.state.getRestaurantDetailResponse.keywords![index])
                                                            .padding(EdgeInsets(top: 0, leading: Constants.screenWidth * (12 / 360), bottom: 0, trailing: Constants.screenWidth * (12 / 360)))
                                                            .background(RoundedRectangle(cornerRadius: 30)
                                                                .foregroundStyle(Color.main10P)
                                                                .frame(height: Constants.screenWidth * (20 / 360))
                                                            )
                                                            .frame(height: Constants.screenWidth * (20 / 360))
                                                            .font(.gothicNeo(.regular, size: 12))
                                                            .foregroundStyle(Color.main)
                                                    }
                                                    Spacer()
                                                }
                                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                                .padding(.bottom, Constants.screenWidth * (12 / 360))
                                                
                                                HStack(spacing: 0) {
                                                    Text(viewModel.state.getRestaurantDetailResponse.title)
                                                        .font(.title02_bold)
                                                        .frame(height: Constants.screenWidth * (28 / 360))
                                                    Spacer()
                                                }
                                                .padding(.leading, Constants.screenWidth * (16 / 360))
                                                
                                                .padding(.bottom, 8)
                                                
                                                Text(viewModel.state.getRestaurantDetailResponse.content ?? "")
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .font(.body02)
                                                    .lineSpacing(10)
                                                    .padding(.leading, Constants.screenWidth * (16 / 360))
                                                    .padding(.trailing, Constants.screenWidth * (16 / 360))
                                                
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    VStack {
                                                        Button {
                                                            isOn.toggle()
                                                        } label: {
                                                            Text(.foldView)
                                                                .foregroundStyle(Color.gray1)
                                                                .font(.gothicNeo(.regular, size: 14))
                                                        }
                                                        
                                                    }
                                                    .padding(.trailing, Constants.screenWidth * (16 / 360))
                                                    .padding(.top, Constants.screenWidth * (16 / 360))
                                                    .padding(.bottom, Constants.screenWidth * (16 / 360))
                                                }
                                            }
                                            .padding(.leading, Constants.screenWidth * (16 / 360))
                                            .padding(.trailing, Constants.screenWidth * (16 / 360))
                                            .padding(.top, Constants.screenWidth * (16 / 360))
                                            .background(){
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.white) // 빈 뷰를 하얀색으로 채웁니다.
                                                    .frame(width: Constants.screenWidth * (328 / 360)) // 뷰의 크기를 지정합니다.
                                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                                            }
                                        }
                                    }
                                   
                                    VStack{
                                        
                                        HStack{
                                            Text(.menu)
                                                .font(.body_bold)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                        .padding(EdgeInsets(top: 20, leading: 25, bottom: 0, trailing: 0))
                                        
                                        ForEach(viewModel.state.getRestaurantDetailResponse.menus, id: \.menuName) { menuItem in
                                            RestaurantMenuView(title: menuItem.menuName, price: menuItem.price, imageUrl: menuItem.firstImage.originUrl ?? "noImage")
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
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.address)
                                                        .font(.body02_bold)
                                                    Text(viewModel.state.getRestaurantDetailResponse.address)
                                                        .font(.body02)
                                                    
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let contantData = viewModel.state.getRestaurantDetailResponse.contact, contantData != "" {
                                            HStack(spacing: 10) {
                                                let sanitizedNumber = viewModel.state.getRestaurantDetailResponse.contact!.replacingOccurrences(of: "-", with: "")
                                                VStack(spacing: 0) {
                                                    Image("icDetailPhone")
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.phoneNumber)
                                                        .font(.body02_bold)
                                                    Link(destination: URL(string: "tel://\(sanitizedNumber)")!, label: {
                                                        HStack(spacing: 0) {
                                                            Text(viewModel.state.getRestaurantDetailResponse.contact!)
                                                                .font(.gothicNeo(.regular, size: 12))
                                                                .padding(.trailing, 2)
                                                            Text(">")
                                                                .font(.gothicNeo(.regular, size: 12))
                                                        }
                                           
                                                    })
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let timeData = viewModel.state.getRestaurantDetailResponse.time, timeData != "" {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailClock")
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.time)
                                                        .font(.body02_bold)
                                                    Text(timeData)
                                                        .font(.body02)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let serviceData = viewModel.state.getRestaurantDetailResponse.service, serviceData != "" {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailService")
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.service)
                                                        .font(.body02_bold)
                                                    Text(serviceData)
                                                        .font(.body02)
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let homepageData = viewModel.state.getRestaurantDetailResponse.homepage, homepageData != "" {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icDetailHomepage")
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.homepage)
                                                        .font(.body02_bold)
                                                    Link(destination: URL(string: "\(homepageData)")!, label: {
                                                        Text("\(homepageData)")
                                                            .underline()
                                                            .font(.body02)
                                                    })
                                                    Spacer()
                                                }
                                                Spacer()
                                            }
                                            .frame(width: Constants.screenWidth - 40)
                                        }
                                        
                                        if let instaData = viewModel.state.getRestaurantDetailResponse.instagram, instaData != "" {
                                            HStack(spacing: 10) {
                                                VStack(spacing: 0) {
                                                    Image("icInsta")
                                                        .padding(.bottom, 5)
                                                    Spacer()
                                                }
                                                
                                                VStack(alignment: .leading, spacing: 0) {
                                                    Text(.instagram)
                                                        .font(.body02_bold)
                                                    Link(destination: URL(string: "\(instaData)")!, label: {
                                                        Text(instaData)
                                                            .underline()
                                                            .font(.body02)
                                                    })
                                                    Spacer()
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
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 50.0)
                                                        .foregroundStyle(Color.gray2)
                                                        .frame(height: 40)
                                                )
                                                .foregroundStyle(Color.gray1)
                                                .font(.body02_bold)
                                                .padding(.bottom, 10)
                                        }
                                        
                                        VStack(spacing: 0) {
                                            HStack(spacing: 0) {
                                                Text(.review)
                                                    .font(.title02_bold)
                                                    .padding(.trailing, 2)
                                                Text("\(viewModel.state.getReviewDataResponse.totalElements)")
                                                    .font(.body01)
                                                    .foregroundStyle(Color.main)
                                                Spacer()
                                                ForEach(1...5, id: \.self) { number in
                                                    Image((Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating) < 0 || (Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating <= 0.5 && Double(number) - viewModel.state.getReviewDataResponse.totalAvgRating >= 0) ? "icStarFill" : "icStar")
                                                        .resizable()
                                                        .frame(width: 17, height: 17)
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
                                                                        AppState.shared.navigationPath.append(ReviewType.userProfile(id: Int64(viewModel.state.getReviewDataResponse.data[index].memberId!)))
                                                                    } label: {
                                                                        Text(viewModel.state.getReviewDataResponse.data[index].nickname ?? "")
                                                                            .font(.body02_bold)
                                                                    }
                                                                    
                                                                    HStack(spacing: 0) {
                                                                        Text(.review)
                                                                            .font(.caption01)
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
                                                                
                                                                HStack(spacing: 8){
                                                                    Button(action: {
                                                                        AppState.shared.navigationPath.append(ReviewType.detailReivew(id: viewModel.state.getReviewDataResponse.data[index].id, category: "RESTAURANT"))
                                                                    }, label: {
                                                                        Text(.modify)
                                                                            .font(.caption01)
                                                                            .foregroundColor(.gray1)
                                                                            .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                                                                            .background {
                                                                                RoundedRectangle(cornerRadius: 30)
                                                                                    .foregroundColor(.gray3)
                                                                            }
                                                                    })
                                                                    
                                                                    Button(action: {
                                                                        showAlert = true
                                                                        selectedIndex = index
                                                                    }, label: {
                                                                        Text(.delete)
                                                                            .font(.caption01)
                                                                            .foregroundColor(.gray1)
                                                                            .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
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
                                                                                if let selectedIndex = selectedIndex {
                                                                                    Task {
                                                                                        await deleteMyReview(id: viewModel.state.getReviewDataResponse.data[selectedIndex].id)
                                                                                        await getReviewData(id: id, category: "RESTAURANT", page: 0, size: 12)
                                                                                    }
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
                                                                ExpandableText("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")", lineLimit: 2)
                                                                    .font(.body02)
                                                                    .padding(.leading, 16)
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
                                                                        AppState.shared.navigationPath.append(ReviewType.userProfile(id: Int64(viewModel.state.getReviewDataResponse.data[index].memberId!)))
                                                                    } label: {
                                                                        Text(viewModel.state.getReviewDataResponse.data[index].nickname ?? "")
                                                                            .font(.body02_bold)
                                                                    }
                                                                    
                                                                    HStack(spacing: 0) {
                                                                        Text(.review)
                                                                            .font(.caption01) + Text(" \(viewModel.state.getReviewDataResponse.data[index].memberReviewCount ?? 0)")
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
                                                                ExpandableText("\(viewModel.state.getReviewDataResponse.data[index].content ?? "")", lineLimit: 2)
                                                                    .font(.body02)
                                                                    .padding(.leading, 16)
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
                                                            .padding(.bottom, 12)
                                                            HStack(spacing: 0) {
                                                                Button {
                                                                    reportModal = true
                                                                    idx = viewModel.state.getReviewDataResponse.data[index].id
                                                                } label: {
                                                                    Text(.doReport)
                                                                        .font(.caption02)
                                                                        .foregroundColor(Color.gray1)
                                                                }
                                                                
                                                                Spacer()
                                                                
                                                                Text("\(viewModel.state.getReviewDataResponse.data[index].createdAt ?? "")")
                                                                    .font(.caption01)
                                                                    .foregroundStyle(Color.gray1)
                                                            }
                                                            .padding(.leading, 16)
                                                            .padding(.trailing, 16)
                                                            .padding(.bottom, 16)
                                                        }
                                                        .sheet(isPresented: $reportModal, onDismiss: {
                                                            if reportReasonViewFlag {
                                                                AppState.shared.navigationPath.append(ReviewType.report(id: idx, isReport: isReport))
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
                                                    }
                                                }
                                            }
                                        }
                                        if viewModel.state.getReviewDataResponse.totalElements > 3 {
                                            Button {
                                                // TODO: - 후기 모두 보기(각 컨텐츠 별)
                                                AppState.shared.navigationPath.append(ReviewType.reviewAll(id: id))
                                            } label: {
                                                Text(.reviewSeeMore)
                                                    .foregroundStyle(Color.gray1)
                                                    .font(.body_bold)
                                            }
                                            .frame(width: Constants.screenWidth - 32, height: 48)
                                            .background(){
                                                RoundedRectangle(cornerRadius: 50).stroke(lineWidth: 1).foregroundStyle(.gray2).background(.clear
                                                )
                                            }
                                        }
                                    }
                                    .padding(.bottom, 66)
                                    .padding(.top, 32)
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
                    ZStack {
                        Rectangle()
                            .fill(Color.red) // 투명한 배경
                            .frame(height: 56) // HStack과 같은 높이
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: -2) // 그림자 설정
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
                                Text(.writeReview)
                                    .font(.body_bold)
                                    .foregroundStyle(Color.white)
                                    .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.main).frame(width: Constants.screenWidth * (28 / 36), height: 40))
                            }
                            .frame(width: Constants.screenWidth * (28 / 36), height: 40)
                            .padding(.trailing, 16)
                        }
                        .frame(width: Constants.screenWidth, height: 56)
                        .background(Color.white)
                    }
                }
            }
            .navigationDestination(for: ReviewType.self) { viewType in
                switch viewType {
                case .review:
                    ReviewWriteMain(reviewAddress: viewModel.state.getRestaurantDetailResponse.address ?? "", reviewImageUrl: viewModel.state.getRestaurantDetailResponse.images?[0].originUrl ?? "", reviewTitle: viewModel.state.getRestaurantDetailResponse.title ?? "", reviewId: viewModel.state.getRestaurantDetailResponse.id ?? 0, reviewCategory: "RESTAURANT")
                case let .userProfile(id):
                    UserProfileMainView(memberId: id)
                case let .reviewAll(id):
                    ReviewAllDetailMainView(id: id, reviewCategory: "RESTAURANT")
                case let .report(id, isReport):
                    ReportReasonView(id: id, isReport: $isReport)
                case let .detailReivew(id, category):
                    MyReviewDetailView(reviewId: id, reviewCategory: category)
                        .environmentObject(LocalizationManager())
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
    
    func reviewFavorite(id: Int64) async {
        await viewModel.action(.reviewFavorite(id: id))
    }
    
    func deleteMyReview(id: Int64) async {
        await viewModel.action(.deleteMyReview(id: id))
    }
    
    func getSafeArea() ->UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    /// 텍스트 높이를 계산하는 메서드
    func estimateTextHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return boundingBox.height
    }
}

enum ReviewType: Hashable {
    case review
    case userProfile(id: Int64)
    case reviewAll(id: Int64)
    case report(id: Int64, isReport: Bool) // 신고하기
    case detailReivew(id: Int64, category: String)
}

#Preview {
    RestaurantDetailView(id: 1)
        .environmentObject(LocalizationManager())
}


