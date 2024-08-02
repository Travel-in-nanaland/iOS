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
                                
                                KFImage(URL(string: viewModel.state.getNaNaPickDetailResponse.firstImage.originUrl))
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
                                                    .frame(width: 24, height: 24)
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
                                
                                ForEach(viewModel.state.getNaNaPickDetailResponse.nanaDetails.indices, id: \.self) { idx in
                                    let detail = viewModel.state.getNaNaPickDetailResponse.nanaDetails[idx]
                                    
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            VStack(spacing: 0) {
                                                HStack(alignment: .bottom) {
                                                    Text("\(detail.number)")
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
                                                    VStack(alignment: .leading, spacing: 0) {
                                                        Text("\(detail.subTitle)")
                                                            .foregroundStyle(Color.main)
                                                            .font(.caption01)
                                                        Text("\(detail.title)")
                                                            .font(.title01_bold)
                                                    }
                                                }
                                            }
                                            Spacer()
                                        }
                                        .padding(.bottom, 20)
                                        
                                        KFImage(URL(string: detail.images.first?.originUrl ?? ""))
                                            .resizable()
                                            .frame(height: (Constants.screenWidth - 32) * (176 / 328))
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .padding(.leading, 16)
                                            .padding(.trailing, 16)
                                            .padding(.bottom, 16)
                                        
                                        Text("\(detail.content)")
                                            .frame(width: (Constants.screenWidth - 32))
                                            .font(.body01)
                                            .lineSpacing(10)
                                            .padding(.bottom, 24)
                                        
                                        ForEach(detail.additionalInfoList, id: \.infoKey) { data in
                                            HStack(alignment: .top, spacing: 0) {
                                                Image(iconName(for: data.infoEmoji))
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                    .padding(.trailing, 4)
                                                
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
                                        
                                        HStack(spacing: 14) {
                                            ForEach(detail.hashtags, id: \.self) { hashtag in
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
                                }
                            } else {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                        .id("Scroll_To_Top")
                        // 스크롤 뷰의 하위 뷰에 id를 지정합니다.
                    }
                    
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    // withAnimation과 함께 함수 작성
                                    withAnimation(.default) {
                                        // ScrollViewReader의 proxyReader을 사용하여 스크롤 위치로 이동
                                        proxyReader.scrollTo("Scroll_To_Top", anchor: .top) // scroll id 추가
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
    
    func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func iconName(for emoji: String) -> String {
        switch emoji {
        case "ADDRESS": return "icPin"
        case "PARKING": return "icCar"
        case "SPECIAL": return "icSpecial"
        case "AMENITY": return "icAmenity"
        case "WEBSITE": return "icHomepage"
        case "RESERVATION_LINK": return "icReservation"
        case "AGE": return "icAge"
        case "TIME": return "icClock"
        case "FEE": return "icFee"
        case "DATE": return "icDate"
        case "DESCRIPTION": return "icDescription"
        default: return "icPhone"
        }
    }
}

#Preview {
    NaNaPickDetailView(id: 1)
        .environmentObject(LocalizationManager())
}
