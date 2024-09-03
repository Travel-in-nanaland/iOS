//
//  SearchMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import SwiftUI
import Kingfisher

struct SearchMainView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var searchVM: SearchViewModel = SearchViewModel()
    
    @State var searchTerm = ""
    @State var showResultView: Bool = false
    
    let itemWidth = (Constants.screenWidth-40)/2
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView(.vertical, showsIndicators: false) {
                recentlySearch
                popularSearch
                recommendContents
                
                Spacer()
                    .frame(height: 100)
            }
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await searchVM.action(.getPopularKeyword)
            await searchVM.action(.getVolumeUp)
        }
        .navigationDestination(isPresented: $showResultView) {
            SearchResultView(searchVM: searchVM, searchTerm: searchTerm)
        }
    }
    
    private var navigationBar: some View {
        HStack(spacing: 8) {
            Button(action: {
                dismiss()
            }, label: {
                Image(.icLeft)
                    .resizable()
                    .frame(width: 32, height: 32)
            })
            
            NanaSearchBar(
                placeHolder: .inputSearchTerm,
                searchTerm: $searchTerm,
                searchAction: {
                    search(term: searchTerm)
                }
            )
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 32)
    }
    
    private var recentlySearch: some View {
        VStack(spacing: 0) {
            HStack {
                Text(.recentSearchTerm)
                    .font(.gothicNeo(.bold, size: 18))
                    .foregroundStyle(Color.baseBlack)
                
                Spacer()
                
                Button(action: {
                    searchVM.state.recentSearchTerms.removeAll()
                    UserDefaults.standard.removeObject(forKey: "recentSearch")
                }, label: {
                    Text(.removeAll)
                        .font(.gothicNeo(.medium, size: 12))
                        .foregroundStyle(Color.gray1)
                })
            }
            
            if !searchVM.state.recentSearchTerms.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(searchVM.state.recentSearchTerms, id: \.self) { term in
                            ZStack {
                                Capsule()
                                    .fill(Color.main10P)
                                
                                HStack(spacing: 8) {
                                    Text(term)
                                        .font(.gothicNeo(.medium, size: 14))
                                        .foregroundStyle(Color.main)
                                    
                                    Button(action: {
                                        searchVM.state.recentSearchTerms.removeAll(where: {$0 == term})
                                    }, label: {
                                        Image(.icX)
                                            .resizable()
                                            .renderingMode(.template)
                                            .foregroundStyle(Color.main)
                                            .frame(width: 16, height: 16)
                                    })
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                            }
                            .onTapGesture {
                                search(term: term)
                            }
                        }
                    }
                }
                .padding(.top, 8)
            } else {
                HStack {
                    Text(.noRecentSearchTerm)
                        .font(.gothicNeo(.medium, size: 14))
                        .foregroundStyle(Color.gray1)
                    Spacer()
                }
                .padding(.top, 16)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
    
    private var popularSearch: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                if localizationManager.language == .korean {
                    let parts = LocalizedKey.popularSearchTerm.localized(for: localizationManager.language).split(separator: "\\\\")
                    if parts.count == 2 {
                        Text(parts[0])
                            .foregroundStyle(Color.main)
                        
                        Text(parts[1])
                    } else {
                        Text(.popularSearchTerm)
                    }
                } else {
                    Text(.popularSearchTerm)
                }
            }
            .font(.gothicNeo(.bold, size: 18))
            .foregroundStyle(Color.baseBlack)
            .padding(.bottom, 16)
            
