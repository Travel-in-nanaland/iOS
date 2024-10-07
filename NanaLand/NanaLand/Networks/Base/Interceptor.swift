//
//  Interceptor.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

//class Interceptor: RequestInterceptor {
//	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
//		guard let accessToken = KeyChainManager.readItem(key: "accessToken") else {
//			// 토큰이 없는경우 로그인 화면으로 이동
//			DispatchQueue.main.async {
//				UserDefaults.standard.set(false, forKey: "isLogin")
//			}
//			
//			completion(.failure(AuthError.noToken))
//			return
//		}
//		
//		var urlRequest = urlRequest
//		urlRequest.headers.add(.authorization("Bearer \(accessToken)"))
//		print("JWT: \(accessToken)")
//		
//		completion(.success(urlRequest))
//	}
//}

class Interceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = KeyChainManager.readItem(key: "accessToken"),
              let tokenIssueDate = UserDefaults.standard.object(forKey: "tokenIssueDate") as? Date else {
            // 토큰이 없거나 발급 시간이 없는 경우: 로그인 화면으로 이동
            DispatchQueue.main.async {
                UserDefaults.standard.set(false, forKey: "isLogin")
            }
            completion(.failure(AuthError.noToken))
            return
        }
        
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(tokenIssueDate)
        
        // 토큰 발급 후 5분(300초)이 지났는지 확인
        if elapsedTime > 300 {
            Task {
                let isRefreshed = await refreshAccessToken()
                if isRefreshed, let newAccessToken = KeyChainManager.readItem(key: "accessToken") {
                    var urlRequest = urlRequest
                    urlRequest.headers.add(.authorization("Bearer \(newAccessToken)"))
                    completion(.success(urlRequest))
                } else {
                    completion(.failure(AuthError.noToken))
                }
            }
        } else {
            // 토큰이 유효한 경우 그대로 진행
            var urlRequest = urlRequest
            urlRequest.headers.add(.authorization("Bearer \(accessToken)"))
            completion(.success(urlRequest))
        }
    }
    
    // 토큰 리프레시 함수
    private func refreshAccessToken() async -> Bool {
        guard let refreshTokenResponse = await AuthService.refreshingToken() else {
            return false
        }
        
        // 갱신된 토큰 저장
        if let newAccessToken = refreshTokenResponse.data?.accessToken,
           let newRefreshToken = refreshTokenResponse.data?.refreshToken {
            KeyChainManager.updateItem(key: "accessToken", value: newAccessToken)
            KeyChainManager.updateItem(key: "refreshToken", value: newRefreshToken)
            UserDefaults.standard.set(Date(), forKey: "tokenIssueDate") // 새 발급 시간 저장
            return true
        } else {
            return false
        }
    }
}
