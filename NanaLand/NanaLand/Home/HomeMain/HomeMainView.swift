//
//  HomeMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import Kingfisher
import SwiftUIIntrospect

struct HomeMainView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = HomeMainViewModel()
    @State private var isRecommendCalled = false
    @AppStorage("provider") var provider:String = ""
    
    let randomSearchPlaceHolder: LocalizedKey = [.jejuCanolaFestival, .jejuGreenTeaField, .jejuFiveDayMarket, .udoToday, .trendyGujwa, .hallasanTrail, .jejuNightDrive, .nearJejuAirport, .jejuSummerHydrangea, .jejuCharmingHanok].randomElement()!
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        
                    }) {
                        Image("icLogo")
                        
                    }
                    .padding(.leading, 16)
                    Spacer()
                    
                    NanaSearchBar(
                        placeHolder: randomSearchPlaceHolder,
                        searchTerm: .constant(""),
                        showClearButton: false,
                        disabled: true
                    )
                    .simultaneousGesture(TapGesture().onEnded {
                        AppState.shared.navigationPath.append(HomeViewType.search)
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.notification)
                    }) {
                        Image("icBell")
                    }
                    .padding(.trailing, 16)
                    
                }
                .padding(.bottom, 8)
                .padding(.top, 1)
                // banner View
                BannerView()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (220 / 360))
                    .padding(.bottom, 16)
                
                /// category View
                HStack(alignment: .top, spacing: 0) {
                    // 7대자연 link
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.nature)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("icNature")
                                .frame(width: 62, height: 48)
                            
                            Text(.nature)
                                .font(.gothicNeo(size: 12, font: "semibold"))
                                .tint(.black)
                        }
                    })
                    .frame(minHeight: 65)
             
                    Spacer()
                    // 축제 link
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.festival)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("icFestival")
                                .frame(width: 62, height: 48)
                            
                            Text(.festival)
                                .font(.gothicNeo(size: 12, font: "semibold"))
                                .tint(.black)
                        }
                    })
                    .frame(minHeight: 65)
                    Spacer()
                    // 전통시장 link
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.shop)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("icShop")
                                .frame(width: 62, height: 48)
                            
                            Text(.market)
                                .font(.gothicNeo(size: 12, font: "semibold"))
                                .tint(.black)
                        }
                    })
                    .frame(minHeight: 65)
                    Spacer()
                    // 이색체험 link
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.experience)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("icExp")
                                .frame(width: 62, height: 48)
                            Text(.experience)
                                .font(.gothicNeo(size: 12, font: "semibold"))
                                .tint(.black)
                        }
                    })
                    .frame(minHeight: 65)
                    Spacer()
                    // 제주 맛집 link
                    Button(action: {
                        AppState.shared.navigationPath.append(HomeViewType.restaurant)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("icRestaurant")
                                .frame(width: 62, height: 48)
                            
                            Text(.restaurant)
                                .font(.gothicNeo(size: 12, font: "semibold"))
                                .tint(.black)
                        }
                    })
                    .frame(minHeight: 65)
                }
                .frame(width: UIScreen.main.bounds.width - 32)
                .padding(.bottom, 32)
                
                /// 광고 뷰
                HStack(spacing: 0) {
                    AdvertisementView()
                        .frame(width: Constants.screenWidth, height: (UIScreen.main.bounds.width - 40.0) * (80.0 / 328.0))
                        .padding(.bottom, 40)
                       
                }
                HStack {
                    let nickname: String = provider == "GUEST" ? LocalizedKey.ourNana.localized(for: LocalizationManager.shared.language) : AppState.shared.userInfo.nickname
                    Text(.recommendTitle, arguments: [nickname])
                        .font(.gothicNeo(size: 18, font: "bold"))
                    
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.bottom, 8)
                
                HStack(alignment: .top, spacing: 8) {
                    ForEach(viewModel.state.getRecommendResponse, id: \.id) { article in
                        switch article.category {
                        case "NATURE":
                            Button {
                                AppState.shared.navigationPath.append(HomeViewType.natureDetail(id: Int(article.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }

                        case "FESTIVAL":
                            Button {
                                AppState.shared.navigationPath.append(HomeViewType.festivalDetail(id: Int(article.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }

                        case "MARKET":
                            Button {
                                AppState.shared.navigationPath.append(HomeViewType.shopDetail(id: Int(article.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }
                        case "EXPERIENCE":
                            Button {
                                AppState.shared.navigationPath.append(HomeViewType.experienceDetail(id: Int(article.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }
                            
                        default:
                            Button {
                                AppState.shared.navigationPath.append(HomeViewType.natureDetail(id: Int(article.id)))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                
                Spacer()
                    .frame(height: 50)
            }
        }
        .scrollIndicators(.hidden)
        //safeArea 크기 가져아서 넣기
        .padding(.top, 1)
        .onAppear {
            print("언어:\(localizationManager.language)")
            Task {
                await getRecommendData()
                isRecommendCalled = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deeplinkShowMarketDetail)) { notification in
            if let userInfo = notification.userInfo, let id = userInfo["id"] as? Int {
                AppState.shared.navigationPath.append(HomeViewType.shopDetail(id: id))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deeplinkShowFestivalDetail)) { notification in
            if let userInfo = notification.userInfo, let id = userInfo["id"] as? Int {
                AppState.shared.navigationPath.append(HomeViewType.festivalDetail(id: id))
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .deeplinkShowNatureDetail)) { notification in
            if let userInfo = notification.userInfo, let id = userInfo["id"] as? Int {
                AppState.shared.navigationPath.append(HomeViewType.natureDetail(id: id))
            }
        }
        .navigationDestination(for: HomeViewType.self) { viewType in
            switch viewType {
            case .search:
                SearchMainView()
            case .nature:
                // 광고 클릭으로 들어간게 아닐경우
                NatureMainView(isAdvertisement: false)
            case .festival:
                FestivalMainView()
            case .shop:
                ShopMainView()
            case .experience:
                ExperienceMainView()
            case .nanapick:
                NanapickMainView()
            case .restaurant:
                RestaurantMainView()
            case let .shopDetail(id):
                ShopDetailView(id: Int64(id))
            case let .festivalDetail(id):
                FestivalDetailView(id: Int64(id))
            case let .natureDetail(id):
                NatureDetailView(id: Int64(id))
            case let .experienceDetail(id):
                ExperienceDetailView(id: Int64(id))
            case let .notification:
                NotificationView()
            }
        }
    }
    
    func getRecommendData() async {
        await viewModel.action(.getRecommendItem)
    }
    
}

struct AdvertisementView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = ""
    private let images: [String] = ["ad1", "ad2", "ad3", "ad4"]
    @State private var currentPage = 0
    
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        ZStack() {
            TabView(selection: $selectedNum) {
                ForEach(images, id: \.self) { image in
                    // image는 String이자, default tag로 붙는 값
                    VStack(spacing: 2) {
                        HStack(spacing: 0) {
                            Button(action: {
                                switch image {
                                case "ad1":
                                    AppState.shared.navigationPath.append(AdvertisementViewType.ad1)
                                case "ad2":
                                    AppState.shared.navigationPath.append(AdvertisementViewType.ad2)
                                case "ad3":
                                    AppState.shared.navigationPath.append(AdvertisementViewType.ad3)
                                case "ad4":
                                    AppState.shared.navigationPath.append(AdvertisementViewType.ad4)
                                default:
                                    break
                                }
                            }, label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    switch image {
                                    case "ad1":
                                        HStack(spacing: 0){
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(.firstAdvertismentTitle)
                                                    .font(.gothicNeo(.bold, size: 16))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                                Text(.firstAdvertismentSubTitle)
                                                    .font(.gothicNeo(.medium, size: 12))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            
                                            if localizationManager.language == .korean || localizationManager.language == .chinese {
                                                Image(image)
                                                    .padding(.trailing, 15)
                                            }
                                        }
                                        .frame(width: Constants.screenWidth, height: 80)
                                        .background(.skyBlue)
                                        
                                    case "ad2":
                                        HStack(spacing: 0) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(.secondAdvertismentTitle)
                                                    .font(.gothicNeo(.bold, size: 16))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                                Text(.secondAdvertismentSubTitle)
                                                    .font(.gothicNeo(.medium, size: 12))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            
                                            if localizationManager.language == .korean || localizationManager.language == .chinese {
                                                Image(image)
                                                    .padding(.trailing, 15)
                                            }
                                        }
                                        .frame(width: Constants.screenWidth, height: 80)
                                        .background(.main50P)
                                        
                                    case "ad3":
                                        HStack(spacing: 0) {
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(.thirdAdvertismentTitle)
                                                    .font(.gothicNeo(.bold, size: 16))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                                Text(.thirdAdvertismentSubTitle)
                                                    .font(.gothicNeo(.medium, size: 12))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            
                                            if localizationManager.language == .korean || localizationManager.language == .chinese {
                                                Image(image)
                                                    .padding(.trailing, 15)
                                            }
                                        }
                                        .frame(width: Constants.screenWidth, height: 80)
                                        .background(Color.init(hex: 0xF7C2BC))
                                        
                                        
                                    case "ad4":
                                        HStack(spacing: 0){
                                            VStack(alignment: .leading, spacing: 0) {
                                                Text(.fourthAdvertismentTitle)
                                                    .font(.gothicNeo(.bold, size: 16))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                                Text(.fourthAdvertismentSubTitle)
                                                    .font(.gothicNeo(.medium, size: 12))
                                                    .padding(.leading, 16)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            Spacer()
                                            
                                            if localizationManager.language == .korean || localizationManager.language == .chinese {
                                                Image(image)
                                                    .padding(.trailing, 15)
                                            }
                                        }
                                        .frame(width: Constants.screenWidth, height: 80)
                                        .background(Color.init(hex: 0xFFBC11))
                                        
                                        
                                        
                                    default:
                                        Text(.firstAdvertismentTitle)
                                            .font(.gothicNeo(.bold, size: 16))
                                        Text(.firstAdvertismentSubTitle)
                                            .font(.gothicNeo(.medium, size: 12))
                                    }
                                    
                                }
                                .frame(width: Constants.screenWidth)
                                
                            })
                            
                        }
                        .frame(width: Constants.screenWidth, height: 80)
                        
                    }
                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer, perform: { _ in
                withAnimation {
                    // index값을 증가, 아니면 1
                    // (selectedNum의 값을 변경해주기 위함)
                    index = index < images.count ? index + 1 : 1
                    // selectedNum 값은 images 배열의 element 값
                    selectedNum = images[index - 1]
                    currentPage = index - 1
                }
            })
            VStack(spacing: 0) {
                Spacer()
                CustomPageIndicator(count: images.count, currentPage: $currentPage)
            }
            .frame(height: 90)
          
        }
        .navigationDestination(for: AdvertisementViewType.self) { viewType in
            switch viewType {
            case .ad1:
                // 광고 클릭으로 들어간 경우
                NatureMainView(isAdvertisement: true)
            case .ad2:
                NatureMainView()
            case .ad3:
                ShopMainView()
            case .ad4:
                FestivalMainView()
            }
        }
    }
}

enum AdvertisementViewType {
    case ad1
    case ad2
    case ad3
    case ad4
}

struct BannerView: View {
    @StateObject var viewModel = HomeMainViewModel()
    
   @State private var isBannerCalled = false
    
    var message = ""
    private let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    // tabView에 selection에 바인딩 할 값
    @State private var index = 0
    private let images: [String] = ["icTabNumber1", "icTabNumber2", "icTabNumber3", "icTabNumber3"]
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        ZStack {
            TabView(selection: $index) {
                ForEach(viewModel.state.getBannerResponse.indices, id: \.self) { index in
                    let banner = viewModel.state.getBannerResponse[index]
                    ZStack {
                        Button {
                            if index == 0 {
                                AppState.shared.navigationPath.append(BannerViewType.firstBanner(id: Int(banner.id)))
                            } else if index == 1{
                                AppState.shared.navigationPath.append(BannerViewType.secondBanner(id: Int(banner.id)))
                            } else {
                                AppState.shared.navigationPath
                                    .append(BannerViewType.thirdBanner(id: Int(banner.id)))
                            }
                        } label: {
                            
                            ZStack{
                                KFImage(URL(string: banner.firstImage.originUrl))
                                    .resizable()
                                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (220 / 360))
                                
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .background(){
                                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                                    }
                                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (220 / 360))
                            }
                            
                        }

                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Spacer()
                                Text(banner.version)
                                    .font(.caption01)
                                    .foregroundStyle(.white)
                                    .padding(.trailing, 16)
                            }
                            .padding(.top, 8)
                            
                            Spacer()
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(banner.subHeading)
                                        .foregroundStyle(.white)
                                        .font(.body_bold)
                                    Text(banner.heading)
                                        .foregroundStyle(.white)
                                        .font(.largeTitle02)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 16)
                            .padding(.leading, 16)
                            
                        }
                    }
                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (220 / 360))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onReceive(timer, perform: { _ in
                withAnimation {
                    // index값을 증가, 아니면 0
                    index = index < (viewModel.state.getBannerResponse.count-1) ? index + 1 : 0
                }
            })
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Text("\(index + 1) / \(viewModel.state.getBannerResponse.count)")
                        .frame(width: 41, height: 20)
                        .font(.caption02)
                        .foregroundColor(.white)
                        .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.black.opacity(0.5)) // Set the background color here
                            )
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 1) // 둥근 모서리와 테두리 추가
                                
                        )
        
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.trailing, 15)
               
            }
            .padding(.bottom, 16)
            
        }
        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (220 / 360))
        .onAppear {
            Task {
                await getBannerData()
                isBannerCalled = true
                
            }
        }
        .navigationDestination(for: BannerViewType.self) {viewType in
            switch viewType {
            case let .firstBanner(id):
                NewNanaPickDetailView(id: Int64(id))
            case let .secondBanner(id):
                NewNanaPickDetailView(id: Int64(id))
            case let .thirdBanner(id):
                NewNanaPickDetailView(id: Int64(id))
            }
        }
        
    }
    
    func getBannerData() async {
        return await viewModel.action(.getBannerItem)
    }
}

struct CustomPageIndicator: View {
    var count: Int
    @Binding var currentPage: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count) { index in
                Circle()
                    .fill(currentPage == index ? Color.black : Color.gray)
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
        .padding(.bottom, -12)
    }
}

enum BannerViewType: Hashable {
    case firstBanner(id: Int)
    case secondBanner(id: Int)
    case thirdBanner(id: Int)
}

#Preview {
    HomeMainView()
}

