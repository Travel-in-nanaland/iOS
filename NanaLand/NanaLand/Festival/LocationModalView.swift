//
//  LocationModalView.swift
//  NanaLand
//
//  Created by jun on 5/6/24.
//

import SwiftUI

struct LocationModalView: View {
    @ObservedObject var viewModel: FestivalMainViewModel
    @Binding var location: String
    @Binding var isModalShown: Bool

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var selectedLocation: [String] = []
    @State var buttonsToggled = Array(repeating: false, count: 14)
    var startDate: String
    var endDate: String 
    var title: String // 이번달 축제인지, 종료된 축제인지
 
    
    var locationArray = ["제주시", "애월", "조천", "한경", "구좌", "한림", "성산", "추자", "서귀포시", "대정", "안덕", "남원", "표선", "우도"]
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("지역")
                    .font(.largeTitle02)
                    .padding(.leading, 16)
                    .padding(.top, 24)
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Image("icX")
                        .padding(.trailing, 16)
                        .padding(.top, 24)
                })
                
            }
            .padding(.bottom, 24)
            VStack(spacing: 0) {
                Image("icMap")
                HStack(spacing: 0) {
                    Spacer()
                    Text("*참고용 사진입니다.")
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
                            .font(.body01)
                            .foregroundStyle(Color.gray1)
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
                            .frame(width: 24, height: 24)
                        Text("전체선택")
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
                        Text("해제")
                            .font(.body01)
                    }
                })
                .frame(height: 40)
                .padding(.trailing, 58)
            }
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
                print(selectedLocation)
               
                Task {
                    if title == "이번달" {
                        await getLocationFestivalMainItem(page: 0, size: 18, filterName: selectedLocation.joined(separator: ","), start: "", end: "")
                    }
                    else {
                        await getPastLocationFestivalMainItem(page: 0, size: 18, filterName: selectedLocation.joined(separator: ","))
                    }
                    location = selectedLocation.joined(separator: ",")
                    // 장소 선택 안 할시 전 지역
                    if location == "" {
                        location = "전 지역"
                    }
                }
             
                isModalShown = false
            }, label: {
                Text("적용하기")
                    .font(.body_bold)
                    .foregroundStyle(Color.white)
            })
            .frame(width: Constants.screenWidth - 32, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color.main)
            )

            Spacer()
            
        }
        
    }
    
    func getLocationFestivalMainItem(page: Int32, size: Int32, filterName: String, start: String, end: String) async {
        await viewModel.action(.getThisMonthFestivalMainItem(page: page, size: size, filterName: filterName, startDate: start, endDate: end))
    }
    
    func getPastLocationFestivalMainItem(page: Int32, size: Int32, filterName: String) async {
        await viewModel.action(.getPastFestivalMainItem(page: page, size: size, filterName: filterName))
    }
    
    func toggleButton(_ index: Int) {
        buttonsToggled[index].toggle()
    }
    
}