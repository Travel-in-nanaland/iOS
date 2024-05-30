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
    @State private var isRecommendCalled = false
	var body: some View {
		ScrollView {
			VStack(spacing: 0) {
				HStack(spacing: 0) {
					Button(action: {
						
					}) {
						Image("icLogo")
						
					}
					.padding(.leading, 16)
					Spacer()
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.search)
					}, label: {
						Text("제주도는 지금 유채꽃 축제🏵️")
							.padding()
							.frame(width: 278, alignment: .leading)
							.font(.gothicNeo(size: 14, font: "mid"))
							.foregroundStyle(Color("Gray1"))
							.overlay(RoundedRectangle(cornerRadius: 30)
								.stroke(Color("Main"))
							)

					})
					
					Spacer()
					
					Button(action: {
						
					}) {
						Image("icBell")
					}
					.padding(.trailing, 16)
					
				}
				.padding(.bottom, 8)
				// banner View
				BannerView()
					.frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * (220 / 360))
					.padding(.bottom, 16)
				
				/// category View
				HStack(spacing: 0) {
					// 7대자연 link
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.nature)
					}, label: {
						VStack(spacing: 0) {
							Image("icNature")
								.frame(width: 62, height: 48)
							
							Text("7대자연")
								.font(.gothicNeo(size: 12, font: "semibold"))
								.tint(.black)
						}
					})
					.frame(height: 65)
             
					Spacer()
					// 축제 link
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.festival)
					}, label: {
						VStack(spacing: 0) {
							Image("icFestival")
								.frame(width: 62, height: 48)
							
							Text("축제")
								.font(.gothicNeo(size: 12, font: "semibold"))
								.tint(.black)
						}
					})
					.frame(height: 65)
					Spacer()
					// 전통시장 link
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.shop)
					}, label: {
						VStack(spacing: 0) {
							Image("icShop")
								.frame(width: 62, height: 48)
							
							Text("전통시장")
								.font(.gothicNeo(size: 12, font: "semibold"))
								.tint(.black)
						}
					})
					.frame(height: 65)
					Spacer()
					// 이색체험 link
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.experience)
					}, label: {
						VStack(spacing: 0) {
							Image("icExp")
								.frame(width: 62, height: 48)
							Text("이색 체험")
								.font(.gothicNeo(size: 12, font: "semibold"))
								.tint(.black)
						}
					})
					.frame(height: 65)
					Spacer()
					// 나나 Pick link
					Button(action: {
						AppState.shared.navigationPath.append(HomeViewType.nanapick)
					}, label: {
						VStack(spacing: 0) {
							Image("icNana")
								.frame(width: 62, height: 48)
							
							Text(String(localized: "nanaPick"))
								.font(.gothicNeo(size: 12, font: "semibold"))
								.tint(.black)
						}
					})
					.frame(height: 65)
				}
                .frame(width: UIScreen.main.bounds.width - 32)
				.padding(.bottom, 32)
                
				/// 광고 뷰
                HStack(spacing: 0) {
					AdvertisementView()
                        .frame(width: Constants.screenWidth, height: (UIScreen.main.bounds.width - 40.0) * (80.0 / 328.0))
						.padding(.bottom, 40)
                       
				}
				HStack {
					Text("감자마케터 님을 위한 도민 추천 🍊")
						.font(.gothicNeo(size: 18, font: "bold"))
					Spacer()
				}
				.padding(.leading, 16)
				.padding(.bottom, 8)
				
				HStack(spacing: 8) {
                    ForEach(viewModel.state.getRecommendResponse, id: \.id) { article in
                        switch article.category {
                        case "NATURE":
                            NavigationLink(destination: NatureDetailView(id: Int64(article.id))) {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                }
                            }
                        case "FESTIVAL":
                            NavigationLink(destination: FestivalDetailView(id: Int64(article.id))) {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                }
                            }
                        case "MARKET":
                            NavigationLink(destination: ShopDetailView(id: Int64(article.id))) {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                }
                            }
                        default:
                            NavigationLink(destination: ShopDetailView(id: Int64(article.id))) {
                                VStack(alignment: .leading, spacing: 8) {
                                    KFImage(URL(string: article.thumbnailUrl)!)
                                        .resizable()
                                        .frame(height: (Constants.screenWidth - 40) / 2 * (118 / 160))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                          
                                    Text(article.title)
                                        .font(.gothicNeo(size: 14, font: "bold"))
                                }
                            }
                        }
                        
                    }
				}
				.padding(.leading, 16)
				.padding(.trailing, 16)
			}
		}
        //safeArea 크기 가져아서 넣기
        .padding(.top, 1)
		.onAppear {
            Task {
                await getRecommendData()
                isRecommendCalled = true
            }
		}
		.navigationDestination(for: HomeViewType.self) { viewType in
			switch viewType {
			case .search:
				SearchMainView()
			case .nature:
                // 광고 클릭으로 들어간게 아닐경우
				NatureMainView(isAdvertisement: false)
			case .festival:
				FestivalMainView()
			case .shop:
				ShopMainView()
			case .experience:
				ExperienceMainView()
			case .nanapick:
				NanapickMainView()
			}
		}
	}
    
    func getRecommendData() async {
        await viewModel.action(.getRecommendItem)
    }
    
}

