//
//  NoticeDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI

struct NoticeMainView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: ProfileMainViewModel
    
    
    var layout: [GridItem] = [GridItem(.flexible())]
    @State private var selectedNotice: ProfileMainModel.Notice? = nil
    
    var body: some View {
        ScrollViewReader{ scroll in
            ZStack{
                VStack{
                    NavigationBar(title: LocalizedKey.notice.localized(for: localizationManager.language))
                        .frame(height: 56)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.state.getProfileMainResponse.notices, id: \.id) { notice in
                                
                                Button(action: {
                                    selectedNotice = notice
                                    
                                    AppState.shared.navigationPath.append(noticeType.detail)
                                }, label: {
                                    NoticeArticleItemView(title: notice.title, type: notice.type, date: notice.date)
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
        .navigationDestination(for: noticeType.self) { type in
            switch type{
            case .detail:
                if let selectedNotice = selectedNotice {
                    NoticeDetailView(notice: selectedNotice)
                        .environmentObject(localizationManager)
                }
            }
        }
    }
}

enum noticeType{
    case detail
}

#Preview {
    NoticeMainView(viewModel: ProfileMainViewModel())
        .environmentObject(LocalizationManager())
}
