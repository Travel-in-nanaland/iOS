//
//  SafariView.swift
//  NanaLand
//
//  Created by 정현우 on 5/31/24.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {

	let url: URL

	func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
		return SFSafariViewController(url: url)
	}

	func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

	}

}