struct AdvertisementView: View {
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = ""
    private let images: [String] = ["ad1", "ad2", "ad3", "ad4"]
    
    
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        TabView(selection: $selectedNum) {
           ForEach(images, id: \.self) { image in
                // image는 String이자, default tag로 붙는 값
               HStack(spacing: 0) {
                   Button(action: {
                       switch image {
                       case "ad1":
                           AppState.shared.navigationPath.append(AdvertisementViewType.ad1)
                       case "ad2":
                           AppState.shared.navigationPath.append(AdvertisementViewType.ad2)
                       case "ad3":
                           AppState.shared.navigationPath.append(AdvertisementViewType.ad3)
                       case "ad4":
                           AppState.shared.navigationPath.append(AdvertisementViewType.ad4)
                       default:
                           break
                       }
                   }, label: {
                       VStack(alignment: .leading, spacing: 0) {
                           switch image {
                           case "ad1":
                               HStack(spacing: 0){
                                   VStack(alignment: .leading, spacing: 0) {
                                       Text("제주도에서 예쁜 바다 보고 싶다고?")
                                           .font(.gothicNeo(.bold, size: 16))
                                           .padding(.leading, 16)
                                       Text("서귀포시 성산의 자연으로 투어해보자!")
                                           .font(.gothicNeo(.medium, size: 12))
                                           .padding(.leading, 16)
                                   }
                                   Spacer()
                                   Image(image)
                                       .padding(.trailing, 15)
                               }
                               .frame(width: Constants.screenWidth, height: 80)
                               .background(.skyBlue)
                           case "ad2":
                               HStack(spacing: 0) {
                                   VStack(alignment: .leading, spacing: 0) {
                                       Text("보기 귀한 별 보러 가지 않을래?💫")
                                           .font(.gothicNeo(.bold, size: 16))
                                           .padding(.leading, 16)
                                       Text("애월의 감성 가득 오름들 확인😯")
                                           .font(.gothicNeo(.medium, size: 12))
                                           .padding(.leading, 16)
                                   }
                                   Spacer()
                                   Image(image)
                                       .padding(.trailing, 15)
                               }
                               .frame(width: Constants.screenWidth, height: 80)
                               .background(.main50P)
                               
                               
                           case "ad3":
                               HStack(spacing: 0) {
                                   VStack(alignment: .leading, spacing: 0) {
                                       Text("한국의 정감을 느끼고 싶다면, 시장이지!")
                                           .font(.gothicNeo(.bold, size: 16))
                                           .padding(.leading, 16)
                                       Text("아직도 남은 전통 시장들은 뭐가 있을까?")
                                           .font(.gothicNeo(.medium, size: 12))
                                           .padding(.leading, 16)
                                   }
                                   Spacer()
                                   Image(image)
                                       .padding(.trailing, 15)
                               }
                               .frame(width: Constants.screenWidth, height: 80)
                               .background(Color.init(hex: 0xF7C2BC))
                               
                               
                               
                           case "ad4":
                               HStack(spacing: 0){
                                   VStack(alignment: .leading, spacing: 0) {
                                       Text("제주도에서만 여는 7월 축제🎈")
                                           .font(.gothicNeo(.bold, size: 16))
                                           .padding(.leading, 16)
                                       Text("세계의 보물, 제주도가 가득 느껴지는 축제 보러가자")
                                           .font(.gothicNeo(.medium, size: 12))
                                           .padding(.leading, 16)
                                   }
                                   Spacer()
                                   Image(image)
                                       .padding(.trailing, 15)
                               }
                               .frame(width: Constants.screenWidth, height: 80)
                               .background(Color.init(hex: 0xFFBC11))
                               
                              
                           default:
                               Text("제주도에서 예쁜 바다 보고 싶다고?")
                                   .font(.gothicNeo(.bold, size: 16))
                               Text("서귀포시 성산의 자연으로 투어해보자!")
                                   .font(.gothicNeo(.medium, size: 12))
                           }
                           
                       }
                       .frame(width: Constants.screenWidth)
                       
                   })
                   
               }
               .frame(width: Constants.screenWidth, height: 80)
               
                   
           }
        }
        .navigationDestination(for: AdvertisementViewType.self) { viewType in
            switch viewType {
            case .ad1:
                // 광고 클릭으로 들어간 경우
                NatureMainView(isAdvertisement: true)
            case .ad2:
                NatureMainView()
            case .ad3:
                ShopMainView()
            case .ad4:
                FestivalMainView()
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

enum AdvertisementViewType {
    case ad1
    case ad2
    case ad3
    case ad4
}

struct BannerView: View {
    @StateObject var viewModel = HomeMainViewModel()
    
   @State private var isBannerCalled = false
    
    var message = ""
    private let timer = Timer.publish(every: 3.5, on: .main, in: .common).autoconnect()
    @State private var index = 1
    // tabView에 selection에 바인딩 할 값
    // (images가 ForEach문에서 돌면서 나오는 element 값이 String이므로 타입을 String으로 해준다.)
    @State private var selectedNum: String = "icTabNumber1"
    private let images: [String] = ["icTabNumber1", "icTabNumber2", "icTabNumber3", "icTabNumber4"]
    
    var body: some View {
        // selection에 index가 아닌 selectedNum을 바인딩
        ZStack {
            TabView(selection: $selectedNum) {
               
                        // image는 String이자, default tag로 붙는 값
                        ZStack {
                            if isBannerCalled {
                                KFImage(URL(string: viewModel.state.getBannerResponse[index - 1].thumbnailUrl)!)
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main
                                            .bounds.width * (220 / 360))
                                
                            }
                            VStack(spacing: 0) {
                                
                                HStack(spacing: 0) {
                                    Spacer()
                                    Text(viewModel.state.getBannerResponse[index - 1].version)
                                        .font(.caption01)
                                        .foregroundStyle(.white)
                                        .padding(.trailing, 16)
                                }
                                .padding(.top, 8)
                                
                                Spacer()
                                HStack(spacing: 0) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(viewModel.state.getBannerResponse[index - 1].subHeading)
                                            .font(.body_bold)
                                            .foregroundStyle(.white)
                                        Text(viewModel.state.getBannerResponse[index - 1].heading)
                                            .font(.largeTitle02)
                                            .foregroundStyle(.white)
                                    }
                                    Spacer()
                                }
                                .padding(.leading, 16)
                                .padding(.bottom, 16)
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main
                            .bounds.width * (220 / 360))
                        
                    
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
            VStack(spacing: 0) {
                Spacer()
                HStack(spacing: 0) {
                    Spacer()
                    Image(selectedNum)
                }
                .frame(width: UIScreen.main.bounds.width)
                .padding(.trailing, 15)
               
            }
            .padding(.bottom, 16)
            
        }
        .frame(width: Constants.screenWidth, height: Constants.screenWidth * (220 / 360))
        .onAppear {
            Task {
                await getBannerData()
                isBannerCalled = true
                
            }
        }
        
    }
    
    func getBannerData() async {
        return await viewModel.action(.getBannerItem)
    }
}

#Preview {
    HomeMainView()
}
