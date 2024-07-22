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
            ZStack {
                ScrollViewReader { proxyReader in
                    ScrollView {
                        VStack(spacing: 0) {
                            if isAPICalled {
                                
                                KFImage(URL(string: viewModel.state.getNaNaPickDetailResponse.originUrl))
                                    .resizable()
                                    .frame(width: Constants.screenWidth, height: Constants.screenWidth * (237 / 360))
                                    .padding(.bottom, 16)
                                if viewModel.state.getNaNaPickDetailResponse.notice != nil {
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
                                        
                                            Text(viewModel.state.getNaNaPickDetailResponse.notice ?? "")
                                                .padding(.leading, 32)
                                                .padding(.trailing, 32)
                                                .padding(.bottom, 16)
                                                .font(.gothicNeo(.regular, size: 14))
                                            Spacer()
                                        }
                                    }
                                    .padding(.bottom, 48)
                                }
                                
                                
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
                                        .lineSpacing(10)
                                        .padding(.bottom, 24)
                                    
                                    ForEach(index.additionalInfoList, id: \.infoKey) { data in
                                        HStack(alignment: .top, spacing: 0) {
                                            if data.infoEmoji == "ADDRESS" {
                                                Image("icPin")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "PARKING" {
                                                Image("icCar")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "SPECIAL" {
                                                Image("icSpecial")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "AMENITY" {
                                                Image("icAmenity")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "WEBSITE" {
                                                Image("icHomepage")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "RESERVATION_LINK" {
                                                Image("icReservation")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            }else if data.infoEmoji == "AGE" {
                                                Image("icAge")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "TIME" {
                                                Image("icClock")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "FEE" {
                                                Image("icFee")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "DATE" {
                                                Image("icDate")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else if data.infoEmoji == "DESCRIPTION" {
                                                Image("icDescription")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            } else {
                                                Image("icPhone")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                            }
                                            Text("\(data.infoKey): ")
                                                .font(.body02)
                                                .foregroundStyle(.gray1)
                                            if data.infoKey == "홈페이지" || data.infoKey == "예약링크" {
                                                Link(destination: URL(string: "\(data.infoValue)")!, label: {
                                                    Text("\(data.infoValue)")
                                                        .font(.body02)
                                                        .foregroundStyle(.gray1)
                                                })
                                            } else {
                                                Text("\(data.infoValue)")
                                                    .font(.body02)
                                                    .foregroundStyle(.gray1)
                                            }
                                            Spacer()
                                        }
                                        .padding(.leading, 16)
                                    }
                                
        //                           HStack(spacing: 0) {
        //
        //                                if index.additionalInfoList[0].infoEmoji == "ADDRESS" {
        //                                    Image("icPin")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //
        //                                } else if index.additionalInfoList[0].infoEmoji == "PARKING" {
        //                                    Image("icCar")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "SPECIAL" {
        //                                    Image("icSpecial")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "AMENITY" {
        //                                    Image("icAmenity")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "WEBSITE" {
        //                                    Image("icHomepage")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "RESERVATION_LINK" {
        //                                    Image("icReservation")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "AGE" {
        //                                    Image("icAge")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "TIME" {
        //                                    Image("icClock")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "FEE" {
        //                                    Image("icFee")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "DATE" {
        //                                    Image("icDate")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[0].infoEmoji == "DESCRIPTION" {
        //                                    Image("icDescription")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else {
        //                                    Image("icPhone")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                }
                                     
        //                                    Text("\(index.additionalInfoList[0].infoKey): ")
        //                                        .font(.body02)
        //                                        .foregroundStyle(.gray1)
        //
        //
        //                                if index.additionalInfoList[0].infoKey == "홈페이지" || index.additionalInfoList[0].infoKey == "예약링크" {
        //                                    Link(destination: URL(string: "\(index.additionalInfoList[0].infoValue)")!, label: {
        //                                        Text("\(index.additionalInfoList[0].infoValue)")
        //                                            .font(.body02)
        //                                            .foregroundStyle(.gray1)
        //                                    })
        //                                } else {
        //                                    Text("\(index.additionalInfoList[0].infoValue)")
        //                                        .font(.body02)
        //                                        .foregroundStyle(.gray1)
        //                                }
        //
        //                                Spacer()
        //                            }
        //                            .padding(.leading, 16)
        //                            HStack(spacing: 0) {
        //                                if index.additionalInfoList[1].infoEmoji == "ADDRESS" {
        //                                    Image("icPin")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //
        //                                } else if index.additionalInfoList[1].infoEmoji == "PARKING" {
        //                                    Image("icCar")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "SPECIAL" {
        //                                    Image("icSpecial")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "AMENITY" {
        //                                    Image("icAmenity")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "WEBSITE" {
        //                                    Image("icHomepage")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "RESERVATION_LINK" {
        //                                    Image("icReservation")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "AGE" {
        //                                    Image("icAge")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "TIME" {
        //                                    Image("icClock")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "FEE" {
        //                                    Image("icFee")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "DATE" {
        //                                    Image("icDate")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else if index.additionalInfoList[1].infoEmoji == "DESCRIPTION" {
        //                                    Image("icDescription")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                } else {
        //                                    Image("icPhone")
        //                                        .resizable()
        //                                        .frame(width: 20, height: 20)
        //                                        .padding(.trailing, 4)
        //                                }
        //
        //                                    Text("\(index.additionalInfoList[1].infoKey): ")
        //                                        .font(.body02)
        //                                        .foregroundStyle(.gray1)
        //                                    if index.additionalInfoList[1].infoKey == "홈페이지" || index.additionalInfoList[1].infoKey == "예약링크" {
        //                                        Link(destination: URL(string: "\(index.additionalInfoList[1].infoValue)")!, label: {
        //                                            Text("\(index.additionalInfoList[1].infoValue)")
        //                                                .font(.body02)
        //                                                .foregroundStyle(.gray1)
        //                                        })
        //                                    } else{
        //                                        Text("\(index.additionalInfoList[1].infoValue)")
        //                                            .font(.body02)
        //                                            .foregroundStyle(.gray1)
        //                                    }
        //
        //                                Spacer()
        //                            }
        //                            .padding(.leading, 16)
        //                            .padding(.bottom, 8)
        //
                                    
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
                        .id("Scroll_To_Top")
                        // 스크롤 뷰 의 하위 뷰에다가 id 적어줘야 함.
                    }
                  
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                      // 10. withAnimation 과함께 함수 작성
                                    print("upup")
                                      withAnimation(.default) {
                                          // ScrollViewReader의 proxyReader을 넣어줌
                                          proxyReader.scrollTo("Scroll_To_Top", anchor: .top) // scroll id 추가!
                                      }
                                      
                                  }, label: {
                                       Image("icScrollToTop")
                                      
                                  })
                                .frame(width: 80, height: 80)
                                .padding(.trailing)
                                .padding(.bottom, getSafeArea().bottom == 0 ? 15 : 0)
                            }
                        }
                    )
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
    func getSafeArea() ->UIEdgeInsets  {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
//#Preview {
//    NaNaPickDetailView()
//}
