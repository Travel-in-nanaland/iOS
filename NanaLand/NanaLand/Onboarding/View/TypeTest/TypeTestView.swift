//
//  TypeTestView.swift
//  NanaLand
//
//  Created by 정현우 on 5/16/24.
//

import SwiftUI

struct TypeTestView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let page: Int
	let titleFirstLine: String
	let titleSecondLine: String
	let isTwoLine: Bool
	let firstItem: (image: ImageResource, title: String)
	let secondItem: (image: ImageResource, title: String)
	let thirdItem: (image: ImageResource, title: String)?
	let fourthItem: (image: ImageResource, title: String)?
	
	let itemSize = (Constants.screenWidth - 120) / 2
	
	@State var progress: Double = 0.0
	@State var selectedIndex: Int? = nil
	
	init(
		page: Int,
		titleFirstLine: String,
		titleSecondLine: String,
		isTwoLine: Bool = false,
		firstItem: (image: ImageResource, title: String),
		secondItem: (image: ImageResource, title: String),
		thirdItem: (image: ImageResource, title: String)? = nil,
		fourthItem: (image: ImageResource, title: String)? = nil
	) {
		self.page = page
		self.titleFirstLine = titleFirstLine
		self.titleSecondLine = titleSecondLine
		self.isTwoLine = isTwoLine
		self.firstItem = firstItem
		self.secondItem = secondItem
		self.thirdItem = thirdItem
		self.fourthItem = fourthItem
	}
	
    var body: some View {
		VStack(spacing: 0) {
			progressBar
				.padding(.top, 32)
			
			Spacer()
			
			titleAndIcons
			
			Spacer()
			Spacer()
			
			if page == 1 {
				skipButton
					.padding(.bottom, 16)
			}
			
			backAndOKButton
				.padding(.bottom, 24)
		}
		.padding(.horizontal, 16)
		.toolbar(.hidden, for: .navigationBar)
    }
	
	private var progressBar: some View {
		VStack(alignment: .trailing, spacing: 8) {
			Text("\(page)/5")
				.font(.gothicNeo(.medium, size: 16))
				.foregroundStyle(Color.main)
			
			ProgressView(value: progress)
				.progressViewStyle(LinearProgressViewStyle(tint: Color.main))
				.onAppear {
					self.progress = 0.2 * Double(page)
				}
		}
	}
	
	private var titleAndIcons: some View {
		VStack {
			Text(titleFirstLine)
				.font(.gothicNeo(.bold, size: 22))
				.foregroundStyle(Color.main)
			
			Text(titleSecondLine)
				.font(.gothicNeo(.medium, size: 22))
				.foregroundStyle(Color.main)
				.padding(.bottom, 40)
			
			VStack(spacing: 24) {
				HStack(spacing: 40) {
					typeItem(firstItem, index: 1)
					typeItem(secondItem, index: 2)
				}
				
				if isTwoLine,
				   let thirdItem = thirdItem,
				   let fourthItem = fourthItem
				{
					HStack(spacing: 40) {
						typeItem(thirdItem, index: 3)
						typeItem(fourthItem, index: 4)
					}
				}
			}
		}
	}
	
	private var skipButton: some View {
		Button(action: {
			typeTestVM.action(.onTapSkipButton)
		}, label: {
			Text("테스트 건너뛰기")
				.font(.body02)
				.foregroundStyle(Color.gray1)
		})
	}
	
	private var backAndOKButton: some View {
		HStack(spacing: 16) {
			if page != 1 {
				Button(action: {
					typeTestVM.state.navigationPath.removeLast()
				}, label: {
					ZStack {
						Circle()
							.stroke(Color.main, lineWidth: 2)
							.frame(width: 48, height: 48)
						
						Image(.icLeft)
							.resizable()
							.frame(width: 32, height: 32)
							.foregroundStyle(Color.main)
					}
				})
			}
			
			Button(action: {
				typeTestVM.action(.onTapNextButtonInTest(page: page, index: selectedIndex!))
			}, label: {
				RoundedRectangle(cornerRadius: 30)
					.fill(Color.main)
					.frame(height: 48)
					.opacity(selectedIndex != nil ? 1.0 : 0.1)
					.overlay {
						Text("다음")
							.foregroundStyle(Color.baseWhite)
							.font(.body_bold)
					}
			})
			.disabled(selectedIndex == nil)
		}
	}
	
	private func typeItem(_ type: (image: ImageResource, title: String), index: Int) -> some View {
		VStack(spacing: 16) {
			ZStack {
				if let selectedIndex = selectedIndex,
				   index == selectedIndex {
					Circle()
						.fill(Color.main)
						.frame(width: itemSize, height: itemSize)
				} else {
					Circle()
						.stroke(Color.main, lineWidth: 1)
						.frame(width: itemSize, height: itemSize)
				}
				
				Image(type.image)
					.resizable()
					.frame(width: itemSize-40, height: itemSize-40)
			}
			
			Text(type.title)
				.font(.gothicNeo(.semibold, size: 14))
				.foregroundStyle(Color.baseBlack)
		}
		.onTapGesture {
			if selectedIndex != nil,
			   index == selectedIndex! {
				selectedIndex = nil
			} else {
				selectedIndex = index
			}
		}
	}
}

#Preview {
	TypeTestView(
		page: 5,
		titleFirstLine: "여행에서 가장",
		titleSecondLine: "하고 싶은 것은?",
		isTwoLine: true,
		firstItem: (image: .emotionalSpot, title: "감성 장소"),
		secondItem: (image: .traditionalCulture, title: "전통 문화"),
		thirdItem: (image: .naturalScene, title: "자연 경관"),
		fourthItem: (image: .themepark, title: "테마파크")
	)
	.environmentObject(RegisterViewModel())
}
