//
//  NatureMainView.swift
//  NanaLand
//
//  Created by jun on 5/19/24.
//

import SwiftUI
import Kingfisher

struct NatureMainView: View {
    @EnvironmentObject var appState: AppState
    @State var isAdvertisement = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationBar(title: "7대자연")
                .frame(height: 56)
                .padding(.bottom, 24)

            
            
            NatureMainGridView(isAdvertisement: isAdvertisement)
            
            Spacer()
        }
        .toolbar(.hidden)

    }
}

struct NatureMainGridView: View {
    @State var isAdvertisement = false
    @StateObject var viewModel = NatureMainViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var isAPICalled = false
    @State private var filterTitle = "지역"
    @State private var locationModal = false
    @State private var location = "전 지역"
    
    var body: some View {
        HStack(spacing: 0) {
            Text("\(viewModel.state.getNatureMainResponse.data.count)건")
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
                .frame(maxWidth: 100)
            }
            .foregroundStyle(Color.gray1)
            .frame(maxHeight: 40)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.gray1, lineWidth: 1)
                    .frame(maxWidth: 100, maxHeight: 40)
            )
            .padding(.trailing, 16)
            .sheet(isPresented: $locationModal) {
                LocationModalView(viewModel: FestivalMainViewModel(), natureViewModel: viewModel, shopViewModel: ShopMainViewModel(), location: $location, isModalShown: $locationModal, startDate: "", endDate: "", title: "7대자연")
                    .presentationDetents([.height(Constants.screenWidth * (63 / 36))])
            }

        }
        .padding(.bottom, 16)
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if isAPICalled {
                    ForEach((0...viewModel.state.getNatureMainResponse.data.count-1), id: \.self) { index in
                        NavigationLink(destination: NatureDetailView(id: viewModel.state.getNatureMainResponse.data[index].id)) {
                            VStack(alignment: .leading) {
                                ZStack {
                                    KFImage(URL(string: viewModel.state.getNatureMainResponse.data[index].thumbnailUrl))
                                        .resizable()
                                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack {
                                        HStack {
                                            Spacer()
                                            
                                            Button {
                                                Task {
                                                    await toggleFavorite(body: FavoriteToggleRequest(id: Int(viewModel.state.getNatureMainResponse.data[index].id), category: .nature), index: index)
                                                }
                                              
                                            } label: {
                                                viewModel.state.getNatureMainResponse.data[index].favorite ? Image("icHeartFillMain") : Image("icHeart")
                                            }
                                        }
                                        .padding(.top, 8)
                                        Spacer()
                                    }
                                    .padding(.trailing, 8)
                                }
                                
                                
                                Spacer()
                                
                                Text("\(viewModel.state.getNatureMainResponse.data[index].title)")
                                    .font(.gothicNeo(.bold, size: 14))
                                    .foregroundStyle(.black)
                                    .lineLimit(1)
                                
                                Spacer()
                                Text("\(viewModel.state.getNatureMainResponse.data[index].addressTag)")
                                    .frame(width:64, height: 20)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundStyle(Color.main10P)
                                    )
                                    .font(.gothicNeo(.regular, size: 12))
                                    .foregroundStyle(Color.main)
                            }
                            
                            .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 196)
                            
                            .padding(.leading, 0)
                        }
                        
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        }
        .onAppear {
            print(isAdvertisement)
            
            Task {
                if isAdvertisement {
                    await getNatureMainItem(page: 0, size:18, filterName:"성산")
                    location = "성산"
                    isAPICalled = true
                    isAdvertisement = false
                    
                } else {
                    if location == "전 지역" {
                        await getNatureMainItem(page: 0, size:18, filterName:"")
                        isAPICalled = true
                    } else {
                        await getNatureMainItem(page: 0, size: 18, filterName: location)
                        isAPICalled = true
                    }
                    
                }
                
                
            }
        }
    }
    
    func getNatureMainItem(page: Int64, size: Int64, filterName: String) async {
        await viewModel.action(.getNatureMainItem(page: page, size: size, filterName: filterName))
    }
    
    func toggleFavorite(body: FavoriteToggleRequest, index: Int) async {
        await viewModel.action(.toggleFavorite(body: body, index: index))
    }
}

#Preview {
    NatureMainView()
}
