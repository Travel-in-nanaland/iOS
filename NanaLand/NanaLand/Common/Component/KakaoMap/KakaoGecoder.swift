//
//  KakaoGecoder.swift
//  NanaLand
//
//  Created by wodnd on 2/25/25.
//

import Foundation
import SwiftUI

struct KakaoGeocoder {
    static let apiKey = 
    Secrets.kakaoMapsRestAPIKey // 🔴 여기에 본인의 Kakao REST API 키 입력

    static func convertAddressToCoordinates(address: String, completion: @escaping (Double?, Double?) -> Void) {
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://dapi.kakao.com/v2/local/search/address.json?query=\(encodedAddress)"
        
        guard let url = URL(string: urlString) else {
            print("❌ URL 생성 실패")
            completion(nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.setValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization") // 🔴 API 키 추가

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 네트워크 요청 실패: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            guard let data = data else {
                print("❌ 데이터 없음")
                completion(nil, nil)
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(KakaoAddressResponse.self, from: data)
                
                if let firstAddress = decodedResponse.documents.first {
                    let latitude = Double(firstAddress.y) ?? 0.0
                    let longitude = Double(firstAddress.x) ?? 0.0
                    print("✅ 변환된 좌표: \(latitude), \(longitude)")
                    completion(latitude, longitude)
                } else {
                    print("❌ 주소 검색 결과 없음")
                    completion(nil, nil)
                }
            } catch {
                print("❌ JSON 파싱 오류: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }
        
        task.resume()
    }
}

// 🔹 API 응답 모델
struct KakaoAddressResponse: Codable {
    let documents: [KakaoAddress]
}

struct KakaoAddress: Codable {
    let x: String // 경도
    let y: String // 위도
}
