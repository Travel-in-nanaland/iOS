//
//  SearchMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/15/24.
//

import SwiftUI

struct SearchMainView: View {
	@Environment(\.dismiss) var dismiss
	@EnvironmentObject var searchVM: SearchViewModel
	
	@State var searchTerm = ""
	@State var showResultView: Bool = false
	
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
		.navigationDestination(isPresented: $showResultView) {
			SearchResultView(searchTerm: searchTerm)
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
				searchTerm: $searchTerm,
				searchAction: {
					await search(term: searchTerm)
				}
			)
		}
		.padding(.horizontal, 16)
		.padding(.top, 8)
		.padding(.bottom, 32)
	}
	
	private var recentlySearch: some View {
		VStack(spacing: 8) {
			HStack {
				Text(String(localized: "recentSearchTerm"))
					.font(.gothicNeo(.bold, size: 18))
					.foregroundStyle(Color.baseBlack)
				
				Spacer()
				
				Text(String(localized: "removeAll"))
					.font(.gothicNeo(.medium, size: 12))
					.foregroundStyle(Color.gray1)
			}
			.padding(.horizontal, 16)
			
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
								
								Image(.icX)
									.resizable()
									.renderingMode(.template)
									.foregroundStyle(Color.main)
									.frame(width: 16, height: 16)
								
							}
							.padding(.horizontal, 16)
							.padding(.vertical, 8)
						}
						.onTapGesture {
							Task {
								await search(term: term)
							}
						}
					}
				}
			}
			.padding(.leading, 16)
		}
		.padding(.bottom, 32)
	}
	
	private var popularSearch: some View {
		VStack(alignment: .leading, spacing: 0) {
			// TODO: 언어별 분기처리
			Text("가장 많이 ").font(.gothicNeo(.bold, size: 18)).foregroundColor(Color.main) +
			Text("검색하고 있어요!").font(.gothicNeo(.bold, size: 18)).foregroundColor(Color.baseBlack)
			
			Text(getCurrentTime())
				.font(.gothicNeo(.medium, size: 12))
				.foregroundStyle(Color.gray1)
				.padding(.top, 4)
				.padding(.bottom, 16)
			
			HStack(spacing: 0) {
				// 1~4위
				VStack(spacing: 16) {
					ForEach(0..<min(searchVM.state.popularSearchTerms.count, 4), id: \.self) { index in
						HStack(spacing: 8) {
							Text("\(index+1).")
							Text("\(searchVM.state.popularSearchTerms[index])")
							Spacer()
						}
						.font(.gothicNeo(index == 0 || index == 1 ? .semibold : .medium, size: 14))
						.foregroundStyle(index == 0 || index == 1 ? Color.main : Color.gray1)
						.onTapGesture {
							Task {
								await search(term: searchVM.state.popularSearchTerms[index])
							}
						}
					}
				}
				.frame(width: (Constants.screenWidth-32)/2)
				
				// 5~8위
				VStack(spacing: 16) {
					ForEach(4..<min(searchVM.state.popularSearchTerms.count, 8), id: \.self) { index in
						HStack(spacing: 8) {
							Text("\(index+1).")
							Text("\(searchVM.state.popularSearchTerms[index])")
							Spacer()
						}
						.font(.gothicNeo(.medium, size: 14))
						.foregroundStyle(Color.gray1)
						.onTapGesture {
							Task {
								await search(term: searchVM.state.popularSearchTerms[index])
							}
						}
					}
				}
				.frame(width: (Constants.screenWidth-32)/2)
			}
		}
		.padding(.horizontal, 16)
		.padding(.bottom, 34)
	}
	
	private var recommendContents: some View {
		VStack(alignment: .leading) {
			Text(String(localized: "searchVolumeUpJejuPlace"))
				.font(.gothicNeo(.bold, size: 18))
				.foregroundStyle(Color.baseBlack)
			
			LazyVGrid(
				columns: [GridItem(.flexible()), GridItem(.flexible())]
			) {
				ForEach(0..<8) { _ in
					VStack(alignment: .leading, spacing: 8) {
						Rectangle()
							.fill(Color.main)
							.clipShape(RoundedRectangle(cornerRadius: 12))
							.frame(width: (Constants.screenWidth-40)/2, height: 148)
						
						Text(searchVM.state.placeString)
							.font(.gothicNeo(.bold, size: 14))
							.foregroundStyle(Color.baseBlack)
					}
				}
			}
		}
		.padding(.horizontal, 16)
	}
	
	private func getCurrentTime() -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy. MM. dd | a hh:mm"
		formatter.locale = Locale(identifier: "en_US_POSIX")
		
		return formatter.string(from: Date())
	}
	
	private func search(term: String) async {
		searchTerm = term
		await searchVM.action(.searchTerm(term: term))
		showResultView = true
	}
}

#Preview {
	SearchMainView()
		.environmentObject(SearchViewModel())
}
