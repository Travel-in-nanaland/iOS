//
//  testModel.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

struct TestModel: Identifiable {
    let id = UUID()
    let text: String
    
    init(_ int: Int) {
        self.text = "\(int)"
    }
}


