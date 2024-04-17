//
//  NanaLandTabView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI

enum Tab {
	case home, favorite, story, profile
}

struct NanaLandTabView: View {
    
    var body: some View {

		TabView {
			HomeMainView()
				.tabItem {
					Label(
						title: { Text("홈") },
						icon: { Image(.icHome) }
					)
				}
				.tag(Tab.home)
			
			FavoriteMainView()
				.tabItem {
					Label(
						title: { Text("찜") },
						icon: { Image(.icHeart) }
					)
				}
				.tag(Tab.favorite)
			
			StoryMainView()
				.tabItem {
					Label(
						title: { Text("제주 이야기") },
						icon: { Image(.icStory) }
					)
				}
				.tag(Tab.story)
			
			ProfileMainView()
				.tabItem {
					Label(
						title: { Text("나의 나나") },
						icon: { Image(.icMyPage) }
					)
				}
				.tag(Tab.profile)
		}
		.tint(.baseBlack)
    }
}
