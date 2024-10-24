//
//  ReviewKeywordView.swift
//  NanaLand
//
//  Created by wodnd on 7/22/24.
//

import SwiftUI

struct ReviewKeywordView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var viewModel: ReviewWriteViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var toastMaxMessage = "최대 6개까지 선택 가능합니다"
    var body: some View {
        NavigationBar(title: LocalizedKey.keyword.localized(for: localizationManager.language))
            .frame(height: 56)
            .background(Color.white)
            .padding(.bottom, 10)
        
        
        ZStack{
            NavigationView {
                VStack(spacing: 0) {
                    
                    HStack {
                        Text(.keywordDescription)
                            .font(.caption01)
                            .foregroundColor(.main)
                            .padding()
                        
                        Spacer()
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        Text(.mood)
                            .font(.body_bold)
                        TagCloudView(tags: Array(viewModel.keywordViewModel.keywords.prefix(5)), keywordViewModel: viewModel.keywordViewModel, localizationManager: _localizationManager)
                        
                        Text(.companion)
                            .font(.body_bold)
                        TagCloudView(tags: Array(viewModel.keywordViewModel.keywords[5..<11]), keywordViewModel: viewModel.keywordViewModel, localizationManager: _localizationManager)
                        
                        Text(.amenities)
                            .font(.body_bold)
                        TagCloudView(tags: Array(viewModel.keywordViewModel.keywords[11...]), keywordViewModel: viewModel.keywordViewModel, localizationManager: _localizationManager)
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        // 만약 3개이하로 선택했다면 토스트 메시지 띄우기
                        if viewModel.selectedKeyword.count < 3 {
                            showToast = true
                            toastMessage = "최소 3개이상 선택해야 합니다."
                        } else {
                            
                            dismiss()
                        }
                    }) {
                        Text(.apply) // 적용하기 버튼
                            .font(.body_bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.main)
                            .foregroundColor(.white)
                            .cornerRadius(50)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .toolbar(.hidden)
//                .alert(isPresented: $viewModel.keywordViewModel.showAlert) {
//                    Alert(title: Text(.warning), message: Text(.warningDescription), dismissButton: .default(Text(.check)))
//                }
            }
            .overlay(
                Toast(message: toastMessage, isShowing: $showToast, isAnimating: true)
            )
            .overlay(
                Toast(message: toastMaxMessage, isShowing:  $viewModel.keywordViewModel.showAlert, isAnimating: true)
            )
            .toolbar(.hidden)
        }
        
    }
}

struct TagCloudView: View {
    var tags: [ReviewKeywordModel]
    @ObservedObject var keywordViewModel: ReviewKeywordViewModel
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
        Text(tag.text.localized(for: localizationManager.language))
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .font(.body02)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(keywordViewModel.selectKeywords.contains(tag) ? Color.main.opacity(0.1) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(keywordViewModel.selectKeywords.contains(tag) ? Color.main.opacity(0.9) : Color.gray2, lineWidth: 1)
                    )
            )
            .foregroundColor(keywordViewModel.selectKeywords.contains(tag) ? .main : .gray)
            .onTapGesture {
                keywordViewModel.toggleKeywordSelection(tag)
            }
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
    ReviewKeywordView(viewModel: ReviewWriteViewModel())
        .environmentObject(LocalizationManager())
}
