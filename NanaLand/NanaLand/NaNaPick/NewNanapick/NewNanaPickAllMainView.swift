//
//  NewNanaPickAllMainView.swift
//  NanaLand
//
//  Created by wodnd on 8/23/24.
//

import SwiftUI
import Kingfisher

struct NewNanaPickAllMainView: View {
    
    @State var viewModel = NewNanaPickMainViewModel()
    var layout: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    @State var isAPICalled = false
    
    var body: some View {
        VStack(spacing: 0){
            NanaNavigationBar(title: .nanaPick, showBackButton: true)
                .frame(height: 56)
            
            ScrollView {
                if isAPICalled {
                    LazyVGrid(columns: layout) {
                        ForEach(viewModel.state.getNanaPickGridResponse.data, id: \.id) { item in
                            
                            Button(action: {
                                AppState.shared.navigationPath.append(NewNanaPickAllType.detail(id: item.id))
                            }, label: {
                                NanaPickAllView(imageUrl: item.firstImage.originUrl, version: item.version, subHeading: item.subHeading, newest: item.newest)
                            }
                            )
                            
                            if viewModel.state.page < viewModel.state.getNanaPickGridResponse.totalElements / 12 {
                                ProgressView()
                                    .onAppear {
                                        print("\(viewModel.state.page)")
                                        Task {
                                            await getNanaPickGridList(page: viewModel.state.page + 1, size: 12)
                                        }
                                        
                                        viewModel.state.page += 1
                                    }
                            }
                        }
                        .padding(.top, 24)
                    }
                    .padding(.top, 20)
                    .padding(.leading, Constants.screenWidth * 0.03)
                    .padding(.trailing, Constants.screenWidth * 0.03)
                }
            }
        }
        .toolbar(.hidden)
        .navigationDestination(for: NewNanaPickAllType.self) { nana in
            switch nana {
            case let .detail(id):
                NewNanaPickDetailView(id: id)
            }
        }
        .onAppear(){
            Task{
                await getNanaPickGridList(page: 0, size: 12)
                isAPICalled = true
            }
        }
    }
    
    func getNanaPickGridList(page: Int, size: Int) async {
        await viewModel.action(.getNanaPickGridList(page: page, size: size))
    }
    
    // 픽셀 값을 포인트로 변환하는 함수
    func pxToPoints(_ px: CGFloat) -> CGFloat {
        return px / UIScreen.main.scale
    }
}

struct NanaPickAllView: View {

    var imageUrl: String
    var version: String
    var subHeading: String
    var newest: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: 140, height: 180)
                .clipped()
                .background(.blue)
                .overlay(){
                    VStack(spacing: 0){
                        HStack(spacing: 0){
                            
                            if newest {
                                RoundedRectangle(cornerRadius: 15)
                                    .frame(width: 36, height: 18)
                                    .foregroundColor(.main)
                                    .overlay(){
                                        Text("NEW")
                                            .font(.caption02_semibold)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                            }
                        
                            Spacer()
                        }
                        
                        Spacer()

                    }
                }
            
            HStack(spacing: 0){
                
                VStack(alignment: .leading, spacing: 0){
                    Text(subHeading)
                        .lineLimit(1)
                        .font(.body02_bold)
                        .foregroundColor(.black)
                    
                    Text(version)
                        .font(.caption02)
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.top, 2)
                }
                
                Spacer()
            }
            .padding(.top, 5)
        }
        .frame(width: 140)
    }
}

enum NewNanaPickAllType: Hashable {
    case detail(id: Int64)
}


#Preview {
    NewNanaPickAllMainView()
}
