//
//  LocationModalView.swift
//  NanaLand
//
//  Created by jun on 5/6/24.
//

import SwiftUI

struct LocationModalView: View {
    @ObservedObject var viewModel: FestivalMainViewModel
    @ObservedObject var natureViewModel: NatureMainViewModel
    @ObservedObject var shopViewModel: ShopMainViewModel
    @ObservedObject var restaurantModel: RestaurantMainViewModel
    @ObservedObject var experienceViewModel: ExperienceMainViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    
    @Binding var location: String
    @Binding var isModalShown: Bool
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedLocation: [LocalizedKey] = []
    @State var buttonsToggled = Array(repeating: false, count: 14)
    @State var localizedLocationArray: [String] = []
    var startDate: String
    var endDate: String
    var title: String // 이번달 축제인지, 종료된 축제인지
    var type = "" // 이색체험 액티비티인지 문화예술인지
    var keyword = "" // 키워드 필터링
    @State var APIKeyword = ""
    
    var locationArray: [LocalizedKey] = [
        .jejuCity,
        .Aewol,
        .Jocheon,
        .Hangyeong,
        .Gunjwa,
        .Hallim,
        .Udo,
        .Chuja,
        .SeogwipoCity,
        .Daejeong,
        .Andeok,
        .Namwon,
        .Pyoseon,
        .Seongsan
    ]
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(.location)
                    .font(.title02_bold)
                    .padding(.leading, 16)
                    .padding(.top, 24)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("icX")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .padding(.trailing, 16)
                        .padding(.top, 24)
                })
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 0) {
                MapView(selectedLocation: selectedLocation)
                    .environmentObject(localizationManager)
                    .padding(EdgeInsets(top: -150, leading: 0, bottom: 0, trailing: 0))
                HStack(spacing: 0) {
                    Spacer()
                    Text(.photoDescription)
                        .font(.caption01)
                        .foregroundStyle(Color.gray1)
                }
                .padding(.trailing, 16)
            }
            .padding(.bottom, 24)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<locationArray.count, id: \.self) { index in
                    Button(action: {
                        toggleButton(index)
                    }, label: {
                        Text(locationArray[index].localized(for: localizationManager.language))
                            .font(.body02)
                            .foregroundStyle(buttonsToggled[index] ? Color.main : Color.gray1)
                            .padding(.leading, 7)
                            .padding(.trailing, 7)
                    })
                    .frame(width: 70, height: 40)
                    .background(
                        buttonsToggled[index] ? (RoundedRectangle(cornerRadius: 30)
                            .fill(Color.main10P).overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.main, lineWidth: 1))) : RoundedRectangle(cornerRadius: 30).fill(Color.white).overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.gray2, lineWidth: 1))
                    )
                }
            }
            .padding(.bottom, 16)
            
            HStack(spacing: 0) {
                Button(action: {
                    for index in 0..<buttonsToggled.count {
                        if !buttonsToggled[index] {
                            buttonsToggled[index].toggle()
                        }
                    }
                    selectedLocation = [LocalizedKey.Hangyeong,LocalizedKey.Daejeong, LocalizedKey.Hallim, LocalizedKey.Aewol, LocalizedKey.jejuCity, LocalizedKey.Jocheon, LocalizedKey.Gunjwa, LocalizedKey.Andeok, LocalizedKey.SeogwipoCity, LocalizedKey.Namwon, LocalizedKey.Pyoseon, LocalizedKey.Seongsan, LocalizedKey.Chuja, LocalizedKey.Udo]
                }, label: {
                    HStack(spacing: 0) {
                        Image("icCheck")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.allSelect)
                            .font(.body02)
                    }
                })
                .padding(.leading, 58)
                
                Spacer()
                
                Button(action: {
                    for index in 0..<buttonsToggled.count {
                        if buttonsToggled[index] {
                            buttonsToggled[index].toggle()
                        }
                    }
                    selectedLocation = []
                }, label: {
                    HStack(spacing: 0) {
                        Image("icRe")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.reset)
                            .font(.body02)
                    }
                })
                .padding(.trailing, 58)
            }
            .padding(.bottom, 24)
            
            Spacer()
            
            Button(action: {
                // 눌린 버튼을 selectedLocation에 추가
                selectedLocation.removeAll()
                for index in 0..<buttonsToggled.count {
                    if buttonsToggled[index] {
                        selectedLocation.append(locationArray[index])
                    }
                }
                if selectedLocation.isEmpty {
                    selectedLocation = []
                }
                
                Task {
                    let selectedLocationStrings = selectedLocation.map { $0.localized(for: localizationManager.language) }
                    if title == "이번달" {
                        viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                        await getLocationFestivalMainItem(page: 0, size: 18, filterName: selectedLocationStrings.joined(separator: ","), start: startDate, end: endDate)
                    } else if title == "종료된" {
                        viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                        viewModel.state.page = 0
                        await getPastLocationFestivalMainItem(page: 0, size: 12, filterName: selectedLocationStrings.joined(separator: ","))
                    } else if title == "7대자연" {
                        natureViewModel.state.getNatureMainResponse = NatureMainModel(totalElements: 0, data: [])
                        await getLocationNatureMainItem(filterName: selectedLocationStrings.joined(separator: ","), page: 0, size: 12)
                        natureViewModel.state.location = selectedLocationStrings.joined(separator: ",")
                        natureViewModel.state.page = 0
                    } else if title == "전통시장"{ // 전통시장
                        shopViewModel.state.getShopMainResponse = ShopMainModel(totalElements: 0, data: [])
                        await getLocationShopMainItem(filterName: selectedLocationStrings.joined(separator: ","), page: 0, size: 18)
                        shopViewModel.state.page = 0
                    } else if title == "이색 체험" {
                        experienceViewModel.state.getExperienceMainResponse = ExperienceMainModel(totalElements: 0, data: []) // 초기화
                        APIKeyword = keyword.replacingOccurrences(of: "수상레저", with: "WATER_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "지상레저", with: "LAND_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "항공레저", with: "AIR_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "해양레저", with: "MARINE_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "농촌체험", with: "RURAL_EXPERIENCE")
                        APIKeyword = keyword.replacingOccurrences(of: "힐링테라피", with: "HEALING_THERAPY")
                        await getLocationExperienceMainItem(filterName: selectedLocationStrings.joined(separator: ","), page: 0, size: 18, type: type, keyword: keyword == "키워드" ? "" : APIKeyword)
                    } else {
                        restaurantModel.state.getRestaurantMainResponse = RestaurantMainModel(totalElements: 0, data: []) // 초기화
                        APIKeyword = keyword.replacingOccurrences(of: "수상레저", with: "WATER_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "지상레저", with: "LAND_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "항공레저", with: "AIR_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "해양레저", with: "MARINE_LEISURE")
                        APIKeyword = keyword.replacingOccurrences(of: "농촌체험", with: "RURAL_EXPERIENCE")
                        APIKeyword = keyword.replacingOccurrences(of: "힐링테라피", with: "HEALING_THERAPY")
                        await getLocationRestaurantMainItem(filterName: localizedLocationArray.joined(separator: ","), page: 0, size: 18, type: type, keyword: keyword == "키워드" ? "" : APIKeyword)
                    }
                    
                    location = selectedLocationStrings.joined(separator: ",")
                    viewModel.state.location = location
                    print(location)
                    // 장소 선택 안 할시 전 지역
                    if location.isEmpty {
                        location = LocalizedKey.allLocation.localized(for: localizationManager.language)
                    }
                }
                
                isModalShown = false
            }, label: {
                Text(.apply)
                    .font(.body_bold)
                    .foregroundStyle(Color.white)
            })
            .frame(width: Constants.screenWidth - 32, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
            )
            .padding(.bottom, 24)
        }
    }
    
    // 이번달 축제에서 지역 선택 시
    func getLocationFestivalMainItem(page: Int32, size: Int32, filterName: String, start: String, end: String) async {
        await viewModel.action(.getThisMonthFestivalMainItem(page: page, size: size, filterName: filterName, startDate: start, endDate: end))
    }
    
    // 종료된 축제에서 지역 선택 시
    func getPastLocationFestivalMainItem(page: Int32, size: Int32, filterName: String) async {
        await viewModel.action(.getPastFestivalMainItem(page: page, size: size, filterName: filterName))
    }
    
    // 7대 자연에서 지역 선택 시
    func getLocationNatureMainItem(filterName: String, page: Int64, size: Int64) async {
        await natureViewModel.action(.getNatureMainItem(page: page, size: size, filterName: filterName))
    }
    
    // 전통시장에서 지역 선택 시
    func getLocationShopMainItem(filterName: String, page: Int64, size: Int64) async {
        await shopViewModel.action(.getShopMainItem(page: page, size: size, filterName: filterName))
    }
    
    // 이색 체험에서 지역 선택 시
    func getLocationExperienceMainItem(filterName: String, page: Int, size: Int, type: String, keyword: String) async {
        await experienceViewModel.action(.getExperienceMainItem(experienceType: type, keyword: keyword, address: filterName, page: page, size: size))
    }
    
    // 제주 맛집에서 지역 선택 시
    func getLocationRestaurantMainItem(filterName: String, page: Int, size: Int, type: String, keyword: String) async {
        await restaurantModel.action(.getRestaurantMainItem(keyword: keyword, address: filterName, page: page, size: size))
    }
    
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
        if buttonsToggled[index] {
            selectedLocation.append(locationArray[index])
        } else {
            if let selectedIndex = selectedLocation.firstIndex(of: locationArray[index]) {
                selectedLocation.remove(at: selectedIndex)
            }
        }
    }
}

#Preview {
    LocationModalView(
        viewModel: FestivalMainViewModel(), // Assuming FestivalMainViewModel() has an init method
        natureViewModel: NatureMainViewModel(), // Assuming NatureMainViewModel() has an init method
        shopViewModel: ShopMainViewModel(),// Assuming ShopMainViewModel() has an init method
        restaurantModel: RestaurantMainViewModel(),
        experienceViewModel: ExperienceMainViewModel(),
        location: .constant(""),
        isModalShown: .constant(true),
        startDate: "2024-05-01",
        endDate: "2024-05-31",
        title: "이번달 축제"
    )
    .environmentObject(LocalizationManager()) // Providing an environment object if required
}
