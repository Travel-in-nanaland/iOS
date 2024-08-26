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
    
    func request<T: Decodable>(_ endPoint: EndPoint) async -> OldBaseResponse<T>? {
        let request = makeDataRequest(endPoint)
        let result = await request.serializingData().result
        var data = Foundation.Data()
        do {
            data = try result.get()
        } catch {
            print("data fetch error")
            return nil
        }
        
        do {
            let decodedData = try data.decode(type: OldBaseResponse<T>.self, decoder: JSONDecoder())
            return decodedData
        } catch {
            print("data decode error - origin data: \(String(data: data, encoding: .utf8) ?? "")")
            return nil
        }
        
    }
    
    func request<T: Decodable>(_ endPoint: EndPoint) async -> BaseResponse<T>? {
        let request = makeDataRequest(endPoint)
        let result = await request.serializingData().result
        var data = Foundation.Data()
        do {
            print("endPoint: \(endPoint)")
            print("request: " + "\(request)\(result)")
            data = try result.get()
        } catch {
            print("data fetch error")
            return nil
        }
        
        do {
            let decodedData = try data.decode(type: BaseResponse<T>.self, decoder: JSONDecoder())
            return decodedData
        } catch {
            print("data decode error - origin data: \(String(data: data, encoding: .utf8) ?? "")")
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
        case let .requestWithoutInterceptor(body):
            if body == nil {
                return AF.request(
                    "\(endPoint.baseURL)\(endPoint.path)",
                    method: endPoint.method,
                    headers: endPoint.headers
                )
            } else {
                return AF.request(
                    "\(endPoint.baseURL)\(endPoint.path)",
                    method: endPoint.method,
                    parameters: body!,
                    encoder: JSONParameterEncoder.default,
                    headers: endPoint.headers
                )
            }
            
        case let .requestJSONWithImage(multipartFile, body, withInterceptor):
            return AF.upload(multipartFormData: { multipartFormData in
                for image in multipartFile {
                    if let image = image {
                        multipartFormData.append(image, withName: "multipartFile", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                    }
                }
                if let jsonData = try? JSONEncoder().encode(body) {
                    multipartFormData.append(jsonData, withName: "reqDto", mimeType: "application/json")
                }
            }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)")!, method: endPoint.method, headers: endPoint.headers, interceptor: withInterceptor ? Interceptor() : nil)
            // 리뷰 요청 보내기 위해서 만든 케이스(body, imageFile, parameter 까지)
        case let .requestJSONWithImageWithParam(multipartFile, body, withInterceptor, parameters):
            var urlComponents = URLComponents(string: "\(endPoint.baseURL)\(endPoint.path)")!
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
            guard let urlWithQuery = urlComponents.url else {
                fatalError("Invalid URL")
            }
            
            return AF.upload(multipartFormData: { multipartFormData in
                for image in multipartFile {
                    if let image = image {
                        multipartFormData.append(image, withName: "multipartFileList", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                    }
                }
                if let jsonData = try? JSONEncoder().encode(body) {
                    multipartFormData.append(jsonData, withName: "createReviewDto", mimeType: "application/json")
                }
            }, to: urlWithQuery, method: endPoint.method, headers: endPoint.headers, interceptor: withInterceptor ? Interceptor() : nil)
            
            //리뷰 수정 보내기 위함 함수
        case let .requestModifyJSONWithImage(multipartFile, body, withInterceptor):
            
            return AF.upload(multipartFormData: { multipartFormData in
                for image in multipartFile {
                    if let image = image {
                        multipartFormData.append(image, withName: "imageList", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                    }
                }
                if let jsonData = try? JSONEncoder().encode(body) {
                    multipartFormData.append(jsonData, withName: "editReviewDto", mimeType: "application/json")
                }
            }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)")!, method: endPoint.method, headers: endPoint.headers, interceptor: withInterceptor ? Interceptor() : nil)
        case let .requestJSONWithImageList(multipartFile, body, withInterceptor):
                    return AF.upload(multipartFormData: { multipartFormData in
                        for image in multipartFile {
                            if let image = image {
                                multipartFormData.append(image, withName: "multipartFileList", fileName: "\(image).jpeg", mimeType: "image/jpeg")
                            }
                        }
                        if let jsonData = try? JSONEncoder().encode(body) {
                            multipartFormData.append(jsonData, withName: "reqDto", mimeType: "application/json")
                        }
                    }, to: URL(string: "\(endPoint.baseURL)\(endPoint.path)")!, method: endPoint.method, headers: endPoint.headers, interceptor: withInterceptor ? Interceptor() : nil)
        }
    }
}
