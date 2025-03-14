//
//  SearchDetailCategoryResultView.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import SwiftUI
import SwiftUICalendar

struct SearchDetailCategoryResultView: View {
    @ObservedObject var searchVM: SearchViewModel
    @EnvironmentObject var localizationManager: LocalizationManager

    @State private var locationModal = false
    @State private var dateModal = false
    @Binding var yearMonthDay: YearMonthDay?
    @State private var endYearMonthDay: YearMonthDay?
    let tab: Category
    let searchTerm: String
    var experienceType = ""
    // 액티비티, 문화예술 키워드
    @State private var keyword = LocalizedKey.keyword.localized(for: LocalizationManager().language)
    @State private var keywordModal = false
    @State private var APIKeyword = ""
    @State var isInit: Bool = false
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter
    }()
    
    let translations = [
        LocalizedKey.groundLeisure.localized(for: LocalizationManager().language): "LAND_LEISURE",
        LocalizedKey.waterLeisure.localized(for: LocalizationManager().language): "WATER_LEISURE",
        LocalizedKey.aviationLeisure.localized(for: LocalizationManager().language): "AIR_LEISURE",
        LocalizedKey.marineExperience.localized(for: LocalizationManager().language): "MARINE_EXPERIENCE",
        LocalizedKey.ruralExperience.localized(for: LocalizationManager().language): "RURAL_EXPERIENCE",
        LocalizedKey.healingTherapy.localized(for: LocalizationManager().language): "HEALING_THERAPY",
        LocalizedKey.history.localized(for: LocalizationManager().language): "HISTORY",
        LocalizedKey.exhibition.localized(for: LocalizationManager().language): "EXHIBITION",
        LocalizedKey.experienceWorkshop.localized(for: LocalizationManager().language): "WORKSHOP",
        LocalizedKey.artGallery.localized(for: LocalizationManager().language): "ART_MUSEUM",
        LocalizedKey.museum.localized(for: LocalizationManager().language): "MUSEUM",
        LocalizedKey.park.localized(for: LocalizationManager().language): "PARK",
        LocalizedKey.performance.localized(for: LocalizationManager().language): "PERFORMANCE",
        LocalizedKey.religiousFacilities.localized(for: LocalizationManager().language): "RELIGIOUS_FACILITY",
        LocalizedKey.themePark.localized(for: LocalizationManager().language): "THEME_PARK"
    ]
    
    var restaurantTranslations: [String: String] {
        return [
            LocalizedKey.koreanFood.localized(for: localizationManager.language) : "KOREAN",
            LocalizedKey.chineseFood.localized(for: localizationManager.language) : "CHINESE",
            LocalizedKey.japaneseFood.localized(for: localizationManager.language) : "JAPANESE",
            LocalizedKey.westernFood.localized(for: localizationManager.language) : "WESTERN",
            LocalizedKey.snacks.localized(for: localizationManager.language) : "SNACK",
            LocalizedKey.southAmericanFood.localized(for: localizationManager.language) : "SOUTH_AMERICAN",
            LocalizedKey.southeastAsianFood.localized(for: localizationManager.language) : "SOUTHEAST_ASIAN",
            LocalizedKey.vegan.localized(for: localizationManager.language) : "VEGAN",
            LocalizedKey.halalFood.localized(for: localizationManager.language) : "HALAL",
            LocalizedKey.meatblackpork.localized(for: localizationManager.language) : "MEAT_BLACK_PORK",
            LocalizedKey.seaFood.localized(for: localizationManager.language) : "SEAFOOD",
            LocalizedKey.chickenBurger.localized(for: localizationManager.language) : "CHICKEN_BURGER",
            LocalizedKey.cafeDessert.localized(for: localizationManager.language) : "CAFE_DESSERT",
            LocalizedKey.pubRestaurant.localized(for: localizationManager.language) : "PUB_FOOD_PUB"
        ]
    }
    
    // 현재 날짜를 문자열로 변환하여 반환
    var todayDateString: String {
        return FilterView.dateFormatter.string(from: Date())
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 17) {
                HStack(spacing: 0) {
                    Spacer()
                    switch tab {
                    case .nature, .market:
                        Button {
                            self.locationModal = true
                            
                        } label: {
                            HStack(spacing: 0) {
                                
                                Text(searchVM.state.location.split(separator: ",").count >= 2 ? "\(searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: localizationManager.language) + "\(searchVM.state.location.split(separator: ",").count - 1)" : searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))
                                    .font(.gothicNeo(.regular, size: 12))
                                    .lineLimit(1)
                                    .padding(.leading, 12)
                                    .truncationMode(.tail)
                                
                                Image("icDownSmall")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .padding(.trailing, 12)
                            }
                            .frame(height: 40)
                        }
                        .foregroundStyle(Color.gray1)
                        .frame(maxHeight: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .strokeBorder(Color.gray2, lineWidth: 1)
                        )
                        .padding(.trailing, 16)
                        .sheet(isPresented: $locationModal) {
                            LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), searchViewModel: searchVM, isModalShown: $locationModal, selectedLocation: searchVM.state.selectedLocation, startDate: "", endDate: "", title: tab == .nature ? "searchNature" : "searchMarket", searchTerm: searchTerm)
                                .presentationDetents([.height(Constants.screenWidth * (58 / 36))])
                        }
                    case .all:
                        EmptyView()
                    case .festival: // 기간, 지역
                        
                        Button {
                            self.dateModal = true
                        } label: {
                            
                            HStack(spacing: 0) {
                                // 아무것도 선택 안 했을 때(첫 화면)
                                if yearMonthDay == nil {
                                    Text(todayDateString.dropFirst(2))
                                        .font(.gothicNeo(.medium, size: 12))
                                        .padding(.leading, 12)
                                }
                                
                                else if endYearMonthDay == yearMonthDay || endYearMonthDay == nil {
                                    Text(String(yearMonthDay!.year).dropFirst(2) + "." + formattedNumber(yearMonthDay!.month) + "." + formattedNumber(yearMonthDay!.day))
                                        .font(.gothicNeo(.medium, size: 12))
                                        .padding(.leading, 12)
                                } else {
                                    
                                    let year = String(formattedNumber(endYearMonthDay!.year).dropFirst(2))
                                    let month = String(formattedNumber(endYearMonthDay!.month))
                                    let day = String(formattedNumber(endYearMonthDay!.day))
                                    
                                    Text(String(formattedNumber(yearMonthDay!.year).dropFirst(2)) + "." +  formattedNumber(yearMonthDay!.month) + "." +  formattedNumber(yearMonthDay!.day))
                                        .font(.gothicNeo(.medium, size: 12))
                                        .padding(.leading, 12)
                                    Text(" ~ ")
                                    Text("\(year).\(month).\(day)")
                                        .font(.gothicNeo(.medium, size: 12))
                                }
                                Image("icDownSmall")
                                    .padding(.trailing, 12)
                            }
                        }
                        .foregroundStyle(Color.gray1)
                        .frame(height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .strokeBorder(Color.gray2, lineWidth: 1)
                        )
                        .padding(.trailing, 16)
                        .sheet(isPresented: $dateModal) {
                            // TODO: viewModel에서 날짜 구현
                            CalendarFilterView(viewModel: FestivalMainViewModel(), searchViewModel: searchVM, startDate: $yearMonthDay, endDate: $endYearMonthDay, currentStartDate: searchVM.state.selectedStartDate, currentEndDate: searchVM.state.selectedEndDate, title: "search", searchTerm: searchTerm)
                                .presentationDetents([.height(500)])
                        }
                        
                    case .activity, .cultureAndArts: // 키워드, 지역
                        HStack(spacing: 0) {
            //                Text("\(viewModel.state.getExperienceMainResponse.totalElements)" + .count)
            //                    .padding(.leading, 16)
            //                    .foregroundStyle(Color.gray1)
                            Spacer()
                            Button {
                                self.keywordModal = true
                            } label: {
                                HStack(spacing: 0) {
                                    Text(keyword.split(separator: ",").count >= 2 ? "\(keyword.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: localizationManager.language) + "\(keyword.split(separator: ",").count - 1)" : keyword.split(separator: ",").prefix(1).joined(separator: ","))
                                        .font(.gothicNeo(.medium, size: 12))
                                        .lineLimit(1)
                                        .padding(.leading, 12)
                                        .truncationMode(.tail)
                                    
                                    Image("icDownSmall")
                                        .padding(.trailing, 12)
                                }
                                .frame(height: 40)
                            }
                            .foregroundStyle(Color.gray1)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .strokeBorder(Color.gray2, lineWidth: 1)
                            )
                            .padding(.trailing, 8)
                            .sheet(isPresented: $keywordModal) {
                                if experienceType == "Activity" {
                                    ActivityKeywordView(keyword: $keyword, address: searchVM.state.apiLocation, viewModel: ExperienceMainViewModel(), searchViewModel: searchVM, selectedKeyword: searchVM.state.selectedKeyword, title: "search", searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (290 / 360))]) // 팝업 뷰 height 조절
                                } else {
                                    CultureAndArtsKeywordView(keyword: $keyword, address: searchVM.state.apiLocation, viewModel: ExperienceMainViewModel(), searchViewModel: searchVM, selectedKeyword: searchVM.state.selectedKeyword, title: "search", searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (337 / 360))])
                                }
                               
                            }
                            
                            Button {
                                self.locationModal = true
                            } label: {
                                HStack(spacing: 0) {
                                    Text(searchVM.state.location.split(separator: ",").count >= 2 ? "\(searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: localizationManager.language) + "\(searchVM.state.location.split(separator: ",").count - 1)" : searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))
                                        .font(.gothicNeo(.regular, size: 12))
                                        .lineLimit(1)
                                        .padding(.leading, 12)
                                        .truncationMode(.tail)
                                    Image("icDownSmall")
                                        .padding(.trailing, 12)
                                }
                                .frame(height: 40)
                            }
                            .foregroundStyle(Color.gray1)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .strokeBorder(Color.gray2, lineWidth: 1)
                            )
                            .padding(.trailing, 16)
                            .sheet(isPresented: $locationModal) { // 지역 필터링 뷰
                                if experienceType == "Activity" {
                                    LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), searchViewModel: searchVM, isModalShown: $locationModal, selectedLocation: searchVM.state.selectedLocation, startDate: "", endDate: "", title: "searchActivity" , type: "ACTIVITY", keyword: keyword, searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (58 / 36))])
                                } else {
                                    LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), searchViewModel: searchVM, isModalShown: $locationModal, selectedLocation: searchVM.state.selectedLocation, startDate: "", endDate: "", title: "searchCulture" , type: "CULTURE_AND_ARTS", keyword: keyword, searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (58 / 36))])
                                }
                             
                            }
                        }
               
                    case .restaurant: // 종류, 지역
                        HStack(spacing: 0) {
                
                            Spacer()
                            
                            HStack(spacing: 0) {
                                Button {
                                    self.keywordModal = true
                                } label: {
                                    HStack(spacing: 0) {
                                        Text(keyword.split(separator: ",").count >= 2 ? "\(keyword.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: LocalizationManager().language) : keyword.split(separator: ",").prefix(1).joined(separator: ","))
                                            .font(.gothicNeo(.medium, size: 12))
                                            .lineLimit(1)
                                            .padding(.leading, 12)
                                            .truncationMode(.tail)
                                        Image("icDownSmall")
                                            .padding(.trailing, 12)
                                    }
                                    .frame(height: 40)
                                }
                                .foregroundStyle(Color.gray1)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(Color.gray2, lineWidth: 1)
                                )
                                .padding(.trailing, 8)
                                .sheet(isPresented: $keywordModal) {
                                    RestaurantKeywordView(keyword: $keyword, address: searchVM.state.apiLocation, viewModel: RestaurantMainViewModel(), searchViewModel: searchVM, selectedKeyword: searchVM.state.selectedKeyword, title: "search", searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (448 / 360))]) // 팝업 뷰 height 조절
                                }
                                
                                Button {
                                    self.locationModal = true
                                } label: {
                                    HStack(spacing: 0) {
                                        Text(searchVM.state.location.split(separator: ",").count >= 2 ? "\(searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))" + LocalizedKey.other.localized(for: LocalizationManager().language) : searchVM.state.location.split(separator: ",").prefix(1).joined(separator: ","))
                                            .font(.gothicNeo(.regular, size: 12))
                                            .lineLimit(1)
                                            .padding(.leading, 12)
                                            .truncationMode(.tail)
                                        Image("icDownSmall")
                                            .padding(.trailing, 12)
                                    }
                                    .frame(height: 40)
                                }
                                .foregroundStyle(Color.gray1)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .strokeBorder(Color.gray2, lineWidth: 1)
                                )
                                .padding(.trailing, 16)
                                .sheet(isPresented: $locationModal) { // 지역 필터링 뷰
                                    LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), searchViewModel: searchVM, isModalShown: $locationModal, selectedLocation: searchVM.state.selectedLocation, startDate: "", endDate: "", title: "searchRestaurant", keyword: keyword, searchTerm: searchTerm)
                                        .presentationDetents([.height(Constants.screenWidth * (58 / 36))])
                                }
                            }
                        }
                    case .nanaPick:
                        EmptyView()
                    }
                    
                }
                
                if searchVM.state.currentSearchTab == .activity || searchVM.state.currentSearchTab == .nanaPick || searchVM.state.currentSearchTab == .market || searchVM.state.currentSearchTab == .nature || searchVM.state.currentSearchTab == .festival || searchVM.state.currentSearchTab == .restaurant ||
                    searchVM.state.currentSearchTab == .cultureAndArts {
                    if false {
                        VStack(spacing: 4) {
                            Image(.airplane)
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text(.beingPrepared)
                                .font(.body01)
                                .foregroundStyle(Color.gray1)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: Constants.screenWidth - 32)
                        .padding(.top, 150)
                        
                    } else if searchVM.isSeaechresultIsEmpty() {
                        VStack(spacing: 15) {
                            Image(.icGlass)
                                .resizable()
                                .frame(width: 78, height: 78)
                            Text(.noSearchResult)
                                .font(.body01)
                                .foregroundStyle(Color.gray1)
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: Constants.screenWidth - 32)
                        .padding(.top, 150)
                    } else {
                        LazyVGrid(
                            columns: [GridItem(.flexible()), GridItem(.flexible())]
                        ) {
                            ForEach({ () -> [Article] in
                                switch tab {
                                case .all:
                                    return [] as [Article]
                                case .nature:
                                    return searchVM.state.natureCategorySearchResult.data
                                case .festival:
                                    return searchVM.state.festivalCategorySearchResult.data
                                case .market:
                                    return searchVM.state.marketCategorySearchResult.data
                                case .activity:
                                    return searchVM.state.activityCategorySearchResult.data
                                case .cultureAndArts:
                                    return searchVM.state.cultureAndArtsCategorySearchResult.data
                                case .nanaPick:
                                    return searchVM.state.nanaCategorySearchResult.data
                                case .restaurant:
                                    return searchVM.state.restaurantCategorySearchResult.data
                                }
                            }(),
                            id: \.id) { article in
                                NavigationLink(destination: {
                                    
                                    destinationView(for: article)
                                }) {
                                    ArticleItem(category: tab, article: article, onTapHeart: {
                                        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
                                            AppState.shared.showRegisterInduction = true
                                            return
                                        }
                                        Task {
                                            await searchVM.action(.didTapHeartInSearchDetail(category: tab, article: article))
                                        }
                                    })
                                }
                            }
                            switch tab {
                            case .nature:
                                if searchVM.state.naturePage < searchVM.state.natureCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                if searchVM.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                    await searchVM.action(.searchFilterNatureMainItem(term: searchTerm, page: searchVM.state.naturePage + 1, filterName: ""))
                                                } else {
                                                    await searchVM.action(.searchFilterNatureMainItem(term: searchTerm, page: searchVM.state.naturePage + 1, filterName: searchVM.state.apiLocation))
                                                
                                                }
                                                searchVM.state.naturePage += 1
                                            }
                                        }
                                }
                                
                            case .all:
                                if !searchVM.isLastPage(tab: tab) {
                                    ProgressView()
                                        .task {
                                            await searchVM.action(.searchTerm(category: tab, term: searchTerm))
                                        }
                                        .frame(width: 20)
                                        .position(x: Constants.screenWidth/2 - 20)
                                }
                            case .festival:
                                // TODO: - 
                                if searchVM.state.festivalPage < searchVM.state.festivalCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                await searchVM.action(.searchFilterFestivalMainItem(term: searchTerm, page: searchVM.state.festivalPage + 1, startDate: "", endDate: ""))
                                                searchVM.state.festivalPage += 1
                                            }
                                        }
                                }
                                
                            case .market:
                                if searchVM.state.marketPage < searchVM.state.marketCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                if searchVM.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                    await searchVM.action(.searchFilterMarketMainItem(term: searchTerm, page: searchVM.state.naturePage + 1, filterName: ""))
                                                } else {
                                                    await searchVM.action(.searchFilterMarketMainItem(term: searchTerm, page: searchVM.state.naturePage + 1, filterName: searchVM.state.apiLocation))
                                                
                                                }
                                                searchVM.state.marketPage += 1
                                            }
                                        }
                                }
                            case .activity:
                                if searchVM.state.activityPage < searchVM.state.activityCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                if searchVM.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                    APIKeyword = keyword
                                                    for(key, value) in translations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    
                                                    await searchVM.action(.searchFilterActivityMainItem(term: searchTerm, page: searchVM.state.activityPage + 1, type: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: ""))
                                                } else {
                                                    APIKeyword = keyword
                                                    for (key, value) in translations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    await searchVM.action(.searchFilterActivityMainItem(term: searchTerm, page: searchVM.state.activityPage + 1, type: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: searchVM.state.apiLocation))
                                                }
                                                searchVM.state.activityPage += 1
                                            }
                                        }
                                }
                            case .cultureAndArts:
                                if searchVM.state.cultureAndArtsPage < searchVM.state.cultureAndArtsCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                if searchVM.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                    APIKeyword = keyword
                                                    for(key, value) in translations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    
                                                    await searchVM.action(.searchFilterCultureAndArtsMainItem(term: searchTerm, page: searchVM.state.cultureAndArtsPage + 1, type: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: ""))
                                                } else {
                                                    APIKeyword = keyword
                                                    for(key, value) in translations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    await searchVM.action(.searchFilterCultureAndArtsMainItem(term: searchTerm, page: searchVM.state.cultureAndArtsPage + 1, type: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: searchVM.state.apiLocation))
                                                }
                                                searchVM.state.cultureAndArtsPage += 1
                                            }
                                        }
                                }
                            case .restaurant:
                                if searchVM.state.restaurantPage < searchVM.state.restaurantCategorySearchResult.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            Task {
                                                if searchVM.state.location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                    APIKeyword = keyword
                                                    for(key, value) in restaurantTranslations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    await searchVM.action(.searchFilterRestaurantMainItem(term: searchTerm, page: searchVM.state.restaurantPage + 1, keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: ""))
                                                } else {
                                                    APIKeyword = keyword
                                                    for (key, value) in restaurantTranslations {
                                                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                    }
                                                    await searchVM.action(.searchFilterRestaurantMainItem(term: searchTerm, page: searchVM.state.restaurantPage + 1, keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, filterName: searchVM.state.apiLocation))
                                                }
                                                searchVM.state.restaurantPage += 1
                                            }
                                        }
                                }
                            case .nanaPick:
                                if !searchVM.isLastPage(tab: tab) {
                                    ProgressView()
                                        .task {
                                            await searchVM.action(.searchTerm(category: tab, term: searchTerm))
                                        }
                                        .frame(width: 20)
                                        .position(x: Constants.screenWidth/2 - 20)
                                }
                            }
                          
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
        }
//        .navigationDestination(for: SearchDetailViewType.self) { viewType in
//            switch viewType {
//            case .detail:
//                NatureDetailView(id: 2)
//            }
//        }
    }
    func formattedNumber(_ number: Int) -> String {
            // 숫자를 문자열로 변환하여, 1자리 숫자인 경우에만 앞에 0을 추가
            return number < 10 ? "0\(number)" : "\(number)"
        }
    
    private func dateToString(date: Date) -> String {
        let date = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @ViewBuilder
        func destinationView(for article: Article) -> some View {
            switch article.category {
            case .nature:
                NatureDetailView(id: Int64(article.id))
            case .festival:
                FestivalDetailView(id: Int64(article.id))
            case .market:
                ShopDetailView(id: Int64(article.id))
            case .activity:
                ExperienceDetailView(id: Int64(article.id), experienceType: "Activity")
            case .cultureAndArts:
                ExperienceDetailView(id: Int64(article.id), experienceType: "CultureArts")
            case .nanaPick:
                NaNaPickDetailView(id: Int64(article.id))
            case .all:
                Text("test")
            case .restaurant:
                RestaurantDetailView(id: Int64(article.id))
            }
        }
}

enum SearchDetailViewType: Hashable {
    case detail
}


