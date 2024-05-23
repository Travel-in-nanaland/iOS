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
    
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationBar(title: "7대자연")
                .frame(height: 56)
                .padding(.bottom, 24)

            
            
            NatureMainGridView()
            
            Spacer()
        }
        .toolbar(.hidden)

    }
}

struct NatureMainGridView: View {
    @StateObject var viewModel = NatureMainViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var isAPICalled = false
    var body: some View {
        HStack(spacing: 0) {
            Text("\(viewModel.state.getNatureMainResponse.data.count)건")
                .padding(.leading, 16)
                .foregroundStyle(Color.gray1)
            Spacer()
            
            Menu {
                Text("helo")
            } label: {
                Text(String(localized: "지역"))
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
                    .strokeBorder(Color.gray1, lineWidth: 1)
            )
            .padding(.trailing, 16)

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
            Task {
                await getNatureMainItem(page: 0, size:18, filterName:"")
                isAPICalled = true
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
