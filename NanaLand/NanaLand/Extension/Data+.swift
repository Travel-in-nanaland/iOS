//
//  Data+.swift
//  NanaLand
//
//  Created by 정현우 on 4/17/24.
//

import Foundation
import Alamofire

extension Data {
	func decode<Item: Decodable, Decoder: DataDecoder>(type: Item.Type, decoder: Decoder = JSONDecoder()) throws -> Item {
		try decoder.decode(type, from: self)
	}
}
