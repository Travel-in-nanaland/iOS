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
   
    @State private var tabIndex = 0
    // 피커뷰에서 지역이 선택되었을 때 데이터 저장할 변수
    @State var locationTitle = "1"
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "축제")
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

struct FestivalLocationFilterView: View {
    
    @State private var selectedLocation: String = "" // 선택된 지역을 저장하는 상태 변수
    let locations = ["Seoul", "Busan", "Incheon", "Daegu", "Daejeon", "Gwangju"] // 사용 가능한 지역 목록

    var body: some View {
        VStack {
            // 지역 선택 드롭다운 메뉴
            Picker("지역을 선택해주세요", selection: $selectedLocation) {
                ForEach(locations, id: \.self) { location in
                    Text(location)
                }
            }
            .pickerStyle(.menu) // 드롭다운 메뉴 스타일
            .onChange(of: selectedLocation) { value in
                print("change")
               
            }
            // 선택된 지역 표시
            Text("Selected Location: \(selectedLocation)")
                .padding()
           
        }
        .padding()
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
    @State private var seasonModal = false // 장소 선택 뷰 모달 여부
    @State private var season = "봄"
    var count: Int // item 갯수
    var body: some View{
        HStack(spacing: 0) {
            Text("\(count)건")
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            
            Spacer()
            
            Button {
                self.seasonModal = true
            } label: {
                Text(season)
                    .font(.gothicNeo(.medium, size: 12))
                    .padding(.leading, 12)
                Spacer()
                Image("icDownSmall")
                    .padding(.trailing, 12)
            }
            .foregroundStyle(Color.gray1)
            .frame(width: 70, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray2, lineWidth: 1)
            )
            .padding(.trailing, 16)
            .sheet(isPresented: $seasonModal) {
                SeasonModalView(viewModel: viewModel, season: $season, isModalShown: $seasonModal)
                    .presentationDetents([.height(300)])
            }
        }
        .padding(.bottom, 16)
    }
}
struct FilterView: View {
    @StateObject var viewModel: FestivalMainViewModel
    var count: Int // item 갯수
    @State private var locationModal = false
    @State private var dateModal = false
    @State private var location = "전 지역"
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
            Text("\(count)건")
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
                            Text(String(formattedNumber(yearMonthDay!.year).dropFirst(2)) + "." +  formattedNumber(yearMonthDay!.month) + "." +  formattedNumber(yearMonthDay!.day))
                                .font(.gothicNeo(.medium, size: 12))
                                .padding(.leading, 12)
                            Text(" ~ ")
                            Text(String(formattedNumber(endYearMonthDay!.year).dropFirst(2)) + "." +  formattedNumber(endYearMonthDay!.month) + formattedNumber(endYearMonthDay!.day))
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
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(),location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: title)
                            .presentationDetents([.height(Constants.screenWidth * (630 / Constants.screenWidth))])
                    } // 종료 날짜를 선택 안했을 때나, 시작 날짜와 종료날짜를 동일하게 선택 => 당일 조회
                    else if endYearMonthDay == yearMonthDay  || endYearMonthDay == nil {
                        
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", endDate: "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", title: title)
                    } else {
                        // 시작 날짜 종료날짜 다를 때
                        LocationModalView(viewModel: viewModel, natureViewModel: NatureMainViewModel(), shopViewModel: ShopMainViewModel(), location: $location, isModalShown: $locationModal, startDate:  "\(yearMonthDay!.year)" + "\(formattedNumber(yearMonthDay!.month))" + "\(formattedNumber(yearMonthDay!.day))", endDate:  "\(endYearMonthDay!.year)" + "\(formattedNumber(endYearMonthDay!.month))" + "\(formattedNumber(endYearMonthDay!.day))", title: title)
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
    var tabBarOptions: [String] = ["이번달 축제", "종료된 축제", "계절별 축제"]
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
            currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(title)
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
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var title: String = ""
    var locationTitle = ""
    var body: some View {
		VStack(spacing: 0) {
			if title == "이번달" {
				FilterView(viewModel: viewModel, count: viewModel.state.getFestivalMainResponse.data.count, title: title)
			} else if title == "종료된" {
				FilterView(viewModel: viewModel, count: viewModel.state.getFestivalMainResponse.data.count, title: title)
			}
			else {
				SeasonFilterView(viewModel: viewModel, count: viewModel.state.getFestivalMainResponse.data.count)
			}
			
			
			ScrollView {
				if isAPICalled {
					// 보여줄 데이터가 없을 때
					if viewModel.state.getFestivalMainResponse.data.count == 0 {
						FestivalNoResultView()
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
														
														viewModel.state.getFestivalMainResponse.data[index].favorite ? Image("icHeartFillMain").animation(nil) : Image("icHeart").animation(nil)
														
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
			case let .reportInfo(id, category):
				ReportInfoMainView(id: id, category: category)
			}
		}
        .onAppear {
            Task {
                if title == "이번달" {
                    await getThisMonthFestivalMainItem(page: 0, size: 18, filterName: [""].joined(separator: ","), startDate: "", endDate: "")
                    isAPICalled = true
                } else if title == "계절별" {
                    await getSeasonFestivalMainItem(page: 0, size: 50, season: "spring")
                    isAPICalled = true
                } else {
                    await getPastFestivalMainITem(page: 0, size: 18, filterName: [""].joined(separator: ","))
                    isAPICalled = true
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
