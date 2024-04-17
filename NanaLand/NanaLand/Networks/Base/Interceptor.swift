//
//  Interceptor.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

class Interceptor: RequestInterceptor {
	func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
		var urlRequest = urlRequest
		urlRequest.setValue("Bearer " + Secrets.tempAccessToken, forHTTPHeaderField: "Authorization")
		completion(.success(urlRequest))
	}
}
