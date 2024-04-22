//
//  NetworkManager.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

class NetworkManager {
	static let shared = NetworkManager()
	
	func request<T: Decodable>(_ endPoint: EndPoint) async -> BaseResponse<T>? {
		let request = makeDataRequest(endPoint)
		let result = await request.serializingData().result
		var data = Foundation.Data()
		do {
			data = try result.get()
            print(request)
            print(data)
		} catch {
			return nil
		}
		
		do {
			let decodedData = try data.decode(type: BaseResponse<T>.self, decoder: JSONDecoder())
			return decodedData
		} catch {
            return nil
		}
		
	}
	
	private func makeDataRequest(_ endPoint: EndPoint) -> DataRequest {
		switch endPoint.task {
		case .requestPlain:
			return AF.request(
			  "\(endPoint.baseURL)\(endPoint.path)",
			  method: endPoint.method,
			  headers: endPoint.headers,
			  interceptor: Interceptor()
			)
		case let .requestParameters(parameters):
			return AF.request(
			  "\(endPoint.baseURL)\(endPoint.path)",
			  method: endPoint.method,
			  parameters: parameters,
			  encoding: URLEncoding.default,
			  headers: endPoint.headers,
			  interceptor: Interceptor()
			)
		case let .requestJSONEncodable(body):
			return AF.request(
			  "\(endPoint.baseURL)\(endPoint.path)",
			  method: endPoint.method,
			  parameters: body,
			  encoder: JSONParameterEncoder.default,
			  headers: endPoint.headers,
			  interceptor: Interceptor()
			)
		}
	}
}
