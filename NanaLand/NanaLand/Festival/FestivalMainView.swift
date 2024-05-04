//
//  FestivalMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI

struct FestivalMainView: View {
    @StateObject var viewModel = FestivalMainViewModel()
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
                FilterView()
                FestivalMainGridView(title: "이번달", locationTitle: "\(locationTitle)")
            case 1:
                FilterView()
                FestivalMainGridView(title: "종료된")
            case 2:
                SeasonFilterView()
                FestivalMainGridView(title: "계절별")
            default:
                FilterView()
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
    @State private var isButtonClicked = false
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("3건")
                    .padding(.leading, 16)
                    .foregroundStyle(Color.gray1)
                Spacer()
            }
            .frame(height:56)
            .padding(.bottom, 8)
            
            HStack {
                SeasonFilterButtonView(title: "봄")
                .padding(.leading, 16)
                
                SeasonFilterButtonView(title: "여름")
                
                SeasonFilterButtonView(title: "가을")
                
                SeasonFilterButtonView(title: "겨울")

                Spacer()
            }
            
         
        }
        .padding(.bottom, 16)
        .frame(width: Constants.screenWidth)
    }
}
struct FilterView: View {
    var body: some View{
        HStack(spacing: 0) {
            Text("3건")
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            
            Spacer()
            
            Menu {
                Text("날짜 선택 뷰")
            } label: {
                HStack {
                    Text("날짜")
                        .font(.gothicNeo(.medium, size: 12))
                        .padding(.leading, 12)
                    Spacer()
                    Image("icDownSmall")
                        .padding(.trailing, 12)
                }
            }
            .foregroundStyle(Color.gray1)
            .frame(width: 70, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray2, lineWidth: 1)
            )
            .padding(.trailing, 16)
            
            Menu {
                FestivalLocationFilterView()
            } label: {
                Text("지역")
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
        }
        .padding(.bottom, 16)
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
                    // 언더바 부드럽게 이동
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
    @State private var isHidden = true
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var title: String = ""
    var locationTitle = ""
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach((0...19), id: \.self) { value in
                    NavigationLink(destination: FestivalDetailView()) {
                        VStack(alignment: .leading) {
                            Text("\(locationTitle)")
                            Text("\(title)")
                            Text("photo")
                                .foregroundStyle(.black)
                            Text("title")
                                .foregroundStyle(.black)
                            Text("hashtag \(value)")
                                .foregroundStyle(.black)
                        }
                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 120)
                        .background(.skyBlue)
                        .padding(.leading, 0)
               
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    FestivalMainView()
}
