//
//  NanapickMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI
import Kingfisher

struct NanapickMainView: View {
    @ObservedObject var viewModel = NaNaPickMainViewModel()
    @ObservedObject var detailViewModel = NaNaPickDetailViewModel()
    @State var isAPICalled = false
   
    @State private var page: Int = 0
    
    @State private var size: Int = 4
    init() {
        /// 네비게이션 바 스크롤 시에도 색상 변경 방지
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white // 네비게이션 바의 배경색을 원하는 색으로 설정
        appearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var backButton: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image("icLeft")
        }
    }
    
    var body: some View {
        Button("hello") {
            Task {
                await getNana(page: page, size: size)
            }
        }
        ScrollView {
            LazyVStack(spacing: 8) {
                // 데이터가 size 만큼 잘 도착 했으면 view 그리기
                ForEach(viewModel.state.getNaNaPickResponse.data, id: \.id) { index in
                        NavigationLink(destination: NaNaPickDetailView()) {
                            KFImage(URL(string:index.thumbnailUrl))
                                .resizable()
                                .frame(height: 200)
                        }
                }
                if page != 5 {
                    ProgressView()
                        .onAppear {
                                Task {
                                    await getNana(page: page, size: size)
                                    page += 1
                                    size = 1
                                    
                                }
                        }
                }
            }
        }
//        .onAppear {
//            Task {
//               await getNana(page: page, size: size)
//            }
//        }
        .navigationTitle(Text(String(localized: "nanaPick")))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    func getNana(page: Int, size: Int) async {
        
        await viewModel.action(.getNaNaPick(page: page, size: size))
       
    }
    
}

#Preview {
    NanapickMainView()
}
