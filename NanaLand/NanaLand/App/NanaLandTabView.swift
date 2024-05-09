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
	@EnvironmentObject var appState: AppState
    var body: some View {
		NavigationStack {
			TabView(selection: $appState.currentTab) {
				HomeMainView()
					.tabItem {
						Label(
							title: { Text(String(localized: "home")).font(.gothicNeo(.semibold, size: 10)) },
							icon: { appState.currentTab == .home ? Image(.icHomeFill) : Image(.icHome) }
						)
					}
					.tag(Tab.home)
				
				FavoriteMainView()
					.tabItem {
						Label(
							title: { Text(String(localized: "favorite")).font(.gothicNeo(.semibold, size: 10)) },
							icon: { appState.currentTab == .favorite ? Image(.icHeartFill) : Image(.icHeart) }
						)
					}
					.tag(Tab.favorite)
				
				StoryMainView()
					.tabItem {
						Label(
							title: { Text("제주 이야기").font(.gothicNeo(.semibold, size: 10)) },
							icon: { appState.currentTab == .story ? Image(.icStoryFill) : Image(.icStory) }
						)
					}
					.tag(Tab.story)
				
				ProfileMainView()
					.tabItem {
						Label(
							title: { Text("나의 나나").font(.gothicNeo(.semibold, size: 10)) },
							icon: { appState.currentTab == .profile ? Image(.icMyPageFill) : Image(.icMyPage) }
						)
					}
					.tag(Tab.profile)
			}
		}
        .tint(.baseBlack)
    }
}
