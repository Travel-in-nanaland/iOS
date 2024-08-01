//
//  NoticeDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI

struct NoticeMainView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: NoticeMainViewModel
    
    var layout: [GridItem] = [GridItem(.flexible())]
    @State private var isAPICalled = false
    
    var body: some View {
        ScrollViewReader{ scroll in
            if isAPICalled {
                ZStack{
                    VStack{
                        NavigationBar(title: LocalizedKey.notice.localized(for: localizationManager.language))
                            .frame(height: 56)
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.bottom, 10)
                        
                        ScrollView {
                            LazyVGrid(columns: layout) {
                                ForEach(viewModel.state.getNoticeMainResponse.data, id: \.id) { notice in
                                    
                                    Button(action: {
                                        AppState.shared.navigationPath.append(noticeType.detail(id: notice.id))
                                    }, label: {
                                        NoticeArticleItemView(title: notice.title, type: notice.noticeCategory, date: notice.createdAt)
                                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                                    })
                                }
                            }
                            .padding(.bottom, 10)
                        }
                        
                        Spacer()
                    }
                    
                    VStack{
                        Spacer()
                        
                        HStack{
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.default) {
                                    scroll.scrollTo("scrollToTop", anchor: .top)
                                }
                            }, label: {
                                Image(systemName: "chevron.up.circle.fill")
                                    .resizable()
                                    .foregroundColor(.main)
                                    .frame(width: 36, height: 36)
                                    .padding()
                            })
                        }
                    }
                }
                .toolbar(.hidden)
            }
        }
        .navigationDestination(for: noticeType.self) { type in
            switch type{
            case let .detail(id):
                NoticeDetailView(id: id)
            }
        }
        .onAppear {
            Task {
                await getNoticeMainItem(page: 0, size: 12)
                isAPICalled = true
            }
        }
    }
    
    func getNoticeMainItem(page: Int, size: Int) async {
        await viewModel.action(.getNoticeMainItem(page: page, size: size))
    }
    
}

enum noticeType: Hashable{
    case detail(id: Int64)
}

#Preview {
    NoticeMainView(viewModel: NoticeMainViewModel())
        .environmentObject(LocalizationManager())
}
