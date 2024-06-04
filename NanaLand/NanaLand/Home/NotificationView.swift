//
//  NotificationView.swift
//  NanaLand
//
//  Created by 정현우 on 6/4/24.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
		VStack {
			NanaNavigationBar(title: .notification, showBackButton: true)
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
    NotificationView()
}
