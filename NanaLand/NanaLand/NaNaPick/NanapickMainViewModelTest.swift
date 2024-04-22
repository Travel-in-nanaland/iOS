//
//  NanapickMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

class NanapickMainViewModelTest: ObservableObject {
    @Published var data = [TestModel]()
    
    private let dataPerPage = 5 // page 별 데이터
    private var nextIndex = 0 // 다음 page의 첫 index
    var isLastPage: Bool = false // 현재 page가 마지막 페이지인지 여부
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        
        guard isLastPage == false else { return } // 현재 페이지가 마지막이면 API 호출 x
        
        let fetchedData = DataService.shared.fetchTest(page: nextIndex, size: dataPerPage)
        
        data.append(contentsOf: fetchedData.data)
        
        nextIndex += dataPerPage
        isLastPage = fetchedData.isLastPage
        
            
    }
}