//            Text(searchVM.getCurrentTime())
//                .font(.gothicNeo(.medium, size: 12))
//                .foregroundStyle(Color.gray1)
//                .padding(.top, 4)
//                .padding(.bottom, 16)
            
            HStack(spacing: 24) {
                // 1~4위
                VStack(spacing: 16) {
                    ForEach(0..<min(searchVM.state.popularSearchTerms.count, 4), id: \.self) { index in
                        HStack(spacing: 8) {
                            Text("\(index+1).")
                            Text("\(searchVM.state.popularSearchTerms[index])")
                            Spacer(minLength: 0)
                        }
                        .font(.gothicNeo(index == 0 || index == 1 ? .semibold : .medium, size: 14))
                        .foregroundStyle(index == 0 || index == 1 ? Color.main : Color.gray1)
                        .onTapGesture {
                            search(term: searchVM.state.popularSearchTerms[index])
                        }
                    }
                }
                .frame(width: (Constants.screenWidth-32-24)/2)
                
                // 5~8위
                if searchVM.state.popularSearchTerms.count > 4 {
                    VStack(spacing: 16) {
                        ForEach(4..<min(searchVM.state.popularSearchTerms.count, 8), id: \.self) { index in
                            HStack(spacing: 8) {
                                Text("\(index+1).")
                                Text("\(searchVM.state.popularSearchTerms[index])")
                                Spacer(minLength: 0)
                            }
                            .font(.gothicNeo(.medium, size: 14))
                            .foregroundStyle(Color.gray1)
                            .onTapGesture {
                                search(term: searchVM.state.popularSearchTerms[index])
                            }
                        }
                    }
                    .frame(width: (Constants.screenWidth-32-24)/2)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 34)
       
    }
    
    private var recommendContents: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text(.searchVolumeUp)
                    .font(.gothicNeo(.bold, size: 18))
                    .foregroundStyle(Color.baseBlack)
                
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())]
                ) {
                    ForEach(searchVM.state.searchVolumeResult, id: \.id) { article in
                        NavigationLink {
                            switch article.category {
                            case .nature:
                                NatureDetailView(id: Int64(article.id))
                            case .festival:
                                FestivalDetailView(id: Int64(article.id))
                            case .market:
                                ShopDetailView(id: Int64(article.id))
                            case .experience:
                                Text("Experience Detail View")
                    //            ExperienceDetailView(id: article.id)
                            case .nanaPick:
                                NaNaPickDetailView(id: Int64(article.id))
                            case .all:
                                Text("test")
                            case .restaurant:
                                Text("test")
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 8){
                                ZStack {
                                    KFImage(URL(string: article.firstImage.originUrl))
                                        .resizable()
                                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: ((UIScreen.main.bounds.width - 40) / 2) * (12 / 16))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                            Spacer()
                                            
                                            Button {
                                                if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
                                                    AppState.shared.showRegisterInduction = true
                                                    return
                                                }
                                                Task {
                                                    await searchVM.action(.didTapHeartInVolumeUp(article: article))
                                                }
                                              
                                            } label: {
                                                article.favorite ? Image("icHeartFillMain") : Image("icHeartDefault")
                                            }
                                        }
                                        .padding(.top, 8)
                                        Spacer()
                                    }
                                    .padding(.trailing, 8)
                                }
                                
                                Text(article.title)
                                    .font(.gothicNeo(.bold, size: 14))
                                    .foregroundStyle(.black)
                                    .lineLimit(1)
                                
                                Spacer()
                            }
                            
//                            VStack(alignment: .leading, spacing: 8) {
//                                KFImage(URL(string: article.firstImage.thumbnailUrl))
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: itemWidth, height: itemWidth*120/175)
//                                    .clipped()
//                                    .clipShape(RoundedRectangle(cornerRadius: 12))
//                                
//                                Text(article.title)
//                                    .font(.gothicNeo(.bold, size: 14))
//                                    .foregroundStyle(Color.baseBlack)
//                                    .lineLimit(1)
//                            }
//                            .overlay(alignment: .topTrailing) {
//                                Button(action: {
//                                    if UserDefaults.standard.string(forKey: "provider") == "GUEST" {
//                                        AppState.shared.showRegisterInduction = true
//                                        return
//                                    }
//                                    Task {
//                                        await searchVM.action(.didTapHeartInVolumeUp(article: article))
//                                    }
//                                }, label: {
//                                    Image(article.favorite ? .icHeartFillMain : .icHeartDefault)
//                                        .padding(.top, 4)
//                                        .padding(.trailing, 4)
//                                })
//                            }
                        }

                    }
                }
            }
            .padding(.horizontal, 16)
            
        }
    }
    
    private func search(term: String) {
        searchTerm = term

        Task {
            await searchVM.action(.searchTerm(category: .all, term: term))
            showResultView = true
        }
    }
}

#Preview {
    SearchMainView()
        .environmentObject(SearchViewModel())
}

