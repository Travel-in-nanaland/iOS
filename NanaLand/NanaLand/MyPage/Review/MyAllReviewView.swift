//
//  ReviewDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI

struct MyAllReviewView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: MyAllReviewViewModel
    @State private var isAPICalled = false
    var layout: [GridItem] = [GridItem(.flexible())]
    
    var body: some View {
    
        ScrollViewReader{ scroll in
            if isAPICalled {
                ZStack{
                    VStack{
                        NavigationBar(title: LocalizedKey.review.localized(for: localizationManager.language))
                            .frame(height: 56)
                            .background(Color.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                            .padding(.bottom, 10)
                        
                        ScrollView {
                            LazyVGrid(columns: layout) {
                                if let data = viewModel.state.getMyAllReviewResponse.data {
                                    ForEach(data, id: \.id) { review in
                                        
                                        MyReviewArticleItemView(viewModel: viewModel, placeName: review.placeName, rating: Int(review.rating), images: review.images, content: review.content, reviewTypeKeywords: review.reviewTypeKeywords, heartCount: Int(review.heartCount), createdAt: review.createdAt, postId: review.postId, category: review.category, id: review.id)
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
            }
        }
        .toolbar(.hidden)
        .onAppear {
            Task {
                await getAllReviewItem(page: 0, size: 12)
                isAPICalled = true
            }
        }
        
    }
    
    func getAllReviewItem(page: Int, size: Int) async {
        await viewModel.action(.getMyAllReviewItem(page: page, size: size))
    }
    
}

#Preview {
    MyAllReviewView(viewModel: MyAllReviewViewModel())
        .environmentObject(LocalizationManager())
}
