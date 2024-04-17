//
//  APITask.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

enum APITask {
	case requestPlain
	case requestParameters(parameters: Parameters)
	case requestJSONEncodable(body: Encodable)
}
