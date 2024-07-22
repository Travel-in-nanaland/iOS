
//
//  ReviewMain.swift
//  NanaLand
//
//  Created by wodnd on 7/7/24.
//

import SwiftUI
import PhotosUI

struct ReviewWriteMain: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject var viewModel = ReviewWriteViewModel()
    
    var body: some View {
        
        ZStack{
            NavigationView {
                VStack(spacing: 0) {
                    NavigationBar(title: LocalizedKey.write.localized(for: localizationManager.language))
                        .frame(height: 56)
                        .background(Color.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.bottom, 10)
                    
                    ReviewMainGridView(viewModel: viewModel)
                }
                .toolbar(.hidden)
            }
        }
    }
}

struct ReviewMainGridView: View {
    
    @ObservedObject var viewModel: ReviewWriteViewModel
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []
    @State private var reviewContent: String = ""
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        ScrollView {
            VStack {
                Image("img")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .padding()
                
                Text(viewModel.state.getReviewWriteResponse.title)
                    .font(.body_bold)
                    .padding(.bottom, 5)
                Text(viewModel.state.getReviewWriteResponse.address)
                    .font(.body02)
                    .padding(.bottom, 24)
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: 64, height: 1)
                    .padding(.bottom, 26)
                
                Text(.selectRating)
                    .font(.body_bold)
                    .padding(.bottom, 15)
                
                HStack {
                    ForEach(1...5, id: \.self) { number in
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36)
                            .foregroundColor(number <= viewModel.state.getReviewWriteResponse.rating ? .yellow : .gray2)
                            .onTapGesture {
                                viewModel.updateRating(number)
                            }
                    }
                }
                .padding(.bottom, 24)
                
                Rectangle()
                    .fill(Color.gray2)
                    .frame(width: 64, height: 1)
                    .padding(.bottom, 26)
                
                Text(.visitReview)
                    .font(.body_bold)
                    .padding(.bottom, 15)
                
                HStack {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray2)
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                        
                        PhotosPicker(
                            selection: $selectedItems,
                            maxSelectionCount: 5,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            VStack {
                                Image(systemName: "camera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 26)
                                Text("\(viewModel.state.getReviewWriteResponse.imgCnt) / 5")
                                    .font(.gothicNeo(.light, size: 15))
                            }
                            .foregroundColor(.white)
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(selectedImageData.enumerated()), id: \.element) { index, imageData in
                                if let uiImage = UIImage(data: imageData) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .cornerRadius(8)
                                        
                                        Button(action: {
                                            selectedImageData.remove(at: index)
                                            selectedItems.remove(at: index)
                                            viewModel.updateImageCount(selectedImageData.count)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.6)))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 20))
                
                ZStack(alignment: .topLeading) {
                    if reviewContent.isEmpty {
                        Text(.writeContent)
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 0))
                    }
                    
                    TextEditor(text: $reviewContent)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(height: 190)
                        .padding(.horizontal)
                }
                
                HStack {
                    Spacer()
                    Text("(\(reviewContent.count) / 200)")
                        .font(.body02)
                        .foregroundColor(.gray)
                        .padding(.trailing, 16)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        NavigationLink {
                            ReviewKeywordView(viewModel: viewModel)
                        } label: {
                            HStack {
                                Text(.addKeyword)
                                    .font(.body02)
                                Image(systemName: "plus")
                            }
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.main, lineWidth: 1)
                            )
                            .foregroundColor(.main)
                        }
                        
                        MainTagView(tags: Array(viewModel.selectedKeyword.prefix(1)), keywordViewModel: viewModel, localizationManager: _localizationManager)
                        
                        Spacer()
                    }
                    MainTagView(tags: Array(viewModel.selectedKeyword.dropFirst()), keywordViewModel: viewModel, localizationManager: _localizationManager)
                }
                .padding()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .foregroundColor(.main)
                        .frame(width: 370, height: 50)
                    Text(.upload)
                        .font(.body_bold)
                        .foregroundStyle(.white)
                }
            }
        }
        .onChange(of: selectedItems) { newItems in
            Task {
                selectedImageData.removeAll()
                for newItem in newItems {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        if selectedImageData.count < 5 {
                            selectedImageData.append(data)
                        }
                    }
                }
                viewModel.updateImageCount(selectedImageData.count)
            }
        }
    }
}

struct MainTagView: View {
    var tags: [ReviewKeywordModel]
    @ObservedObject var keywordViewModel: ReviewWriteViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var totalHeight = CGFloat.zero
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == tags.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if tag == tags.last! {
                            height = 0
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }
    
    private func item(for tag: ReviewKeywordModel) -> some View {
        HStack {
            Text(tag.text.localized(for: localizationManager.language))
                .font(.body02)
            Image(systemName: "multiply")
                .onTapGesture {
                    keywordViewModel.removeKeyword(tag)
                }
        }
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        .foregroundColor(keywordViewModel.selectedKeyword.contains(tag) ? .main : .gray)
        .background(
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(keywordViewModel.selectedKeyword.contains(tag) ? Color.main.opacity(0.1) : Color.gray2.opacity(0.1))
        )
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

#Preview {
    ReviewWriteMain()
        .environmentObject(LocalizationManager())
}
