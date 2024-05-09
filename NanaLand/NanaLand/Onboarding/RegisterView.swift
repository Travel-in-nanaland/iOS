//
//  RegisterView.swift
//  NanaLand
//
//  Created by 정현우 on 5/4/24.
//

import SwiftUI

enum RegisterViewType {
	case languageSelect  // 언어 선택
	case login  // 로그인
}

struct RegisterView: View {
	@State var path: [RegisterViewType] = []
	
    var body: some View {
		NavigationStack(path: $path) {
			
		}
    }
}

#Preview {
	RegisterView()
}
