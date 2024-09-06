//
//  NewNanapickMainView.swift
//  NanaLand
//
//  Created by wodnd on 8/21/24.
//

import SwiftUI
import Kingfisher
import UIKit

struct NewNanaPickMainView: View {
    @State var viewModel = NewNanaPickMainViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var currentItem = 0
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var isAPICalled = false
    
    var layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0){
            NanaNavigationBar(title: .nanaPick, showBackButton: false)
                .frame(height: 56)
            
            if isAPICalled {
                ScrollView{
                    
                    HStack(spacing: 0){
                        if localizationManager.language == .korean {
                            let recommend = Text(.nanapickRecommend1).font(.title02_bold).foregroundColor(.black) + Text(.nanapickRecommend2).font(.title02_bold).foregroundColor(.main) + Text(.nanapickRecommend3).font(.title02_bold).foregroundColor(.black)
                            
                            recommend
                        } else if localizationManager.language == .english {
                            let recommend = Text(.nanapickRecommend1).font(.title02_bold).foregroundColor(.black) + Text(.nanapickRecommend2).font(.title02_bold).foregroundColor(.main) + Text(.nanapickRecommend3).font(.title02_bold).foregroundColor(.black)
                            
                            recommend
                        } else if localizationManager.language == .chinese {
                            let recommend = Text(.nanapickRecommend1).font(.title02_bold).foregroundColor(.black) + Text(.nanapickRecommend2).font(.title02_bold).foregroundColor(.main) + Text(.nanapickRecommend3).font(.title02_bold).foregroundColor(.black)
                            
                            recommend
                        } else if localizationManager.language == .malaysia {
                            let recommend = Text(.nanapickRecommend1).font(.title02_bold).foregroundColor(.black) + Text(.nanapickRecommend2).font(.title02_bold).foregroundColor(.main) + Text(.nanapickRecommend3).font(.title02_bold).foregroundColor(.black)

                            
                            recommend
                        } else {
                            let recommend = Text(.nanapickRecommend1).font(.title02_bold).foregroundColor(.black) + Text(.nanapickRecommend2).font(.title02_bold).foregroundColor(.main) + Text(.nanapickRecommend3).font(.title02_bold).foregroundColor(.black)

                            
                            recommend
                        }
                    
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView(.horizontal){
                        LazyHGrid(rows: layout){
                            ForEach(viewModel.state.getNanaPickRecommendResponse, id: \.id) { recommend in
                                
                                Button(action: {
                                    AppState.shared.navigationPath.append(NewNanaPickType.detail(id: recommend.id))
                                }, label: {
                                    NanaPickRecommendView(imageUrl: recommend.firstImage.originUrl, version: recommend.version, heading: recommend.heading, subHeading: recommend.subHeading, newest: recommend.newest)
                                        .padding()
                                })
                            }
                        }
                    }
//                    .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
//                        scrollView.isScrollEnabled = true
//                        scrollView.isPagingEnabled = true
//                    }
                    .scrollIndicators(.hidden)
                    .padding(.top, -10)
                        
                    
                    HStack(spacing: 0){
                        Text(.nanaPick)
                            .font(.title02_bold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        VStack(spacing: 0){
                            Spacer()
                            
                            Button {
                                AppState.shared.navigationPath.append(NewNanaPickType.all)
                            } label: {
                                Text(.nanapickAll)
                                    .font(.caption01)
                                    .foregroundColor(.gray1)
                            }

                        }
                    }
                    .padding()
                    
                    LazyVGrid(columns: layout) {
                        ForEach(viewModel.state.getNanaPickGridResponse.data.indices, id: \.self) { list in
                            let gridItem = viewModel.state.getNanaPickGridResponse.data[list]
                            
                            NewNanaPickArticleItem(id: gridItem.id, imageUrl: gridItem.firstImage.originUrl, subHeading: gridItem.subHeading, version: gridItem.version, newest: gridItem.newest)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationDestination(for: NewNanaPickType.self, destination: { nanaPick in
            switch nanaPick {
            case let .detail(id):
                NewNanaPickDetailView(id: id)
            case let .all:
                NewNanaPickAllMainView()
            }
        })
        .onAppear(){
            Task{
                await getNanaPickRecommend()
                await getNanaPickGridList()
                isAPICalled = true
            }
        }
    }
    
    func getNanaPickRecommend() async {
        await viewModel.action(.getNanaPickRecommend)
    }
    
    func getNanaPickGridList() async {
        viewModel.state.getNanaPickGridResponse.data = []
        await viewModel.action(.getNanaPickGridList(page: 0, size: 12))
    }
}


struct NanaPickRecommendView: View {

    var imageUrl: String
    var version: String
    var heading: String
    var subHeading: String
    var newest: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            ZStack{
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 210, height: 280)
                    .clipped()

                Rectangle()
                    .foregroundColor(.clear)
                    .background(){
                        LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                    }
                    .frame(width: 210, height: 280)
                    .overlay(){
                        VStack(spacing: 0){
                            HStack(spacing: 0){
                                Spacer()
                                
                                Text(version)
                                    .font(.caption01_semibold)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            
                            Spacer()
                            
                            HStack(spacing: 0){
                                VStack(alignment: .leading, spacing: 0){
                                    Text(heading)
                                        .lineLimit(1)
                                        .font(.body02_semibold)
                                        .foregroundColor(.white)
                                    
                                    Text(subHeading)
                                        .lineLimit(1)
                                        .font(.title01_bold)
                                        .foregroundColor(.white)
                                }
                                
                                Spacer()
                            }
                            .padding()
                        }
                    }
                
            }
            
            if newest {
                HStack(spacing: 0){
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: 36, height: 18)
                        .foregroundColor(.main)
                        .overlay(){
                            Text("NEW")
                                .font(.caption02_semibold)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 5)
                    
                    Text(subHeading)
                        .frame(width: 170)
                        .lineLimit(1)
                        .font(.title02_bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.top, 10)
            } else {
                HStack(spacing: 0){
                    Text(subHeading)
                        .frame(width: 170)
                        .lineLimit(1)
                        .font(.title02_bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.top, 10)
            }
        }
    }
}

struct NewNanaPickArticleItem: View {
    var id: Int64
    var imageUrl: String
    var subHeading: String
    var version: String
    var newest: Bool
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 10)
            .frame(width: Constants.screenWidth * 0.92, height: 80)
            .foregroundColor(.white)
            .shadow(radius: 1)
            .overlay(){
                HStack(spacing: 0){
                    KFImage(URL(string: imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 80)
                        .clipped()
                        .clipShape(CustomCornerRadiusShape(corners: [.topLeft, .bottomLeft], radius: 10))
                        .overlay(){
                            if newest {
                                VStack(spacing: 0){
                                    HStack(spacing: 0){
                                        RoundedRectangle(cornerRadius: 15)
                                            .frame(width: 36, height: 16)
                                            .foregroundColor(.main)
                                            .overlay(){
                                                Text("NEW")
                                                    .font(.caption02_semibold)
                                                    .foregroundColor(.white)
                                            }
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(.top, 5)
                                .padding(.leading, 5)
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text(subHeading)
                            .font(.body_bold)
                            .foregroundColor(.black)
                            .padding(.bottom, 5)
                        
                        Text(version)
                            .font(.caption01)
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack(spacing: 0){
                        Spacer()
                        
                        Button {
                            AppState.shared.navigationPath.append(NewNanaPickType.detail(id: id))
                        } label: {
                            Image("icArrow")
                        }

                    }
                    .padding()
                }
            }
    }
}

enum NewNanaPickType: Hashable {
    case detail(id: Int64)
    case all
}
struct CustomCornerRadiusShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    NewNanaPickMainView()
        .environmentObject(LocalizationManager())
}
