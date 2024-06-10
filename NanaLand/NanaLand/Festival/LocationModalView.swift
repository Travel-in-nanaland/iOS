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
    @EnvironmentObject var localizationManager: LocalizationManager
    
    
    @Binding var location: String
    @Binding var isModalShown: Bool

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedLocation: [String] = []
    @State var buttonsToggled = Array(repeating: false, count: 14)
    var startDate: String
    var endDate: String 
    var title: String // 이번달 축제인지, 종료된 축제인지
 
    
    var locationArray = [LocalizedKey.jejuCity.localized(for: LocalizationManager().language), LocalizedKey.Aewol.localized(for: LocalizationManager().language), LocalizedKey.Jocheon.localized(for: LocalizationManager().language), LocalizedKey.Hangyeong.localized(for: LocalizationManager().language), LocalizedKey.Gunjwa.localized(for: LocalizationManager().language), LocalizedKey.Hallim.localized(for: LocalizationManager().language), LocalizedKey.Udo.localized(for: LocalizationManager().language), LocalizedKey.Chuja.localized(for: LocalizationManager().language), LocalizedKey.SeogwipoCity.localized(for: LocalizationManager().language), LocalizedKey.Daejeong.localized(for: LocalizationManager().language), LocalizedKey.Andeok.localized(for: LocalizationManager().language), LocalizedKey.Namwon.localized(for: LocalizationManager().language), LocalizedKey.Pyoseon.localized(for: LocalizationManager().language), LocalizedKey.Seongsan.localized(for: LocalizationManager().language)]
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
                Image("icMap")
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
                ForEach(0...locationArray.count - 1, id: \.self) { index in
                    Button(action: {
                        toggleButton(index)
                    }, label: {
                        Text(locationArray[index])
                            .font(.body02)
                            .foregroundStyle(Color.gray1)
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
                        if buttonsToggled[index] == false {
                            buttonsToggled[index].toggle()
                        }
                    }
                    
                }, label: {
                    HStack(spacing: 0) {
                        Image("icCheck")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text(.allSelect)
                            .font(.body01)
                    }
                })
                .frame(height: 40)
                .padding(.leading, 58)
                
                Spacer()
                
                Button(action: {
                    for index in 0..<buttonsToggled.count {
                        if buttonsToggled[index] == true {
                            buttonsToggled[index].toggle()
                        }
                    }
                }, label: {
                    HStack(spacing: 0) {
                        Image("icRe")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(.reset)
                            .font(.body01)
                    }
                })
                .frame(height: 40)
                .padding(.trailing, 58)
            }
            .padding(.bottom, 24)
            Spacer()
            Button(action: {
                // 눌린 버튼을 selectedLocation에다가 추가해준다. 즉 buttonsToggled[index]가 true인 애들만 골라서 selectedLocation에다가 추가 한 이후에, 그거에 대한 API 호출을 하고 닫는다.
                // todo
                for index in 0..<buttonsToggled.count {
                    if buttonsToggled[index] == true {
                        selectedLocation.append(locationArray[index])
                    }
                }
                if selectedLocation.count == 0 {
                    selectedLocation = [""]
                }

                Task {
                    if title == "이번달" {
                        viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                        await getLocationFestivalMainItem(page: 0, size: 18, filterName: selectedLocation.joined(separator: ","), start: startDate, end: endDate)
                    }
                    else if title == "종료된" {
                        viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                        viewModel.state.page = 0
                        await getPastLocationFestivalMainItem(page: 0, size: 12, filterName: selectedLocation.joined(separator: ","))
                  
                    }
                    else if title == "7대자연" {
                        natureViewModel.state.getNatureMainResponse = NatureMainModel(totalElements: 0, data: [])
                        
                        print(selectedLocation)
                        await getLocationNatureMainItem(filterName: selectedLocation.joined(separator: ","), page: 0, size: 12)
                        natureViewModel.state.location = selectedLocation.joined(separator: ",")
                        natureViewModel.state.page = 0
                        
                    } else { // 전통시장
                        shopViewModel.state.getShopMainResponse = ShopMainModel(totalElements: 0, data: [])
                        await getLocationShopMainItem(filterName: selectedLocation.joined(separator: ","), page: 0, size: 18)
                        shopViewModel.state.page = 0
                    }
                    
                    location = selectedLocation.joined(separator: ",")
                    viewModel.state.location = location
                    print(location)
                    // 장소 선택 안 할시 전 지역
                    if location == "" {
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
    
    
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
    }
    
}
