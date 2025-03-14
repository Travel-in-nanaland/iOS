//
//  EmptyNotificationView.swift
//  NanaLand
//
//  Created by wodnd on 2/28/25.
//

import SwiftUI

struct EmptyNotificationView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("icNoNotification")
                .resizable()
                .scaledToFit()
                .frame(width: Constants.screenWidth * (140 / 360))
                .padding(.bottom, Constants.screenWidth * (15 / 360))
            
            Text(.emptyNotification)
                .font(.body01)
                .foregroundStyle(Color.gray1)
                .frame(height: 50)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    EmptyNotificationView()
}
