//
//  NewNanaPickDetailView.swift
//  NanaLand
//
//  Created by wodnd on 8/22/24.
//

import SwiftUI
import Kingfisher

struct NewNanaPickDetailView: View {
    
    @StateObject var viewModel = NewNanaPickDetailViewModel()
    var id: Int64
    @State var isAPICalled = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack{
                if isAPICalled {
                    NanaPickDetailMainView(viewModel: viewModel, id: id, size: size, safeArea: safeArea)
                        .ignoresSafeArea(.all, edges: .top)
                    
                    VStack(spacing: 0){
                        
                        NavigationHeartDeepLinkBar(viewModel: viewModel)
                            .frame(height: 56)
                        
                        Spacer()
                    }
                }
            }
        }
        .toolbar(.hidden)
        .onAppear {
            Task {
                await getNaNaDetail(id: id)
                isAPICalled = true
            }
        }
    }
    
    func getNaNaDetail(id: Int64) async {
        await viewModel.action(.getNanaPickDetail(id: id))
    }
}

struct NanaPickDetailMainView: View {
    @StateObject var viewModel: NewNanaPickDetailViewModel
    var isAPICalled: Bool = false
    var id: Int64
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollViewReader{ scroll in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0){
                        NanaPickHeader()
                            .zIndex(1000)
                        
                        NewNaNaPickDetailMainView(viewModel: viewModel)
                    }
                    .background(){
                        ScrollDetector { offset in
                            offsetY = -offset
                        } onDraggingEnd: { offset, velocity in
                            print("stooooooop")
                        }
                    }
                    .id("Scroll_To_Top")
                }
                .overlay(){
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                // withAnimation과 함께 함수 작성
                                withAnimation(.default) {
                                    // ScrollViewReader의 proxyReader을 사용하여 스크롤 위치로 이동
                                    scroll.scrollTo("Scroll_To_Top", anchor: .top) // scroll id 추가
                                }
                            }, label: {
                                Image("icScrollToTop")
                            })
                            .frame(width: 80, height: 80)
                            .padding(.trailing)
                        }
                    }
                }
            }
        }
        
    }
    
    @ViewBuilder
    func  NanaPickHeader() -> some View {
        let headerHeight = (size.height * 0.3) + safeArea.top
        let minimunHeaderHeight = safeArea.top * 3.0
        
        GeometryReader { _ in
            ZStack {
                
                GeometryReader { geo in
                    let imageFrame = geo.frame(in: .global)
                    
                    ZStack{
                        KFImage(URL(string: viewModel.state.getNanaPickDetailResponse.firstImage.originUrl))
                            .resizable()
                            .scaledToFill() // 화면을 꽉 채우도록 조정
                            .frame(width: imageFrame.width, height: imageFrame.height * 1.5)
                            .clipped()
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(){
                                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                            }
                            .frame(width: imageFrame.width, height: imageFrame.height * 1.5)
                            .overlay(){
                                HStack{
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        
                                        Text(viewModel.state.getNanaPickDetailResponse.heading)
                                            .font(.title02_bold)
                                            .foregroundColor(.white)
                                        Text(viewModel.state.getNanaPickDetailResponse.subHeading)
                                            .font(.largeTitle01)
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                    }
                }
            }
            .frame(height: (headerHeight + offsetY) < minimunHeaderHeight ? minimunHeaderHeight : (headerHeight + offsetY), alignment: .bottom)
            .offset(y: -offsetY)
        }
    }
}

struct NanaPickHeader: View {
    var imageUrl: String
    var heading: String
    var subHeading: String
    
    var body: some View {
        ZStack {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill() // 화면을 꽉 채우도록 조정
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
                .background(.blue)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(heading)
                    .font(.title02_bold)
                    .foregroundColor(.white)
                Text(subHeading)
                    .font(.largeTitle01)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


struct NewNaNaPickDetailMainView: View {
    @StateObject var viewModel: NewNanaPickDetailViewModel
    @State private var selectedNum: Int = 0 // 인덱스를 관리하기 위해 Int로 변경
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var currentPage = 0
    @State private var index = 0
    @State private var special: String = ""
    @State private var specialModal = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollViewReader { proxyReader in
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            if viewModel.state.getNanaPickDetailResponse.notice != nil {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white)
                                        .frame(maxWidth: Constants.screenWidth - 40)
                                        .shadow(radius: 1)
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack(alignment: .center, spacing: 0) {
                                            Image("icNanaPickNotice")
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
                                        
                                        Text(viewModel.state.getNanaPickDetailResponse.notice ?? "")
                                            .padding(.leading, 32)
                                            .padding(.trailing, 32)
                                            .padding(.bottom, 16)
                                            .font(.gothicNeo(.regular, size: 14))
                                        Spacer()
                                    }
                                }
                                .padding(.top, 450)
                                .padding(.bottom, 48)
                                
                                ForEach(viewModel.state.getNanaPickDetailResponse.nanaDetails.indices, id: \.self) { idx in
                                    let detail = viewModel.state.getNanaPickDetailResponse.nanaDetails[idx]
                                    
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
                                        
                                        ZStack{
                                            if detail.images.count == 1{
                                                KFImage(URL(string: detail.images.first?.originUrl ?? ""))
                                                    .resizable()
                                                    .frame(height: (Constants.screenWidth - 32) * (176 / 328))
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .padding(.leading, 16)
                                                    .padding(.trailing, 16)
                                                    .padding(.bottom, 16)
                                            } else {
                                                TabView(selection: $selectedNum) {
                                                    ForEach(detail.images.indices, id: \.self) { imageIndex in
                                                        VStack{
                                                            HStack{
                                                                KFImage(URL(string: detail.images[imageIndex].originUrl))
                                                                    .resizable()
                                                                    .frame(height: (Constants.screenWidth - 32) * (176 / 328))
                                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                                    .padding(.leading, 16)
                                                                    .padding(.trailing, 16)
                                                                    .padding(.bottom, 16)
                                                                    .tag(imageIndex) // 인덱스를 태그로 설정
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(height: (Constants.screenWidth - 32) * (196 / 328))
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                                .onReceive(timer, perform: { _ in
                                                    withAnimation {
                                                        index = (index + 1) % detail.images.count
                                                        selectedNum = index
                                                        currentPage = index
                                                    }
                                                })
                                                VStack(spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        Text("\(index + 1) / \(detail.images.count)")
                                                            .frame(width: 41, height: 20)
                                                            .font(.caption02)
                                                            .foregroundColor(.white)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 30)
                                                                    .stroke(Color.white, lineWidth: 1) // 둥근 모서리와 테두리 추가
                                                            )
                                                        
                                                    }
                                                    .padding(.bottom, 30)
                                                    .padding(.trailing, 30)
                                                    
                                                }
                                            }
                                        }
                                        
                                        Text("\(detail.content)")
                                            .frame(width: (Constants.screenWidth - 32), alignment: .leading)
                                            .font(.body01)
                                            .lineSpacing(10)
                                            .padding(.bottom, 24)
                                        
                                        ForEach(detail.additionalInfoList, id: \.infoKey) { data in
                                            HStack(alignment: .top, spacing: 0) {
                                                
                                                if data.infoKey != "이 장소만의 매력포인트" {
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
                                        .padding(.top, 16)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 16)
                                        
                                        ForEach(detail.additionalInfoList, id: \.infoKey) { data in
                                            HStack(spacing: 0) {
                                                if data.infoKey == "이 장소만의 매력포인트" {
                                                    Button {
                                                        specialModal = true
                                                        special = data.infoValue
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 30)
                                                            .frame(width: Constants.screenWidth * 0.95, height: 40)
                                                            .foregroundColor(.white)
                                                            .shadow(radius: 1)
                                                            .overlay(){
                                                                HStack(spacing: 0){
                                                                    Text("이 장소만의 매력 포인트✨")
                                                                        .font(.gothicNeo(.regular, size: 16))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Image("icSpecialGo")
                                                                }
                                                                .padding()
                                                            }
                                                    }
                                                }
                                            }
                                        }
                                        .fullScreenCover(isPresented: $specialModal) {
                                            NewNanaPickSpecialModalView(content: special)
                                                .background(ClearBackgroundView())
                                        }
                                    }
                                    .padding(.bottom, 30)
                                }

                            } else {
                                
                                ZStack {}
                                .padding(.top, 400)
                                .padding(.bottom, 48)
                                
                                ForEach(viewModel.state.getNanaPickDetailResponse.nanaDetails.indices, id: \.self) { idx in
                                    let detail = viewModel.state.getNanaPickDetailResponse.nanaDetails[idx]
                                    
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
                                        
                                        ZStack{
                                            if detail.images.count == 1{
                                                KFImage(URL(string: detail.images.first?.originUrl ?? ""))
                                                    .resizable()
                                                    .frame(height: (Constants.screenWidth - 32) * (176 / 328))
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    .padding(.leading, 16)
                                                    .padding(.trailing, 16)
                                                    .padding(.bottom, 16)
                                            } else {
                                                TabView(selection: $selectedNum) {
                                                    ForEach(detail.images.indices, id: \.self) { imageIndex in
                                                        VStack{
                                                            HStack{
                                                                KFImage(URL(string: detail.images[imageIndex].originUrl))
                                                                    .resizable()
                                                                    .frame(height: (Constants.screenWidth - 32) * (176 / 328))
                                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                                                    .padding(.leading, 16)
                                                                    .padding(.trailing, 16)
                                                                    .padding(.bottom, 16)
                                                                    .tag(imageIndex) // 인덱스를 태그로 설정
                                                            }
                                                        }
                                                    }
                                                }
                                                .frame(height: (Constants.screenWidth - 32) * (196 / 328))
                                                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                                .onReceive(timer, perform: { _ in
                                                    withAnimation {
                                                        index = (index + 1) % detail.images.count
                                                        selectedNum = index
                                                        currentPage = index
                                                    }
                                                })
                                                VStack(spacing: 0) {
                                                    Spacer()
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        Text("\(index + 1) / \(detail.images.count)")
                                                            .frame(width: 41, height: 20)
                                                            .font(.caption02)
                                                            .foregroundColor(.white)
                                                            .overlay(
                                                                RoundedRectangle(cornerRadius: 30)
                                                                    .stroke(Color.white, lineWidth: 1) // 둥근 모서리와 테두리 추가
                                                            )
                                                        
                                                    }
                                                    .padding(.bottom, 30)
                                                    .padding(.trailing, 30)
                                                    
                                                }
                                            }
                                        }
                                        
                                        Text("\(detail.content)")
                                            .frame(width: (Constants.screenWidth - 32), alignment: .leading)
                                            .font(.body01)
                                            .lineSpacing(10)
                                            .padding(.bottom, 24)
                                        
                                        ForEach(detail.additionalInfoList, id: \.infoKey) { data in
                                            HStack(alignment: .top, spacing: 0) {
                                        
                                                if data.infoKey != "이 장소만의 매력포인트" {
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
                                        .padding(.top, 16)
                                        .padding(.leading, 16)
                                        .padding(.bottom, 16)
                                        
                                        ForEach(detail.additionalInfoList, id: \.infoKey) { data in
                                            HStack(spacing: 0) {
                                                if data.infoKey == "이 장소만의 매력포인트" {
                                                    Button {
                                                        specialModal = true
                                                        special = data.infoValue
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 30)
                                                            .frame(width: Constants.screenWidth * 0.95, height: 40)
                                                            .foregroundColor(.white)
                                                            .shadow(radius: 1)
                                                            .overlay(){
                                                                HStack(spacing: 0){
                                                                    Text("이 장소만의 매력 포인트✨")
                                                                        .font(.gothicNeo(.regular, size: 16))
                                                                    
                                                                    Spacer()
                                                                    
                                                                    Image("icSpecialGo")
                                                                }
                                                                .padding()
                                                            }
                                                    }
                                                }
                                            }
                                        }
                                        .fullScreenCover(isPresented: $specialModal) {
                                            NewNanaPickSpecialModalView(content: special)
                                                .background(ClearBackgroundView())
                                        }
                                    }
                                    .padding(.bottom, 30)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func iconName(for emoji: String) -> String {
        switch emoji {
        case "ADDRESS": return "icNanaAddress"
        case "PARKING": return "icNanaCar"
        case "AMENITY": return "icAmenity"
        case "WEBSITE": return "icNanaHomepage"
        case "RESERVATION_LINK": return "icNanaReservation"
        case "AGE": return "icNanaAge"
        case "TIME": return "icNanaTime"
        case "FEE": return "icNanaCharge"
        case "DATE": return "icNanaDate"
        case "DESCRIPTION": return "icDescription"
        case "CALL" : return "icNanaInquiry"
        case "ETC" : return "icNanaEtc"
        default: return "icPhone"
        }
    }
}


#Preview {
    NewNanaPickDetailView(id: 0)
}
