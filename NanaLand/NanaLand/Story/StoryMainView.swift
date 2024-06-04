//
//  StoryMainView.swift
//  NanaLand
//
//  Created by 정현우 on 4/13/24.
//

import SwiftUI

struct StoryMainView: View {
    var body: some View {
        VStack {
			NanaNavigationBar(title: .jejuStory, showBackButton: false)
            Spacer()
            VStack(spacing: 0) {
                Image("icAirplane")
				Text(.beingPrepared)
                    .font(.body01)
                    .foregroundStyle(.gray1)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 169, height: 146)
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    StoryMainView()
}
