//
//  ShopMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ShopMainView: View {
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationBar(title: String(localized: "market"))
                .frame(height: 56)
                .padding(.bottom, 24)

            
            
            ShopMainGridView()
            
            Spacer()
        }
        .toolbar(.hidden)

    }

}
// 정보 담는 grid 뷰
struct ShopMainGridView: View {
    @StateObject var viewModel = ShopMainViewModel()
    @State private var locationModal = false
    @State private var location = "전 지역"
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var isAPICalled = false
    var body: some View {
		VStack(spacing: 0) {
			HStack(spacing: 0) {
				Text("\(viewModel.state.getShopMainResponse.data.count)건")
					.padding(.leading, 16)
					.foregroundStyle(Color.gray1)
				
				Spacer()
				
				Button {
                    self.locationModal = true
				} label: {
                    HStack(spacing: 0) {
                        Text(location)
                            .lineLimit(1)
                            .font(.gothicNeo(.medium, size: 12))
                            .padding(.leading, 12)
                            .padding(.trailing, 4)
                        Image("icDownSmall")
                            .padding(.trailing, 12)
                    }
					
				}
				.foregroundStyle(Color.gray1)
				.frame(width: 100, height: 40)
				.background(
					RoundedRectangle(cornerRadius: 30)
						.strokeBorder(Color.gray1, lineWidth: 1)
				)
				.padding(.trailing, 16)
                    .sheet(isPresented: $locationModal) {
                    LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: NatureMainViewModel(), shopViewModel: viewModel, location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: "전통시장")
                        .presentationDetents([.height(Constants.screenWidth * (63 / 36))])
                }
			}
			.padding(.bottom, 16)
			ScrollView {
                if isAPICalled {
                    if viewModel.state.getShopMainResponse.data.count == 0 {
                        FestivalNoResultView()
                            .frame(height: 70)
                            .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                        
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            
                                ForEach((0...viewModel.state.getShopMainResponse.data.count-1), id: \.self) { index in
                                    Button(action: {
                                        AppState.shared.navigationPath.append(ArticleViewType.detail(id: viewModel.state.getShopMainResponse.data[index].id))
                                    }, label: {
                                        VStack(alignment: .leading) {
                                            ZStack {
                                                KFImage(URL(string: viewModel.state.getShopMainResponse.data[index].thumbnailUrl))
                                                    .resizable()
                                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                VStack {
                                                    HStack {
                                                        Spacer()
                                                        
                                                        Button {
                                                            Task {
                                                                await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getShopMainResponse.data[index].id), category: .market), index: index)
                                                            }
                                                            
                                                        } label: {
                                                            viewModel.state.getShopMainResponse.data[index].favorite ? Image("icHeartFillMain") : Image("icHeart")
                                                        }
                                                    }
                                                    .padding(.top, 8)
                                                    Spacer()
                                                }
                                                .padding(.trailing, 8)
                                            }
                                            
                                            
                                            Spacer()
                                            
                                            Text("\(viewModel.state.getShopMainResponse.data[index].title)")
                                                .font(.gothicNeo(.bold, size: 14))
                                                .foregroundStyle(.black)
                                                .lineLimit(1)
                                            
                                            Spacer()
                                            Text("\(viewModel.state.getShopMainResponse.data[index].addressTag)")
                                                .frame(width:64, height: 20)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .foregroundStyle(Color.main10P)
                                                )
                                                .font(.gothicNeo(.regular, size: 12))
                                                .foregroundStyle(Color.main)
                                        }
                                        
                                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 196)
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
				ShopDetailView(id: id)
			case let .reportInfo(id, category):
				ReportInfoMainView(id: id, category: category)
			}
		}
        .onAppear {
            Task {
                await getShopMainItem(page: 0, size:18, filterName:"")
                isAPICalled = true
            }
        }
			
    }
    
    
    func getShopMainItem(page: Int64, size: Int64, filterName: String) async {
        await viewModel.action(.getShopMainItem(page: page, size: size, filterName: filterName))
    }
    // 스크롤이 맨 아래에 도달 했는지 여부
    private var isAtBottom: Bool {
        let scrollView = UIScrollView.appearance()
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        return offsetY > contentHeight - height
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
    ShopMainView()
}
