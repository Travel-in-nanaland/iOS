//
//  HomeMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import Kingfisher

struct HomeMainView: View {
    @ObservedObject var viewModel = HomeMainViewModel()
	@ObservedObject var searchVM = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            print("button1")
                        }) {
                            Image("icLogo")
                                .padding(.leading, 16)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SearchMainView()) {
                           Text("제주도는 지금 유채꽃 축제🏵️")
                                .frame(width: 240, alignment: .leading)
                                .font(.gothicNeo(size: 14, font: "mid"))
                                .foregroundStyle(Color("Gray1"))
                                .padding()
                                .overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color("Main"))
                                    .frame(width: 278)
                                )
                        }
                        Spacer()
                     
                        Button(action: {
                            print("alarm")
                        }) {
                            Image("ic")
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.bottom, 16)
                    
                    if let bannerResponseData = viewModel.bannerResponseData {
                        BannerView(message: bannerResponseData.message)
                            .frame(height: 180)
                            .background(.orange)
                            .padding(.bottom)
                    }
               
                    
                    /// banner View
                    
                        
                    /// category View
                    HStack(spacing: 12) {
                        // 7대자연 link
                        NavigationLink(destination: NatureMainView()) {
                            VStack{
                                Image("icNature")
                                    .frame(width: 46, height: 26.93)
                                   
                                Text("7대자연")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(width: 62, height: 65)
                
                        // 축제 link
                        NavigationLink(destination: FestivalMainView()) {
                            VStack{
                                Image("icFestival")
                                    .frame(width: 46, height: 26.93)
                                    
                                Text("축제")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(width: 62, height: 65)
                        
                        // 전통시장 link
                        NavigationLink(destination: ShopMainView()) {
                            VStack{
                                Image("icShop")
                                    .frame(width: 46, height: 26.93)
                       
                                Text("전통시장")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(width: 62, height: 65)
            
                        // 이색체험 link
                        NavigationLink(destination: ExperienceMainView()) {
                            VStack{
                                Image("icExp")
                                    .frame(width: 46, height: 26.93)
                                Text("이색 체험")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(width: 62, height: 65)
                  
                        // 나나 Pick link
                        NavigationLink(destination: NanapickMainView()) {
                            VStack{
                                Image("icNana")
                                    .frame(width: 46, height: 26.93)
                                 
                                Text("나나 Pick")
                                    .font(.gothicNeo(size: 12, font: "semibold"))
                                    .tint(.black)
                            }
                        }
                        .frame(width: 62, height: 65)
                    }
                    .padding(.bottom, 5)
                    /// 광고 뷰
                    AdvertisementView()
                        .background(.yellow)
                        .frame(height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.bottom, 40)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    HStack {
                        Text("감자마케터 님을 위한 도민 추천 🍊")
                            .font(.gothicNeo(size: 18, font: "bold"))
                            .padding(.leading, 16)
                        Spacer()
                    }
                    HStack {
                        if let responseData = viewModel.recommendResponseData {
                            // 첫번째 추천 게시물
                            let firstItem = responseData.data[0]
                            // 두번째 추천 게시물
                            let secondItem = responseData.data[1]
                            VStack {
                                KFImage(URL(string: firstItem.thumbnailUrl)!)
                                    .resizable()
                                    .frame(width: 175, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                Text(firstItem.title)
                                    .font(.gothicNeo(size: 14, font: "bold"))
                            }
                                
                            Spacer()
                             
                            VStack {
                                KFImage(URL(string: secondItem.thumbnailUrl)!)
                                    .resizable()
                                    .frame(width: 175, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.trailing, 16)
                                Text(secondItem.title)
                                    .font(.gothicNeo(size: 14, font: "bold"))
                            }
                            
                        }
                    }
                    .padding(.leading, 16)
                }
                .padding(.top)
                
            }
            .padding(.top)
        }
		.environmentObject(searchVM)
        .onAppear {
            viewModel.recommendFetchData()
            viewModel.bannerFetchData()
          
        }
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
    var message = ""
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = ""
    private let images: [String] = ["icTabNumber1", "icTabNumber2", "icTabNumber3", "icTabNumber4"]
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        TabView(selection: $selectedNum) {
            ForEach(images, id: \.self) { image in
                // image는 String이자, default tag로 붙는 값
                VStack {
                    Text(message)
                    Spacer()
                    Image(image)
                        .scaledToFill()
                        .padding(.bottom, 16)
                    
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
    }
}

#Preview {
    HomeMainView()
}
