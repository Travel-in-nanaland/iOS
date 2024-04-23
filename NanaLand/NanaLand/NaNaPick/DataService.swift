//
//  DataService.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

class DataService {
    static let shared = DataService()
    
    private let database: [TestModel] = {
        var database = [TestModel]()
        (0..<100).forEach { i in
            database.append(TestModel(i))
        }
        return database
    }()
    
    func fetchTest(page: Int, size: Int) -> (data: [TestModel], isLastPage: Bool) {
        let data = Array(database[page..<(page + size)])
        
        let isLastPage = size + page > database.count - 1 ? true : false
        return (data: data, isLastPage: isLastPage)
    }
}
