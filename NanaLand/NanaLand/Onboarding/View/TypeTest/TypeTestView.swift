//
//  TypeTestView.swift
//  NanaLand
//
//  Created by 정현우 on 5/16/24.
//

import SwiftUI

struct TypeTestView: View {
	@EnvironmentObject var typeTestVM: TypeTestViewModel
	let nickname: String
	let page: Int
	let titleFirstLine: LocalizedKey
	let titleSecondLine: LocalizedKey
	let isTwoLine: Bool
	let firstItem: (image: ImageResource, title: LocalizedKey)
	let secondItem: (image: ImageResource, title: LocalizedKey)
	let thirdItem: (image: ImageResource, title: LocalizedKey)?
	let fourthItem: (image: ImageResource, title: LocalizedKey)?
	
	let itemSize = (Constants.screenWidth - 120) / 2
	
	@State var progress: Double = 0.0
	@State var selectedIndex: Int? = nil
	
	init(
		nickname: String,
		page: Int,
		titleFirstLine: LocalizedKey,
		titleSecondLine: LocalizedKey,
		isTwoLine: Bool = false,
		firstItem: (image: ImageResource, title: LocalizedKey),
		secondItem: (image: ImageResource, title: LocalizedKey),
		thirdItem: (image: ImageResource, title: LocalizedKey)? = nil,
		fourthItem: (image: ImageResource, title: LocalizedKey)? = nil
	) {
		self.nickname = nickname
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
			
			Spacer(minLength: 0)
			Spacer(minLength: 0)
			
			titleView
			
			Spacer(minLength: 0)
			
			iconsView
			
			Spacer(minLength: 0)
			Spacer(minLength: 0)
			
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
	
	private var titleView: some View {
		VStack {
			Text(titleFirstLine, arguments: [nickname])
				.font(.gothicNeo(.bold, size: 22))
				.foregroundStyle(Color.main)
				.multilineTextAlignment(.center)
			
			Text(titleSecondLine, arguments: [nickname])
				.font(.gothicNeo(.medium, size: 22))
				.foregroundStyle(Color.main)
		}
		.multilineTextAlignment(.center)
	}
	
	private var iconsView: some View {
		VStack(spacing: 4) {
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
	
	private var skipButton: some View {
		Button(action: {
			typeTestVM.action(.onTapSkipButton)
		}, label: {
			Text(.skipTypeTest)
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
						Text(.next)
							.foregroundStyle(Color.baseWhite)
							.font(.body_bold)
					}
			})
			.disabled(selectedIndex == nil)
		}
	}
	
	private func typeItem(_ type: (image: ImageResource, title: LocalizedKey), index: Int) -> some View {
		VStack(spacing: 0) {
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
			.padding(.bottom, 16)
			
			Text(type.title)
				.font(.gothicNeo(.semibold, size: 14))
				.foregroundStyle(Color.baseBlack)
				.multilineTextAlignment(.center)
			
			Spacer(minLength: 0)
		}
		.frame(width: itemSize, height: itemSize + 56)
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
//	TypeTestView(
//		nickname: "현우",
//		page: 2,
//		titleFirstLine: .typeTest1Q1L,
//		titleSecondLine: .typeTest1Q2L,
//		firstItem: (image: .tourSpot, title: .touristSpot),
//		secondItem: (image: .localSpot, title: .localSpot)
//	)
//	.environmentObject(RegisterViewModel())
	
	TypeTestView(
		nickname: "현우",
		page: 5,
		titleFirstLine: .typeTest5Q1L,
		titleSecondLine: .typeTest5Q2L,
		isTwoLine: true,
		firstItem: (image: .emotionalSpot, title: .sentimentalPlace),
		secondItem: (image: .traditionalCulture, title: .traditionalCulture),
		thirdItem: (image: .naturalScene, title: .naturalScenery),
		fourthItem: (image: .themepark, title: .themePark)
	)
	.environmentObject(RegisterViewModel())
}
