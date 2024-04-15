//
//  HomeMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI

struct HomeMainView: View {
    var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				NavigationLink(
					"검색으로 이동",
					destination: SearchMainView(searchVM: SearchViewModel()))
				Text("홈")
				Spacer()
			}
		}
    }
}

#Preview {
    HomeMainView()
}
