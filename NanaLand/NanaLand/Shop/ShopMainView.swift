//
//  ShopMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher

struct ShopMainView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        
        VStack(spacing: 0) {
            NavigationBar(title: String(localized: "market"))
                .frame(height: 56)
                .padding(.bottom, 24)

            HStack(spacing: 0) {
                Text("2건")
                    .padding(.leading, 16)
                    .foregroundStyle(Color.gray1)
                
                Spacer()
                
                Menu {
                    Text("helo")
                } label: {
                    Text(String(localized: "region"))
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
            
            ShopMainGridView()
            
            Spacer()
        }
        .onAppear {
            appState.isTabViewHidden = true
        }
        .toolbar(.hidden)
        .toolbar(.hidden, for: .tabBar)
        .onDisappear {
            appState.isTabViewHidden = false
        }
    }

}
// 정보 담는 grid 뷰
struct ShopMainGridView: View {
    @StateObject var viewModel = ShopMainViewModel()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State private var isAPICalled = false
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                if isAPICalled {
                    ForEach((0...viewModel.state.getShopMainResponse.data.count-1), id: \.self) { index in
                        NavigationLink(destination: ShopDetailView(id: viewModel.state.getShopMainResponse.data[index].id)) {
                            VStack(alignment: .leading) {
                                
                                KFImage(URL(string: viewModel.state.getShopMainResponse.data[index].thumbnailUrl))
                                    .resizable()
                                    .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
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
    
}

#Preview {
    ShopMainView()
}
