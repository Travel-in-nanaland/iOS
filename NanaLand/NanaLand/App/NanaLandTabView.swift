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
        .tint(.baseBlack)
        .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
            let appearance = UITabBarAppearance()
            if appState.isTabViewHidden == true {
                appearance.configureWithTransparentBackground()
                tabView.tabBar.standardAppearance = appearance
                
                tabView.tabBar.backgroundColor = UIColor.red
                
                tabView.tabBar.layer.masksToBounds = true
                tabView.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                tabView.tabBar.layer.cornerRadius = 16
                if let shadowView = tabView.view.subviews.first(where: { $0.accessibilityIdentifier == "TabBarShadow" }) {
                    shadowView.frame = tabView.tabBar.frame
                } else {
                    let shadowView = UIView(frame: .zero)
                    shadowView.frame = .zero
                    shadowView.accessibilityIdentifier = "TabBarShadow"
                    
                    shadowView.backgroundColor = UIColor.yellow
                    
                    shadowView.layer.cornerRadius = tabView.tabBar.layer.cornerRadius
                    shadowView.layer.maskedCorners = tabView.tabBar.layer.maskedCorners
                    shadowView.layer.masksToBounds = false
                    shadowView.layer.shadowColor = Color.black.cgColor
                    shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    shadowView.layer.shadowOpacity = 0.1
                    shadowView.layer.shadowRadius = 10
                    tabView.view.addSubview(shadowView)
                    tabView.view.bringSubviewToFront(tabView.tabBar)
                    
                }
            }
            else {
                appearance.configureWithTransparentBackground()
                tabView.tabBar.standardAppearance = appearance
                
                tabView.tabBar.backgroundColor = UIColor.white
                
                tabView.tabBar.layer.masksToBounds = true
                tabView.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                tabView.tabBar.layer.cornerRadius = 16
                
                if let shadowView = tabView.view.subviews.first(where: { $0.accessibilityIdentifier == "TabBarShadow" }) {
                    shadowView.frame = tabView.tabBar.frame
                } else {
                    let shadowView = UIView(frame: .zero)
                    shadowView.frame = tabView.tabBar.frame
                    shadowView.accessibilityIdentifier = "TabBarShadow"
                    
                    shadowView.backgroundColor = UIColor.clear
                    
                    shadowView.layer.cornerRadius = tabView.tabBar.layer.cornerRadius
                    shadowView.layer.maskedCorners = tabView.tabBar.layer.maskedCorners
                    shadowView.layer.masksToBounds = false
                    shadowView.layer.shadowColor = Color.black.cgColor
                    shadowView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
                    shadowView.layer.shadowOpacity = 0.1
                    shadowView.layer.shadowRadius = 10
                    tabView.view.addSubview(shadowView)
                    tabView.view.bringSubviewToFront(tabView.tabBar)
                }
                
            }
		}

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
