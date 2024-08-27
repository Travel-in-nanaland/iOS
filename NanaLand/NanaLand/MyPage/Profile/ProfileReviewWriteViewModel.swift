//
//  ProfileReviewWriteViewModel.swift
//  NanaLand
//
//  Created by juni on 8/27/24.
//

import Foundation
import SwiftUI
import Combine

class ProfileReviewWriteViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var debouncedText: String = ""
    
    
    private var cancellable: AnyCancellable?
    struct State {
        var getProfileReviewResponse: [ProfileReviewWriteModel] = []
    }
    
    enum Action {
        case getProfileReview(keyword: String)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
        // 리뷰 위한 게시물 검색 시 마지막 글자 입력 후 0.6초간 입력 없을 시 입력으로 간주
        cancellable = $searchText
            .debounce(for: .seconds(0.6), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.debouncedText = value
                
            }
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getProfileReview(keyword):
            let response = await ReviewService.profileReview(keyword: keyword)
            if response != nil {
                await MainActor.run {
                    state.getProfileReviewResponse = response!.data ?? [ProfileReviewWriteModel(id: 0, category: "", categoryValue: "", title: "", firstImage: ImageList(originUrl: "", thumbnailUrl: ""), address: "")]
                    print("\(state.getProfileReviewResponse)")
                }
            }
        }
    }
    
    func getProfileReview(keyword: String) {
        print("hellejlfai")
    }
}

