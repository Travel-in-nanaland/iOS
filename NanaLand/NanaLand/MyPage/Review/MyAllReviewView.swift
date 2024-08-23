//
//  ReviewDetailView.swift
//  NanaLand
//
//  Created by wodnd on 7/28/24.
//

import SwiftUI
import CustomAlert
import Kingfisher

struct MyAllReviewView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel: MyAllReviewViewModel
    @State private var isAPICalled = false
    var layout: [GridItem] = [GridItem(.flexible())]
    @State var selectedReviewId: Int64?
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
                            if viewModel.state.getMyAllReviewResponse.totalElements == 0 {
                                NoResultView()
                                    .frame(height: 70)
                                    .padding(.top, (Constants.screenHeight - 208) * (179 / 636))
                            } else {
                                LazyVGrid(columns: layout) {
                                    if let data = viewModel.state.getMyAllReviewResponse.data {
                                        ForEach(data, id: \.id) { review in
                                            
                                            MyReviewArticleItemView(viewModel: viewModel, placeName: review.placeName, rating: Int(review.rating), images: review.images, content: review.content, reviewTypeKeywords: review.reviewTypeKeywords, heartCount: Int(review.heartCount), createdAt: review.createdAt, postId: review.postId, category: review.category, id: review.id)
                                                .padding(.top, 10)
                                                .padding(.trailing, 15)
                                                .padding(.leading, 15)
                                                .id(review.id)
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                                .id("scrollToTop")
                                
                                if viewModel.state.page < viewModel.state.getMyAllReviewResponse.totalElements / 12 {
                                    ProgressView()
                                        .onAppear {
                                            print("\(viewModel.state.page)")
                                            Task {
                                                await getAllReviewItem(page: viewModel.state.page + 1, size: 12)
                                            }
                                            
                                            viewModel.state.page += 1
                                        }
                                }
                            }
                            
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
                .navigationDestination(for: reviewType.self) { review in
                    switch review {
                    case let .experience(id):
                        ExperienceDetailView(id: id)
                            .environmentObject(LocalizationManager())
                    case let .restaurant(id):
                        RestaurantDetailView(id: id)
                            .environmentObject(LocalizationManager())
                    case let .detailReivew(id, category):
                        MyReviewDetailView(reviewId: id, reviewCategory: category)
                            .environmentObject(LocalizationManager())
                    }
                }
                .onAppear {
                    if let selectedReviewId = selectedReviewId {
                        scroll.scrollTo(selectedReviewId, anchor: .top) // 선택된 리뷰 ID로 스크롤
                    }
                }
                .onChange(of: selectedReviewId) { id in
                    if let id = id {
                        withAnimation {
                            scroll.scrollTo(id, anchor: .top) // 선택된 리뷰 ID로 스크롤
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

struct MyReviewArticleItemView: View {
    @StateObject var viewModel: MyAllReviewViewModel
    var placeName: String
    var rating: Int
    var images: [AllReviewDetailImagesList]?
    var content: String
    var reviewTypeKeywords: [String]
    var heartCount: Int
    var createdAt: String
    var postId: Int64
    var category: String
    var id: Int64
    @State var showAlert: Bool = false//삭제하기 alert 여부
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Button {
                        if category == "EXPERIENCE" {
                            AppState.shared.navigationPath.append(reviewType.experience(id: postId))
                        } else if category == "RESTAURANT" {
                            AppState.shared.navigationPath.append(reviewType.restaurant(id: postId))
                        }
                    } label: {
                        Text(placeName)
                            .font(.body02_bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                        
                        
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 3, height: 11)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        AppState.shared.navigationPath.append(reviewType.detailReivew(id: id, category: category))
                    }, label: {
                        Text("수정")
                            .font(.caption01)
                            .foregroundColor(.gray1)
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.gray3)
                            }
                    })
                    
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Text("삭제")
                            .font(.caption01)
                            .foregroundColor(.gray1)
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background {
                                RoundedRectangle(cornerRadius: 30)
                                    .foregroundColor(.gray3)
                            }
                    })
                    .customAlert("해당 리뷰를\n 삭제하시겠습니까?", isPresented: $showAlert) {
                        
                    } actions: {
                        MultiButton{
                            Button {
                                showAlert = false
                                Task {
                                    await deleteMyReview(id: id)
                                    await getAllReviewItem(page: 0, size: 12)
                                }
                            } label: {
                                Text("네")
                                    .font(.title02_bold)
                                    .foregroundStyle(Color.black)
                            }
                            
                            Button {
                                showAlert = false
                            } label: {
                                Text("아니오")
                                    .font(.title02_bold)
                                    .foregroundStyle(Color.main)
                            }
                            
                        }
                    }
                }
                .padding()
                
                HStack {
                    ForEach(1...5, id: \.self) { number in
                        Image(number <= rating ? "icStarFill" : "icStar")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15)
                    }
                    
                    Spacer()
                }
                .padding(.top, -20)
                .padding(.leading, 15)
                
                if let images = images, !images.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(images, id: \.thumbnailUrl) { imageDetail in
                                KFImage(URL(string: imageDetail.thumbnailUrl))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 70, height: 70)
                                    .cornerRadius(8)
                                    .clipped()
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                    }
                    .padding(.top, -10)
                    .padding(.leading, 5)
                }
                
                HStack {
                    Text(content)
                        .font(.body02)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                
                TagsCloudView(tags: reviewTypeKeywords)
                    .padding(.leading, 10)
                    .padding(.trailing, 15)
                    .padding(.top, -5)
                
                HStack{
                    Image(systemName: "heart.fill")
                        .foregroundColor(.main)
                    
                    Text("\(heartCount)")
                        .font(.body02)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text(createdAt)
                        .font(.caption01)
                        .foregroundColor(.gray1)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
            }
            .padding(.bottom, 20)
            .background(){
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(radius: 1)
            }
        }
    }
    
    func deleteMyReview(id: Int64) async {
        await viewModel.action(.deleteMyReview(id: id))
    }
    func getAllReviewItem(page: Int, size: Int) async {
        await viewModel.action(.getMyAllReviewItem(page: page, size: size))
    }
}

struct TagsCloudView: View {
    var tags: [String]
    
    @State private var totalHeight: CGFloat = .zero
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                self.generateContent(in: geo)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in geo: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { dimension in
                        if (abs(width - dimension.width) > geo.size.width) {
                            width = 0
                            height -= dimension.height
                        }
                        let result = width
                        if tag == tags.last! {
                            width = 0
                        } else {
                            width -= dimension.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { dimension in
                        let result = height
                        if tag == tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func item(for tag: String) -> some View {
        Text("#\(tag)")
            .font(.caption01)
            .foregroundColor(.main)
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

enum reviewType: Hashable {
    case experience(id: Int64)
    case restaurant(id: Int64)
    case detailReivew(id: Int64, category: String)
}

//#Preview {
//    MyAllReviewView(viewModel: MyAllReviewViewModel())
//        .environmentObject(LocalizationManager())
//}
