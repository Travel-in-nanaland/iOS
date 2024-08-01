//
//  FestivalMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher
import SwiftUICalendar

struct FestivalMainView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var tabIndex = 0
    // 피커뷰에서 지역이 선택되었을 때 데이터 저장할 변수
    @State var locationTitle = "1"
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: LocalizedKey.festival.localized(for: localizationManager.language))
                .frame(height: 56)
                .padding(.bottom, 16)
            
            TabBarView(currentTab: $tabIndex)
                .padding(.bottom, 12)
            
            switch tabIndex {
            case 0:
                FestivalMainGridView(title: "이번달", locationTitle: "\(locationTitle)")
            case 1:
                FestivalMainGridView(title: "종료된")
            case 2:
                FestivalMainGridView(title: "계절별")
            default:
                FestivalMainGridView(title: "이번달")
            }
            Spacer()
        }
        .toolbar(.hidden)
        .toolbar(.hidden, for: .tabBar)
        
        
    }
}

struct SeasonFilterButtonView: View {
    @State private var isButtonClicked = false
    var title: String = ""
    var body: some View {
        Button(action: {
            isButtonClicked.toggle()
           
            if title == "봄" {
               // 봄 버튼 누를 시 필터링 code
            }
            
            if title == "여름" {
           
            }
            
            if title == "가을" {
        
            }
            
            if title == "겨울" {
           
            }
            
        }, label: {
            Text("\(title)")
                .font(.gothicNeo(.medium, size: 12))
                .foregroundStyle(isButtonClicked ? Color.main : Color.gray1)
                .frame(width: 65, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(isButtonClicked ? Color.main.opacity(0.1) : Color.white )
                        .overlay( // 테두리 추가
                            RoundedRectangle(cornerRadius: 30)
                                .strokeBorder(isButtonClicked ? Color.main.opacity(0.5) : Color.gray2, lineWidth: 1)
                                )
                    
                )
        })
        .buttonStyle(PlainButtonStyle())
    }
}

