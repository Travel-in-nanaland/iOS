//
//  ReviewKeywordView.swift
//  NanaLand
//
//  Created by wodnd on 7/8/24.
//

import SwiftUI

struct ReviewKeywordView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @ObservedObject var viewModel: ReviewWriteViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationBar(title: LocalizedKey.keyword.localized(for: localizationManager.language))
            .frame(height: 56)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
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
                        dismiss()
                    }) {
                        Text(.apply)
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
                .alert(isPresented: $viewModel.keywordViewModel.showAlert) {
                    Alert(title: Text(.warning), message: Text(.warningDescription), dismissButton: .default(Text(.check)))
                }
            }
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
                keywordViewModel.selectKeywords.contains(tag) ?
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.main.opacity(0.9), lineWidth: 1)
                    .foregroundColor(Color.main.opacity(0.1))
                :  RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.gray2, lineWidth: 1)
                    .foregroundColor(Color.clear)
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
