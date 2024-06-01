//
//  DeepLinkManager.swift
//  NanaLand
//
//  Created by 정현우 on 5/31/24.
//

import Foundation

@MainActor
class DeepLinkManager {
	static let shared = DeepLinkManager()
	
	func makeLink(category: Category, id: Int) -> URL {
		let lang = LocalizationManager.shared.language.deeplinkName
		return URL(string: "\(Secrets.baseUrl)/share/\(lang)?category=\(category.rawValue)&id=\(id)")!
	}
	
	func handleDeepLink(url: URL) {
		guard let (category, id, lang) = decompostionURL(url: url) else {
			print("url decompostion 에러")
			return
		}
		
		checkUserStatusAndSendNotification(category: category, id: id, lang: lang)
	}
	
	// 딥링크 url에서 필요한 정보 추출
	private func decompostionURL(url: URL) -> (category: Category, id: Int, lang: Language)? {
		if let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
			// 쿼리 항목들을 추출합니다.
			if let queryItems = urlComponents.queryItems {
				// 각 쿼리 항목을 딕셔너리 형태로 변환합니다.
				var queryParams = [String: String]()
				for queryItem in queryItems {
					queryParams[queryItem.name] = queryItem.value
				}
				
				// 필요한 값들을 추출합니다.
				if let categoryString = queryParams["category"],
				   let idString = queryParams["id"],
				   let langString = queryParams["lang"],
				   let category = Category(rawValue: categoryString),
				   let id = Int(idString),
				   let lang = Language(deeplinkName: langString)
				{
					return (category: category, id: id, lang: lang)
				}
			}
		}
		
		return nil
	}
	
	private func checkUserStatusAndSendNotification(category: Category, id: Int, lang: Language) {
		if UserDefaults.standard.bool(forKey: "isLogin") == true,
		   UserDefaults.standard.string(forKey: "locale") != nil
		{
			// 로그인된 유저라면
			// 해당 요청 정보 보이도록 notification
			sendNotification(category: category, id: id)
		} else {
			// 로그인된 유저가 아니라면
			// -> 공유 링크의 언어로 설정하고 비회원으로 가입
			// 해당 요청 정보 보이도록 notification
			UserDefaults.standard.setValue(lang.rawValue, forKey: "locale")
			let authManager = AuthManager(registerVM: RegisterViewModel())
			Task {
				await authManager.nonMemeberLogin()
				sendNotification(category: category, id: id)
			}
		}
	}
	
	private func sendNotification(category: Category, id: Int) {
		let userInfo = ["id": id]
		
		// 0.5초 대기시간 + 스플래시 시간
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 + (AppState.shared.isSplashCompleted ? 0 : Constants.splashTime)) {
			
			if category == .market {
				NotificationCenter.default.post(name: .deeplinkShowMarketDetail, object: nil, userInfo: userInfo)
			} else if category == .festival {
				NotificationCenter.default.post(name: .deeplinkShowFestivalDetail, object: nil, userInfo: userInfo)
			} else if category == .nature {
				NotificationCenter.default.post(name: .deeplinkShowNatureDetail, object: nil, userInfo: userInfo)
			}
		}
	}

}