struct SeasonFilterView: View {
    @StateObject var viewModel: FestivalMainViewModel
    @State var seasonModal = false // 장소 선택 뷰 모달 여부
    @State var season = LocalizedKey.spring.localized(for: LocalizationManager().language)
    @Binding var selectedSeason : String
    var count: Int // item 갯수
    var body: some View{
        HStack(spacing: 0) {
            Text("\(count) " + .count)
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            Spacer()
            
            Button {
                self.seasonModal = true
                
            } label: {
                Text(season)
                    .font(.gothicNeo(.medium, size: 12))
                    .padding(.leading, 12)
                
                Image("icDownSmall")
                    .padding(.trailing, 12)
            }
            .foregroundStyle(Color.gray1)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray2, lineWidth: 1)
            )
            .padding(.trailing, 16)
            .sheet(isPresented: $seasonModal) {
                SeasonModalView(viewModel: viewModel, season: $season, isModalShown: $seasonModal)
                    .presentationDetents([.height(300)])
                    .onDisappear {
                        selectedSeason = season
                    }
                
            }
        }
        .padding(.bottom, 16)
    }
}
struct FilterView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: FestivalMainViewModel
    var count: Int // item 갯수
    @State private var locationModal = false
    @State private var dateModal = false
    @State private var location = LocalizedKey.allLocation.localized(for: LocalizationManager().language)
    @State private var yearMonthDay: YearMonthDay? // 시작날짜 선택 했을 때
    @State private var endYearMonthDay: YearMonthDay? // 종료날짜 선택 했을 때
    var title: String
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter
    }()
    
    // 현재 날짜를 문자열로 변환하여 반환
    var todayDateString: String {
        return FilterView.dateFormatter.string(from: Date())
    }
    
    // 현재 날짜의 연도
    var currentYear = Int(dateFormatter.string(from: Date()).prefix(4))
    // 현재 날짜의 월
    
    // 현재 날짜의 일
    var currentDay = Int(dateFormatter.string(from: Date()).suffix(2))
    
    var body: some View{
        
        HStack(spacing: 0) {
            Text("\(count) " + .count)
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            Spacer()
            if title == "이번달" {
                Button {
                    self.dateModal = true
                } label: {
                    HStack {
                        // 아무것도 선택 안 했을 때(첫 화면 일 때)
                        if yearMonthDay == nil {
                            Text(todayDateString.dropFirst(2))
                                .font(.gothicNeo(.medium, size: 12))
                                .padding(.leading, 12)
                        }
                        // 종료 날짜를 선택 안했을 때나, 시작 날짜와 종료날짜를 동일하게 선택 => 당일 조회
                        else if endYearMonthDay == yearMonthDay  || endYearMonthDay == nil {
                            Text(String(yearMonthDay!.year).dropFirst(2) + "." + formattedNumber(yearMonthDay!.month) + "." + formattedNumber(yearMonthDay!.day))
                                .font(.gothicNeo(.medium, size: 12))
                                .padding(.leading, 12)
                        } else {
                            // 시작 날짜 종료 날짜 다를 때
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
                    CalendarFilterView(viewModel: viewModel, startDate: $yearMonthDay, endDate: $endYearMonthDay, location: $location)
                        .presentationDetents([.height(500)])
                }
            }
        
            VStack(spacing: 0) {
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
                            .resizable()
                            .frame(width: 16, height: 16)
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
                .sheet(isPresented: $locationModal) {
                    if yearMonthDay == nil {
                        // 첫 화면 일 때
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: title)
                            .presentationDetents([.height(Constants.screenWidth * (630 / Constants.screenWidth))])
                    } // 종료 날짜를 선택 안했을 때나, 시작 날짜와 종료날짜를 동일하게 선택 => 당일 조회
                    else if endYearMonthDay == yearMonthDay  || endYearMonthDay == nil {
                        
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", endDate: "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", title: title)
                            .presentationDetents([.height(Constants.screenWidth * (630 / Constants.screenWidth))])
                    } else {
                        // 시작 날짜 종료날짜 다를 때
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), restaurantModel: RestaurantMainViewModel(), experienceViewModel: ExperienceMainViewModel(), location: $location, isModalShown: $locationModal, startDate:  "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", endDate:  "\(endYearMonthDay!.year)" + "\(formattedNumber(endYearMonthDay!.month))" + "\(formattedNumber(endYearMonthDay!.day))", title: title)
                            .presentationDetents([.height(Constants.screenWidth * (630 / Constants.screenWidth))])
                    }
                                              
                }
            }
          
            
        }
        .padding(.bottom, 16)
    }
    
    func formattedNumber(_ number: Int) -> String {
            // 숫자를 문자열로 변환하여, 1자리 숫자인 경우에만 앞에 0을 추가
            return number < 10 ? "0\(number)" : "\(number)"
        }
}

struct TabBarView: View {
    @Binding var currentTab: Int
    var tabBarOptions: [String] = [LocalizedKey.thisMonthFestival.localized(for: LocalizationManager().language), LocalizedKey.pastFestival.localized(for: LocalizationManager().language), LocalizedKey.seasonFestival.localized(for: LocalizationManager().language)]
    @Namespace var namespace
    var body: some View {
        HStack {
            
            ForEach(tabBarOptions.indices, id: \.self) { index in
                let title = tabBarOptions[index]
                TabBarItem(currentTab: $currentTab, namespace: namespace,
                           title: title,
                           tab: index)
                .font(.gothicNeo(.medium, size: 12))
            }
        }
        .frame(height: 32)
    }
}

struct TabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    var title: String
    var tab: Int
    
    var body: some View {
        Button {
            withAnimation(nil) {
                currentTab = tab
            }
 
        } label: {
            VStack {
                Spacer()
                Text(title)
                    .font(currentTab == tab ? .body02_semibold : .body02)
                if currentTab == tab {
                    Color.main
                        .frame(height: 2)
                    // 언더바 부드럽게 이동(탭바 언더바)
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace.self)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.spring(), value: currentTab)
        }
        .buttonStyle(.plain)
    }
}

struct FestivalMainGridView: View {
    @StateObject var viewModel = FestivalMainViewModel()
    @State private var isHidden = true
    @State private var isAPICalled = false
    @State var buttonsToggled = Array(repeating: false, count: 0)
    @State var isFirstAPICalled = true // 첫 appear에서만 API 호출
    @State private var page = 0
    @State private var size = 12
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var title: String = ""
    var locationTitle = ""
    @State var selectedSeason = ""
    
