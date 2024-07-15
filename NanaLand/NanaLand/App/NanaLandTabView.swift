//
//  NanaLandTabView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI
import SwiftUIIntrospect

enum Tab {
    case home, favorite, story, profile
}

struct NanaLandTabView: View {
	@StateObject var appState = AppState.shared
	@AppStorage("provider") var provider: String = ""
	
    var body: some View {
		NavigationStack(path: $appState.navigationPath) {
			TabView(selection: $appState.currentTab) {
                HomeMainView()
                    .tabItem {
                        Label(
							title: { Text(.home).font(.gothicNeo(.semibold, size: 10)) },
                            icon: {
                                if appState.currentTab == .home {
                                    Image("icHomeFill")
                                } else {
                                    Image("icHome")
                                        .renderingMode(.template)
                                      
                                }
                            }
                        )
                    }
                    .tag(Tab.home)
                
                FavoriteMainView()
                    .tabItem {
                        Label(
							title: { Text(.favorite).font(.gothicNeo(.semibold, size: 10)) },
                            icon: {
                                if appState.currentTab == .favorite {
                                    Image("icHeartFill")
                                } else {
                                    Image("icHeart")
                                        .renderingMode(.template)
                                       
                                }
                            }
                        )
                    }
                    .tag(Tab.favorite)
                
                StoryMainView()
                    .tabItem {
                        Label(
							title: { Text(.jejuStory).font(.gothicNeo(.semibold, size: 10)) },
                            icon: {
                                if appState.currentTab == .story {
                                    Image("icStoryFill")
                                } else {
                                    Image("icStory")
                                        .renderingMode(.template)
                                       
                                }
                            }
                        )
                    }
                    .tag(Tab.story)
                
                ProfileMainView()
                    .tabItem {
                        Label(
							title: { Text(.myNana).font(.gothicNeo(.semibold, size: 10)) },
                            icon: {
                                if appState.currentTab == .profile {
                                    Image("icMyPageFill")
                                } else {
                                    Image("icMyPage")
                                        .renderingMode(.template)
                                       
                                }
                            }
                        )
                    }
                    .tag(Tab.profile)
            }
		}
		.overlay {
			if appState.showRegisterInduction {
				RegisterInductionView(
					closeAction: {
						appState.showRegisterInduction = false
						
						if appState.currentTab == .favorite {
							appState.currentTab = appState.previousTab
						}
				})
			}
		}
        .tint(.baseBlack)
		.fullScreenCover(isPresented: $appState.showTypeTest) {
			TypeTestNavigationView(nickname: provider == "GUEST" ? "GUEST" : appState.userInfo.nickname)
		}
        .introspect(.tabView, on: .iOS(.v16, .v17)) { tabView in
            let appearance = UITabBarAppearance()
            
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
}
