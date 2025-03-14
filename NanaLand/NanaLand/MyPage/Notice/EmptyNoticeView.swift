//
//  EmptyNoticeView.swift
//  NanaLand
//
//  Created by wodnd on 2/28/25.
//

import SwiftUI

struct EmptyNoticeView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("icNoAnnouncement")
                .resizable()
                .scaledToFit()
                .frame(width: Constants.screenWidth * (140 / 360))
                .padding(.bottom, Constants.screenWidth * (15 / 360))
            
            Text(.emptyAnnouncement)
                .font(.body01)
                .foregroundStyle(Color.gray1)
                .frame(height: 50)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyNoticeView()
}