    @State private var APIFlag = true // 첫 onAppear 시에만 호출 하도록
    @EnvironmentObject var localizationManager: LocalizationManager
    var body: some View {
		VStack(spacing: 0) {
			if title == "이번달" {
                FilterView(viewModel: viewModel, count: Int(viewModel.state.getFestivalMainResponse.totalElements), title: title)
			} else if title == "종료된" {
                FilterView(viewModel: viewModel, count: Int(viewModel.state.getFestivalMainResponse.totalElements), title: title)
			}
			else {
                SeasonFilterView(viewModel: viewModel, selectedSeason: $selectedSeason, count: Int(viewModel.state.getFestivalMainResponse.totalElements))
			}
			
			
			ScrollView {
				if isAPICalled {
					// 보여줄 데이터가 없을 때
					if viewModel.state.getFestivalMainResponse.data.count == 0 {
						NoResultView()
							.frame(height: 70)
							.padding(.top, (Constants.screenHeight - 208) * (179 / 636))
						
						
					}
					else {
						LazyVGrid(columns: columns, spacing: 16) {
							
							// 보여줄 데이터가 있을 때
                            
							ForEach((0...viewModel.state.getFestivalMainResponse.data.count - 1), id: \.self) { index in
								Button(action: {
									AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getFestivalMainResponse.data[index].id))
								}, label: {
									VStack(alignment: .leading, spacing: 0) {
										ZStack {
											KFImage(URL(string: viewModel.state.getFestivalMainResponse.data[index].thumbnailUrl))
											
												.resizable()
												.frame(width: (Constants.screenWidth - 40) / 2, height: ((Constants.screenWidth - 40) / 2) * (12 / 16))
												.clipShape(RoundedRectangle(cornerRadius: 12))
												.padding(.bottom, 8)
											VStack {
												HStack {
													Spacer()
													
													Button {
														
														Task {
															await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getFestivalMainResponse.data[index].id), category: .festival), index: index)
															
														}
														
													} label: {
														
														viewModel.state.getFestivalMainResponse.data[index].favorite ? Image("icHeartFillMain").animation(nil) : Image("icHeartDefault").animation(nil)
														
													}
												}
												.padding(.top, 8)
												Spacer()
											}
											.padding(.trailing, 8)
										}
										
										Text(viewModel.state.getFestivalMainResponse.data[index].title)
											.font(.body02_bold)
											.padding(.bottom, 4)
											.lineLimit(1)
										
										Text(viewModel.state.getFestivalMainResponse.data[index].period)
											.font(.caption)
											.padding(.bottom, 8)
                                            .foregroundStyle(Color.gray1)
										
										Text(viewModel.state.getFestivalMainResponse.data[index].addressTag)
											.frame(width: 64, height: 20)
											.font(.caption)
											.background(
												RoundedRectangle(cornerRadius: 30)
													.foregroundStyle(Color.main10P)
											)
											.foregroundStyle(Color.main)
									}
									.frame(width: (Constants.screenWidth - 40) / 2)
								})
							}
                            if title == "종료된" {
                                if viewModel.state.getFestivalMainResponse.totalElements >= 12 {
                                    if viewModel.state.page < 6 {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    
                                                    await getPastFestivalMainITem(page: Int32(viewModel.state.page
                                                                                              + 1),size: Int32(size), filterName:viewModel.state.location)
                                                        print(page)
                                                    viewModel.state.page += 1
                                                    
                                                    
                                                }
                                            }
                                    }
                                }
                                
                            }
