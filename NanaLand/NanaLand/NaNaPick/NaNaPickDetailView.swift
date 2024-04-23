//
//  NaNaPickDetailView.swift
//  NanaLand
//
//  Created by jun on 4/19/24.
//

import SwiftUI
import Kingfisher

struct NaNaPickDetailView: View {
    @ObservedObject var viewModel = NaNaPickDetailViewModel()
    @State private var isAPICalled = false
    var id: Int64
    init(id: Int64) {
        self.id = id
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
        
        Button("상세 정보 보기") {
            Task {
                await getNaNaDetail(id: id)
            }
        }
        
        ScrollView {
            VStack(spacing: 0) {
                if isAPICalled {
                    KFImage(URL(string: viewModel.state.getNaNaPickDetailResponse.originUrl))
                        .resizable()
             
                    ForEach(viewModel.state.getNaNaPickDetailResponse.nanaDetails, id: \.number) { index in
                        
                        HStack(alignment: .bottom, spacing: 0) {
                            Text("\(index.number)")
                                .foregroundStyle(Color.main)
                                .font(.gothicNeo(.bold, size: 18))
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 28, height: 28)
                                        .shadow(radius: 4)
                                )
                                .padding(.leading, 24)
                                .padding(.trailing, 16)
                                
                            VStack {
                                Text("\(index.subTitle)")
                                    .foregroundStyle(Color.main)
                                Text("\(index.title)")
                            }
                            Spacer()
                        }
                        .padding(.bottom, 8)
                        
                        KFImage(URL(string: index.imageUrl))
                            .resizable()
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        
                        Text("\(index.content)")
                        
                        HStack(spacing: 0) {
                            Text("\(index.additionalInfoList[0].infoKey): ")
                            Text("\(index.additionalInfoList[0].infoValue)")
                        }
                        HStack(spacing: 0) {
                            Text("\(index.additionalInfoList[1].infoKey): ")
                            Text("\(index.additionalInfoList[1].infoValue)")
                        }
                        
                        HStack(spacing: 0) {
                            ForEach(index.hashtags, id: \.self) { hashtag in
                                Text("\(hashtag)")
                            }
                        }
                        .padding(.bottom, 48)
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        }
        // 탭 바 숨기기
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle(Text(String(localized: "nanaPick")))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear {
            Task {
                print(id)
                await getNaNaDetail(id: id)
                isAPICalled = true
                print("\(viewModel.state.getNaNaPickDetailResponse.originUrl)")
            }
        }
    }
    
    func getNaNaDetail(id: Int64) async {
        await viewModel.action(.getNaNaPickDetail(id: id))
    }
}

//#Preview {
//    NaNaPickDetailView()
//}
