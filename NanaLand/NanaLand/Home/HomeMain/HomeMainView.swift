//
//  HomeMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import Kingfisher
import SwiftUIIntrospect
import FirebaseAnalytics

struct HomeMainView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = HomeMainViewModel()
    @State private var isRecommendCalled = false
    @State var searchBarClick = false
    @AppStorage("provider") var provider:String = ""
    
    let randomSearchPlaceHolder: LocalizedKey = [.jejuCanolaFestival, .jejuGreenTeaField, .jejuFiveDayMarket, .udoToday, .trendyGujwa, .hallasanTrail, .jejuNightDrive, .nearJejuAirport, .jejuSummerHydrangea, .jejuCharmingHanok].randomElement()!
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                BannerView(searchBarClick: $searchBarClick)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (300 / 360))
                    .edgesIgnoringSafeArea(.top)
                    .padding(.top, -1)
                    .padding(.leading, -0.5)
                    .padding(.bottom, 16)
                    .overlay {
                        ZStack{
                            VStack(spacing: 0){
                                TouchBlockingUIView()
                                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (40 / 360))
                                
                                Spacer()
                            }
                            .padding(.top, UIScreen.main.bounds.width * (50 / 360))
                            
                            VStack(spacing: 0){
                                HStack(spacing: 0) {
                                    Button(action: {
                                        Analytics.logEvent("button_click_custom", parameters: [
                                            "button_name": "로고 버튼 custom"
                                        ])
                                        print("analytics")
                                    }) {
                                        Image("icLogo")
                                        
                                    }
                                    .padding(.leading, 16)
                                    Spacer()
                                    
                                    NanaSearchBar(
                                        placeHolder: randomSearchPlaceHolder,
                                        searchTerm: .constant(""),
                                        searchBarClick: $searchBarClick,
                                        showClearButton: false,
                                        disabled: true
                                    )
                                    .simultaneousGesture(TapGesture().onEnded {
                                        searchBarClick = true
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
                                
                                Spacer()
                            }
                            .padding(.top, UIScreen.main.bounds.width * (60 / 360))
                        }
                        
                    }
                
                /// category View
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(alignment: .top, spacing: 16) {
                        // 7대자연 link
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.nature)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icNature")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                Text(.nature)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                        .frame(minHeight: 65)
                        
                        // 축제 link
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.festival)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icFestival")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                Text(.festival)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                        .frame(minHeight: 65)
                        
                        // 전통시장 link
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.shop)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icShop")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                
                                Text(.market)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                        .frame(minHeight: 65)
                        
                        
                        // 액티비티 link
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.activity)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icActivity")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                
                                Text(.activity)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                        .frame(minHeight: 65)
                        
                        // 문화예술 link
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.cultureAndArt)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icCultureArt")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                
                                Text(.cultureAndArts)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                        .frame(minHeight: 65)
                        
                        Button(action: {
                            AppState.shared.navigationPath.append(HomeViewType.restaurant)
                        }, label: {
                            VStack(spacing: 0) {
                                Image("icRestaurant")
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .background(.gray0)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.bottom, 4)
                                
                                Text(.restaurant)
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        })
                    }
                    .padding(.leading, 0)
                    .padding(.trailing, 0)
                    .padding(.bottom, 32)
                }
                .frame(width: UIScreen.main.bounds.width - 32)
                
                /// 광고 뷰
                HStack(spacing: 0) {
                    AdvertisementView()
                        .frame(width: Constants.screenWidth, height: (UIScreen.main.bounds.width - 40.0) * (80.0 / 328.0))
                        .padding(.bottom, 40)
                }
                
                HStack {
                    let nickname: String = provider == "GUEST" ? LocalizedKey.ourNana.localized(for: LocalizationManager.shared.language) : AppState.shared.userInfo.nickname
                    Text(.recommendTitle, arguments: [nickname])
                        .font(.body_bold)
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.bottom, 8)
                ScrollView(.horizontal) {
                    HStack(alignment: .top, spacing: 8) {
                        ForEach(Array(zip(viewModel.state.getRecommendResponse.indices, viewModel.state.getRecommendResponse)), id: \.1.id) { (index, article) in
                            switch article.category {
                            case "NATURE":
                                Button {
                                    AppState.shared.navigationPath.append(HomeViewType.natureDetail(id: Int(article.id)))
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                                .resizable()
                                                .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(article.id), category: .nature), index: index)
                                                        }
                                                    } label: {
                                                        article.favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Text(article.title)
                                            .font(.gothicNeo(size: 14, font: "bold"))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160)
                                }
                                
                            case "FESTIVAL":
                                Button {
                                    AppState.shared.navigationPath.append(HomeViewType.festivalDetail(id: Int(article.id)))
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                                .resizable()
                                                .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(article.id), category: .festival), index: index)
                                                        }
                                                    } label: {
                                                        article.favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Text(article.title)
                                            .font(.gothicNeo(size: 14, font: "bold"))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160)
                                }
                                
                            case "MARKET":
                                Button {
                                    AppState.shared.navigationPath.append(HomeViewType.shopDetail(id: Int(article.id)))
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                                .resizable()
                                                .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(article.id), category: .market), index: index)
                                                        }
                                                    } label: {
                                                        article.favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Text(article.title)
                                            .font(.gothicNeo(size: 14, font: "bold"))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160)
                                }
                                
                            case "EXPERIENCE":
                                Button {
                                    AppState.shared.navigationPath.append(HomeViewType.experienceDetail(id: Int(article.id)))
                                } label: {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                                .resizable()
                                                .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(article.id), category: .experience), index: index)
                                                        }
                                                    } label: {
                                                        article.favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Text(article.title)
                                            .font(.gothicNeo(size: 14, font: "bold"))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160)
                                }
                                
                            case "RESTAURANT":
                                Button {
                                    AppState.shared.navigationPath.append(HomeViewType.restaurantDetail(id: Int(article.id)))
                                }  label:{
                                    VStack(alignment: .leading, spacing: 8) {
                                        ZStack {
                                            KFImage(URL(string: article.firstImage.thumbnailUrl)!)
                                                .resizable()
                                                .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(article.id), category: .restaurant), index: index)
                                                        }
                                                    } label: {
                                                        article.favorite ? Image("icHeart_Fill") : Image("icHeart_Blank")
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Text(article.title)
                                            .font(.gothicNeo(size: 14, font: "bold"))
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 160)
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
                                    .frame(width: 160)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, 16)
                .padding(.trailing, 16)
                
                Spacer()
                    .frame(height: 50)
                // MARK: 지금 인기있는 게시물
                VStack(spacing: 16) {
                    HStack(spacing: 0) {
                        Text("지금 인기있는 장소🔥")
                            .font(.body_bold)
                        Spacer()
                    }
                    .padding(.leading, 16)
                    ForEach(viewModel.state.getHotResponse, id: \.id) { data in
                        ZStack {
                            KFImage(URL(string: data.firstImage.originUrl)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: Constants.screenWidth - 32, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    Spacer()
                                    Text(data.address)
                                        .font(.caption01)
                                        .foregroundStyle(.white)
                                    Text(data.title)
                                        .font(.title01_bold)
                                        .foregroundStyle(.white)
                                }
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 12)
                            
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Spacer()
                                    Image("icHeart_Blank")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .background(
                                            Circle()
                                                .fill(Color.white)
                                        )
                                }
                                .padding(.trailing, 8)
                                .padding(.top, 8)
                                Spacer()
                            }
                            
                        }
                        .frame(width: Constants.screenWidth - 32, height: 140)
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        //safeArea 크기 가져아서 넣기
        .padding(.top, 1)
        .onAppear {
            print("언어:\(localizationManager.language)")
            Task {
                await getRecommendData()
                await getHotItem()
                isRecommendCalled = true
            }
            searchBarClick = false
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
            case .activity:
                ExperienceMainView(tabIndex: 0)
            case .cultureAndArt:
                ExperienceMainView(tabIndex: 1)
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
            case let .restaurantDetail(id):
                RestaurantDetailView(id: Int64(id))
            case .notification:
                NotificationView()
            }
        }
    }
    func getRecommendData() async {
        await viewModel.action(.getRecommendItem)
    }
    
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
    
    func getHotItem() async {
        await viewModel.action(.getHotItem)
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
                // TODO: - 광고 클릭으로 들어갈 경우 구현
                // 광고 클릭으로 들어간 경우 추가해야함
                NatureMainView()
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
    
    @Binding var searchBarClick: Bool
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
                        Button(action: {
                            if !searchBarClick {
                                if index == 0 {
                                    AppState.shared.navigationPath.append(BannerViewType.firstBanner(id: Int(banner.id)))
                                } else if index == 1 {
                                    AppState.shared.navigationPath.append(BannerViewType.secondBanner(id: Int(banner.id)))
                                } else {
                                    AppState.shared.navigationPath.append(BannerViewType.thirdBanner(id: Int(banner.id)))
                                }
                            }
                        }) {
                            KFImage(URL(string: banner.firstImage.originUrl))
                                .resizable()
                                .frame(width: Constants.screenWidth, height: Constants.screenWidth * (300 / 360))
                                .overlay(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                        }
                        .disabled(searchBarClick)
                        
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                
                            }
                            .padding(.top, 8)
                            
                            Spacer()
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(banner.subHeading)
                                        .foregroundStyle(.white)
                                        .font(.body02_bold)
                                    Text(banner.heading)
                                        .foregroundStyle(.white)
                                        .font(.title02_bold)
                                }
                                Spacer()
                            }
                            .padding(.bottom, 16)
                            .padding(.leading, 16)
                        }
                    }
                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (300 / 360))
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
        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (300 / 360))
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

class TouchBlockingView: UIView {
    // 터치 이벤트를 차단하는 메서드 오버라이드
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // false를 반환하여 터치 이벤트가 전달되지 않도록 설정
        return false
    }
}

struct TouchBlockingUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> TouchBlockingView {
        let view = TouchBlockingView()
        view.backgroundColor = .clear // 터치 차단 영역은 투명
        return view
    }

    func updateUIView(_ uiView: TouchBlockingView, context: Context) {
        // 필요 시 업데이트 로직 추가
    }
}

#Preview {
    HomeMainView()
}