//                            else if title == "이번달" {
//                                if page < 5 {
//                                    ProgressView()
//                                        .onAppear {
//                                            Task {
//                                                await getThisMonthFestivalMainItem(page: Int32(page + 1),size: Int32(size), filterName:[""].joined(separator: ","), startDate: "", endDate:"")
//                                                print(page)
//                                                page += 1
//                                            }
//                                        }
//                                }
//                            }
                            else if title == "계절별" {
                                switch selectedSeason {
                                case LocalizedKey.spring.localized(for: LocalizationManager().language):
                                    
                                    if viewModel.state.page < viewModel.state.getFestivalMainResponse.totalElements / 12 {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    // 필터가 바뀌면 페이지 초기화 해주고 어떤 계절 선택했는지에 따라서 season값 달리줘야함
                                                    await getSeasonFestivalMainItem(page: Int32(viewModel.state.page + 1),size: Int32(size), season: "spring")
                                                    viewModel.state.page += 1
                                      
                                                }
                                            }
                                    }
                                case LocalizedKey.summer.localized(for: LocalizationManager().language):
                                    
                                    if viewModel.state.page < viewModel.state.getFestivalMainResponse.totalElements / 12  {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    // 필터가 바뀌면 페이지 초기화 해주고 어떤 계절 선택했는지에 따라서 season값 달리줘야함
                                                    await getSeasonFestivalMainItem(page: Int32(viewModel.state.page + 1),size: Int32(size), season: "summer")
                                                  
                                                    viewModel.state.page += 1
                                              
                                                }
                                            }
                                    }
                                case LocalizedKey.autumn.localized(for: LocalizationManager().language):
                        
                                    if viewModel.state.page < viewModel.state.getFestivalMainResponse.totalElements / 12  {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    // 필터가 바뀌면 페이지 초기화 해주고 어떤 계절 선택했는지에 따라서 season값 달리줘야함
                                                    await getSeasonFestivalMainItem(page: Int32(viewModel.state.page
                                                                                                + 1),size: Int32(size), season: "autumn")
                                                    viewModel.state.page += 1
                                                   
                                                    
                                                }
                                            }
                                    }
                                case LocalizedKey.winter.localized(for: LocalizationManager().language):
                                   
                                    if viewModel.state.page < viewModel.state.getFestivalMainResponse.totalElements / 12  {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    // 필터가 바뀌면 페이지 초기화 해주고 어떤 계절 선택했는지에 따라서 season값 달리줘야함
                                                    await getSeasonFestivalMainItem(page: Int32(viewModel.state.page + 1),size: Int32(size), season: "winter")
                                                    
                                                    viewModel.state.page += 1
                                       
                                                }
                                            }
                                    }
                                default:
                                    
                                    if page < viewModel.state.getFestivalMainResponse.totalElements / 12 {
                                        ProgressView()
                                            .onAppear {
                                                Task {
                                                    // 필터가 바뀌면 페이지 초기화 해주고 어떤 계절 선택했는지에 따라서 season값 달리줘야함
                                                    await getSeasonFestivalMainItem(page: Int32(page + 1),size: Int32(size), season: "spring")
                                                    print("\(viewModel.state.page)기본")
                                                    page += 1
                                                }
                                            }
                                    }
                                }
                                
                            }
                            
						}
						.padding(.horizontal, 16)
					}
				}
			}
		}
		.navigationDestination(for: ArticleViewType.self) { viewType in
			switch viewType {
			case let .detail(id):
				FestivalDetailView(id: id)
			}
		}
        .onAppear {
            page = 0
            
            Task {
                if APIFlag {
                    viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                    if title == "이번달" {
                        await getThisMonthFestivalMainItem(page: 0, size: 12, filterName: [""].joined(separator: ","), startDate: "", endDate: "")
                        isAPICalled = true
                    } else if title == "계절별" {
                        await getSeasonFestivalMainItem(page: 0, size: 12, season: "spring")
                        isAPICalled = true
                    } else {
                        await getPastFestivalMainITem(page: Int32(page), size: 12, filterName: [""].joined(separator: ","))
                        isAPICalled = true
                    }
                    APIFlag = false
                }
             
                buttonsToggled = Array(repeating: false, count: viewModel.state.getFestivalMainResponse.data.count)
                
            }
            
        }
    }
    
    func getThisMonthFestivalMainItem(page: Int32, size: Int32, filterName: String, startDate: String, endDate: String) async {
        await viewModel.action(.getThisMonthFestivalMainItem(page: page, size: size, filterName: filterName, startDate: startDate, endDate: endDate))
    }
    
    func getSeasonFestivalMainItem(page: Int32, size: Int32, season: String) async {
        await viewModel.action(.getSeasonFestivalMainItem(page: page, size: size, season: season))
    }
    
    func getPastFestivalMainITem(page: Int32, size: Int32, filterName: String) async {
        await viewModel.action(.getPastFestivalMainItem(page: page, size: size, filterName: filterName))
    }
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
    }
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
		if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
			AppState.shared.showRegisterInduction = true
			return
		}
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
}

#Preview {
    FestivalMainView()
}
