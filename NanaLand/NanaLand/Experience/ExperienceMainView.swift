//
//  ExperienceMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ExperienceMainView: View {
    @State private var tabIndex = 0
    var body: some View {
        VStack {
			NanaNavigationBar(title: .experience, showBackButton: true)
                .frame(height: 56)
                .padding(.bottom, 24)
            
            ExperienceTabBarView(currentTab: $tabIndex)
                .padding(.bottom, 12)
            
            switch tabIndex {
            case 0: // 액티비티 일 경우
                ExperienceMainGridView(experienceType: "Activity")
            case 1: // 문화예술 일 경우
                ExperienceMainGridView(experienceType: "CultureArts")
            default:
                ExperienceMainGridView()
            }
  
            Spacer()
        }
        .toolbar(.hidden)
    }
}

// 액티비티 그리드 뷰
struct ExperienceMainGridView: View {
    @EnvironmentObject var localizationMangaer: LocalizationManager
    @State private var locationModal = false
    @State private var keywordModal = false
    @StateObject var viewModel = ExperienceMainViewModel()
    @State private var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
    @State private var keyword = LocalizedKey.keyword.localized(for: LocalizationManager().language)
    @State private var APIKeyword = ""
    @State private var isAPICalled = false
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
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var experienceType = "Activity"
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
//                Text("\(viewModel.state.getExperienceMainResponse.totalElements)" + .count)
//                    .padding(.leading, 16)
//                    .foregroundStyle(Color.gray1)
                Spacer()
                Button {
                    self.keywordModal = true
                } label: {
                    HStack(spacing: 0) {
                        Text(keyword.split(separator: ",").count >= 3 ? "\(keyword.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : keyword.split(separator: ",").prefix(2).joined(separator: ","))
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
                        // 액티비티 키워드 모달 창
                        ActivityKeywordView(keyword: $keyword, address: location, viewModel: viewModel, selectedKeyword: viewModel.state.selectedKeyword)
                            .presentationDetents([.height(Constants.screenWidth * (328 / 360))]) // 팝업 뷰 height 조절
                    } else {
                        // 문화예술 키워드 모달 창
                        CultureAndArtsKeywordView(keyword: $keyword, address: location, viewModel: viewModel, selectedKeyword: viewModel.state.selectedKeyword)
                            .presentationDetents([.height(Constants.screenWidth * (376 / 360))]) // 팝업 뷰 height 조절
                    }
                    
                }
                
                
                Button {
                    self.locationModal = true
                } label: {
                    HStack(spacing: 0) {
                        Text(location.split(separator: ",").count >= 3 ? "\(location.split(separator: ",").prefix(2).joined(separator: ","))" + ".." : location.split(separator: ",").prefix(2).joined(separator: ","))
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
                .padding(.trailing, 16)
                .sheet(isPresented: $locationModal) { // 지역 필터링 뷰
                    LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: viewModel,location: $location, isModalShown: $locationModal, selectedLocation: viewModel.state.selectedLocation, startDate: "", endDate: "", title: LocalizedKey.experience.localized(for: localizationMangaer.language), type: experienceType == "Activity" ? "ACTIVITY" : "CULTURE_AND_ARTS", keyword: keyword)
                        .presentationDetents([.height(Constants.screenWidth * (63 / 36))])
                }
            }
            .padding(.bottom, 8)
            ScrollView {
                if isAPICalled {
                    if viewModel.state.getExperienceMainResponse.data.count == 0 {
                        NoResultView()
                            .frame(height: 70)
                            .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach((0...viewModel.state.getExperienceMainResponse.data.count - 1), id: \.self) { index in
                                Button(action: {
                                    AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getExperienceMainResponse.data[index].id))
                                }, label: {
                                    VStack(alignment: .leading, spacing: 0){
                                        ZStack {
                                            KFImage(URL(string: viewModel.state.getExperienceMainResponse.data[index].firstImage.thumbnailUrl))
                                                .resizable()
                                                .frame(width: (Constants.screenWidth - 40) / 2, height: ((Constants.screenWidth - 40) / 2) * (12 / 16))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            
                                            VStack(spacing: 0) {
                                                HStack(spacing: 0) {
                                                    Spacer()
                                                    Button {
                                                        Task {
                                                            await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getExperienceMainResponse.data[index].id), category: .experience), index: index)
                                                        }
                                                    } label: {
                                                        viewModel.state.getExperienceMainResponse.data[index].favorite ? Image("icHeartFillMain").animation(nil) : Image("icHeartDefault").animation(nil)
                                                    }
                                                }
                                                .padding(.top, 8)
                                                Spacer()
                                            }
                                            .padding(.trailing, 8)
                                        }
                                        
                                        Spacer()
                                        
                                        Text(viewModel.state.getExperienceMainResponse.data[index].title)
                                            .lineLimit(1)
                                            .font(.body02_semibold)
                                            .padding(.bottom, 4)
                                        HStack(spacing: 0){
                                            Text(viewModel.state.getExperienceMainResponse.data[index].addressTag)
                                                .font(.caption01)
                                                .foregroundStyle(Color.gray1)
                                            Spacer()
                                            
                                            Image("icStarFill")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 11)
                                            
                                            Text(String(format: "%.1f", viewModel.state.getExperienceMainResponse.data[index].ratingAvg))
                                                .font(.caption01_semibold)
                                                .foregroundStyle(Color.main)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                })
                                .frame(width: (UIScreen.main.bounds.width - 40) / 2, height:  ((Constants.screenWidth - 40) / 2) * (164 / 160))
                            }
                            if viewModel.state.page < viewModel.state.getExperienceMainResponse.totalElements / 12 {
                                ProgressView()
                                    .onAppear {
                                        print("\(viewModel.state.page)")
                                        Task {
                                            if location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) {
                                                APIKeyword = keyword
                                                for (key, value) in translations {
                                                    APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                }
                                                experienceType == "Activity" ? await getExperienceMainItem(experienceType: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: "", page: viewModel.state.page + 1, size: 12) : await getExperienceMainItem(experienceType: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: "", page: viewModel.state.page + 1, size: 12)
                                            } else {
                                                APIKeyword = keyword
                                                for (key, value) in translations {
                                                    APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                                                }
                                                experienceType == "Activity" ? await getExperienceMainItem(experienceType: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: location, page: viewModel.state.page + 1, size: 12) : await getExperienceMainItem(experienceType: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: location, page: viewModel.state.page + 1, size: 12)
                                            }
                                            
                                            viewModel.state.page += 1
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationDestination(for: ArticleViewType.self) { viewType in
                switch viewType {
                case let .detail(id):
                    ExperienceDetailView(id: id, experienceType: experienceType)
                }
            }
        }
        .onAppear {
            viewModel.state.page = 0
            print("온어피어")
            print(keyword)
            Task {
                if location == LocalizedKey.allLocation.localized(for: LocalizationManager().language) { // 지역 필터링
                    APIKeyword = keyword
                    for (key, value) in translations {
                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                    }
                   
                    experienceType == "Activity" ? await getExperienceMainItem(experienceType: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: "", page: 0, size: 12) : await getExperienceMainItem(experienceType: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: "", page: 0, size: 12)
                } else {
                    APIKeyword = keyword
                    for (key, value) in translations {
                        APIKeyword = APIKeyword.replacingOccurrences(of: key, with: value)
                    }
                    experienceType == "Activity" ? await getExperienceMainItem(experienceType: "ACTIVITY", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: location, page: 0, size: 12) : await getExperienceMainItem(experienceType: "CULTURE_AND_ARTS", keyword: keyword == LocalizedKey.keyword.localized(for: LocalizationManager().language) ? "" : APIKeyword, address: location, page: 0, size: 12)
                }
               
                
                isAPICalled = true
            
            }
        }
    }

    func getExperienceMainItem(experienceType: String, keyword: String, address: String, page: Int, size: Int) async {
        await viewModel.action(.getExperienceMainItem(experienceType: experienceType, keyword: keyword, address: address, page: page, size: size))
        
    }
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
            AppState.shared.showRegisterInduction = true
            return
        }
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
}
// 문화예술 그리드 뷰


// 액티비티, 문화예술 탭바
struct ExperienceTabBarView: View {
    @Binding var currentTab: Int
    var tabBarOptions: [String] = [LocalizedKey.Activity.localized(for: LocalizationManager().language), LocalizedKey.cultureAndArts.localized(for: LocalizationManager().language)]
    @Namespace var namespace
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabBarOptions.indices, id: \.self) { index in
                let title = tabBarOptions[index]
                TabBarItem(currentTab: $currentTab, namespace: namespace, title: title, tab: index)
                    .font(.gothicNeo(.medium, size: 12))
            }
        }
        .frame(height: 32)
    }
}

#Preview {
    ExperienceMainView()
}
