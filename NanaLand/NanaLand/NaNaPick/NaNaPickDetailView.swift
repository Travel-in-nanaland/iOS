//
//  NaNaPickDetailView.swift
//  NanaLand
//
//  Created by jun on 4/19/24.
//

import SwiftUI
import Kingfisher

struct NaNaPickDetailView: View {
    @StateObject var viewModel = NaNaPickDetailViewModel()
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
        VStack(spacing: 0) {
            NanaNavigationBar(title: .nanaPick, showBackButton: true)
                .frame(height: 56)
            ScrollView {
                VStack(spacing: 0) {
                    if isAPICalled {
                        
                        KFImage(URL(string: viewModel.state.getNaNaPickDetailResponse.originUrl))
                            .resizable()
                            .frame(width: Constants.screenWidth, height: Constants.screenWidth * (237 / 360))
                            .padding(.bottom, 16)
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.main10P)
                                .frame(maxWidth: Constants.screenWidth - 40)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(alignment: .center, spacing: 0) {
                                    Image("icWarningCircle")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundStyle(.main)
                                        .frame(width:24, height: 24)
                                    Text(.notificate)
                                        .font(.body02_bold)
                                        .foregroundStyle(Color.main)
                                    Spacer()
                                }
                                .padding(.leading, 32)
                                .padding(.trailing, 16)
                                .padding(.bottom, 4)
                                .padding(.top, 16)
                            
                                Text(viewModel.state.getNaNaPickDetailResponse.notice)
                                    .padding(.leading, 32)
                                    .padding(.trailing, 32)
                                    .padding(.bottom, 16)
                                    .font(.gothicNeo(.regular, size: 14))
                                Spacer()
                            }
                        }
                        .padding(.bottom, 48)
                        
                        ForEach(viewModel.state.getNaNaPickDetailResponse.nanaDetails, id: \.number) { index in
                            
                            HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                   
                                    HStack(alignment: .bottom) {
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
                                        VStack(alignment:.leading, spacing: 0) {
                                            Text("\(index.subTitle)")
                                                .foregroundStyle(Color.main)
                                                .font(.caption01)
                                            Text("\(index.title)")
                                                .font(.title01_bold)
                                        }
                                        
                                    }
                                    
                                }
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            
                            KFImage(URL(string: index.imageUrl))
                                .resizable()
                                .frame(height: (Constants.screenWidth - 32) * ( 176 / 328))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                                .padding(.bottom, 16)
                                
                            Text("\(index.content)")
                                .frame(width: (Constants.screenWidth - 32))
                                .font(.body01)
                                .padding(.bottom, 24)
                            
                            HStack(spacing: 0) {
                                if index.additionalInfoList[0].infoEmoji == "ADDRESS" {
                                    Image("icPin")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 4)
                                        
                                } else if index.additionalInfoList[0].infoEmoji == "PARKING" {
                                    Image("icCar")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 4)
                                }
                               
                                Text("\(index.additionalInfoList[0].infoKey): ")
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Text("\(index.additionalInfoList[0].infoValue)")
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            HStack(spacing: 0) {
                                if index.additionalInfoList[1].infoEmoji == "ADDRESS" {
                                    Image("icPin")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 4)
                                } else if index.additionalInfoList[1].infoEmoji == "PARKING" {
                                    Image("icCar")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 4)
                                }
                                Text("\(index.additionalInfoList[1].infoKey): ")
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Text("\(index.additionalInfoList[1].infoValue)")
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 8)
                            
                            HStack(spacing: 14) {
                                ForEach(index.hashtags, id: \.self) { hashtag in
                                    HStack(spacing: 0) {
                                        Text("\(hashtag)")
                                            .padding(.leading, 16)
                                            .padding(.trailing, 16)
                                            .font(.body02)
                                            .frame(minWidth: 49, minHeight: 32)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .foregroundStyle(Color.main10P)
                                                
                                            )
                                            .foregroundStyle(Color.main)
                                    }
                                    
                                }
                              Spacer()
                            }
                            .padding(.leading, 16)
                            .padding(.bottom, 48)
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
        }
        // 탭 바 숨기기
        .toolbar(.hidden)
        .onAppear {
            Task {
                await getNaNaDetail(id: id)
                isAPICalled = true
                
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
