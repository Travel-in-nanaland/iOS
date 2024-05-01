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
    @StateObject var viewModel = HomeMainViewModel()
	@ObservedObject var searchVM = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Button(action: {
                            print("button1")
                        }) {
                            Image("icLogo")
                                
                        }
                        .padding(.leading, 16)
                        Spacer()
                        NavigationLink(destination: SearchMainView()) {
                           Text("제주도는 지금 유채꽃 축제🏵️")
                                .padding()
                                .frame(width: 278, alignment: .leading)
                                .font(.gothicNeo(size: 14, font: "mid"))
                                .foregroundStyle(Color("Gray1"))
                                .overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("Main"))
                                )
                        }
                        Spacer()
                        
                        Button(action: {
                            print("alarm")
                        }) {
                            Image("icBell")
                        }
                        .padding(.trailing, 16)
                        
                    }
                    .padding(.bottom, 16)
                        
                    
                    /// banner View
                        BannerView()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
                            .padding(.bottom)
                    
                    /// category View
                    HStack(spacing: 12) {
                        // 7대자연 link
                        NavigationLink(destination: NatureMainView()) {
                            VStack(spacing: 0) {
                                Image("icNature")
                                    .frame(width: 62, height: 48)
                                   
                                Text("7대자연")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        
                        // 축제 link
                        NavigationLink(destination: FestivalMainView()) {
                            VStack(spacing: 0) {
                                Image("icFestival")
                                    .frame(width: 62, height: 48)
                                    
                                Text("축제")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(height: 65)
                
                        // 전통시장 link
                        NavigationLink(destination: ShopMainView()) {
                            VStack(spacing: 0) {
                                Image("icShop")
                                    .frame(width: 62, height: 48)
                       
                                Text("전통시장")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(height: 65)
                   
                        // 이색체험 link
                        NavigationLink(destination: ExperienceMainView()) {
                            VStack(spacing: 0) {
                                Image("icExp")
                                    .frame(width: 62, height: 48)
                                Text("이색 체험")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(height: 65)
                    
                        // 나나 Pick link
                        NavigationLink(destination: NanapickMainView()) {
                            VStack(spacing: 0) {
                                Image("icNana")
                                    .frame(width: 62, height: 48)
                                 
                                Text(String(localized: "nanaPick"))
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(height: 65)
                       
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.bottom, 5)
                
                    /// 광고 뷰
                    HStack {
                        AdvertisementView()
                            .background(.yellow)
                            .frame(height: (UIScreen.main.bounds.width - 40.0) * (80.0 / 328.0))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding(.bottom, 40)
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                    }
                    
                    HStack {
                        Text("감자마케터 님을 위한 도민 추천 🍊")
                            .font(.gothicNeo(size: 18, font: "bold"))
                        Spacer()
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 8)

                    HStack(spacing: 8) {
                        if let responseData = viewModel.recommendResponseData {
                            // 첫번째 추천 게시물
                            let firstItem = responseData.data[0]
                            // 두번째 추천 게시물
                            let secondItem = responseData.data[1]
                            VStack(alignment: .leading, spacing: 8) {
                                KFImage(URL(string: firstItem.thumbnailUrl)!)
                                    .resizable()
                                    .frame(height: (UIScreen.main.bounds.width - 40) / 2 * (118 / 160))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(firstItem.title)
                                    .font(.gothicNeo(size: 14, font: "bold"))
                                Text(firstItem.intro)
                                    .font(.gothicNeo(.medium, size: 12))
                                    .foregroundStyle(Color(.gray1))
                            }
                             
                            VStack(alignment: .leading, spacing: 8) {
                                KFImage(URL(string: secondItem.thumbnailUrl)!)
                                    .resizable()
                                    .frame(height: (UIScreen.main.bounds.width - 40) / 2 * (118 / 160))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                   
                                Text(secondItem.title)
                                    .font(.gothicNeo(size: 14, font: "bold"))
                                Text(secondItem.intro)
                                    .font(.gothicNeo(.medium, size: 12))
                                    .foregroundStyle(Color(.gray1))
                                   
                            }
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                }
            }
        }
		.environmentObject(searchVM)
        .onAppear {
             viewModel.recommendFetchData()
        }
        .introspect(.navigationStack, on: .iOS(.v16, .v17), customize: { navigation in
                    navigation.hidesBottomBarWhenPushed = true
                })
        
    }
}

struct AdvertisementView: View {
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = ""
    private let images: [String] = ["square", "circle", "triangle"]
    
    
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        TabView(selection: $selectedNum) {
           ForEach(images, id: \.self) { image in
                // image는 String이자, default tag로 붙는 값
               Image(systemName: image)
                    .scaledToFill()
                    
           }
        }
        .tabViewStyle(.page)
        .onReceive(timer, perform: { _ in
            withAnimation {
                // index값을 증가, 아니면 1
                // (selectedNum의 값을 변경해주기 위함)
                index = index < images.count ? index + 1 : 1
                // selectedNum 값은 images 배열의 element 값
                selectedNum = images[index - 1]
            }
        })
    }
}

struct BannerView: View {
    @ObservedObject var viewModel = HomeMainViewModel()
    
    init() {
        viewModel.bannerFetchData()
    }
    
    var message = ""
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = "icTabNumber1"
    private let images: [String] = ["icTabNumber1", "icTabNumber2", "icTabNumber3", "icTabNumber4"]
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        ZStack {
            TabView(selection: $selectedNum) {
                ForEach(images, id: \.self) { image in
                        // image는 String이자, default tag로 붙는 값
                        ZStack {
                            if let bannerResponseData = viewModel.bannerResponseData {
                                // 이미지데이터 API 데이터 부족
                                KFImage(URL(string: bannerResponseData.data[0].thumbnailUrl)!)
                                    .resizable()
                                    .frame(width: UIScreen.main.bounds.width, height: 180)
                            }
                        }
                        
                    }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onReceive(timer, perform: { _ in
                withAnimation {
                    // index값을 증가, 아니면 1
                    // (selectedNum의 값을 변경해주기 위함)
                    index = index < images.count ? index + 1 : 1
                    // selectedNum 값은 images 배열의 element 값
                    selectedNum = images[index - 1]
                }
            })
            HStack(spacing: 0) {
                Spacer()
                Image(selectedNum)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.trailing, 15)
            .padding(.top, 135)
        }
        
    }
}

#Preview {
    HomeMainView()
}
