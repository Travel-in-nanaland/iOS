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
    init() {
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
        ScrollView {
            VStack(spacing: 0) {
                if isAPICalled {
                    KFImage(URL(string: viewModel.state.getNaNaPickDetatilResponse.originUrl))
                    VStack {
                        ForEach(viewModel.state.getNaNaPickDetatilResponse.nanaDetails, id: \.number) { index in
                            
                            Text("\(index.title)")
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                
            }
        }
        .onAppear {
            Task {
                await getNaNaDetail(id: 1)
            }
        }
        .navigationTitle(Text(String(localized: "nanaPick")))
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onReceive(viewModel.$state) { newState in
            isAPICalled = true
            if isAPICalled {
                print(newState.getNaNaPickDetatilResponse.originUrl + "입니다.")
            }
           
        }
        
    }
    
    func getNaNaDetail(id: Int64) async {
        await viewModel.action(.getNaNaPickDetail(id: id))
    }
}

#Preview {
    NaNaPickDetailView()
}
