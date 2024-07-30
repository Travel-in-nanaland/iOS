//
//  ReviewDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI

struct MyReviewView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: ProfileMainViewModel
    
    var layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
        
        ScrollViewReader{ scroll in
            ZStack{
                VStack{
                    NavigationBar(title: LocalizedKey.review.localized(for: localizationManager.language))
                        .frame(height: 56)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 10)
                    
                    
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(viewModel.state.getProfileMainResponse.reviews, id: \.id) { review in
                                Button {
                                    AppState.shared.navigationPath.append(reviewType.detail)
                                } label: {
                                    MyReviewArticleItemView(review: review)
                                        .padding(.top, 10)
                                        .padding(.trailing, 15)
                                        .padding(.leading, 15)
                                }

                            }
                        }
                        .padding(.bottom, 10)
                        .id("scrollToTop")
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
            .navigationDestination(for: reviewType.self) { review in
                switch review {
                case .detail:
                    ReviewWriteMain()
                        .environmentObject(LocalizationManager())
                }
            }
        }
        
    }
}

enum reviewType {
    case detail
}

#Preview {
    MyReviewView(viewModel: ProfileMainViewModel())
        .environmentObject(LocalizationManager())
}
