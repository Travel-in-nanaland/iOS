//
//  ExperienceDetailViewModel.swift
//  NanaLand
//
//  Created by juni on 7/19/24.
//

import Foundation

class ExperienceDetailViewModel: ObservableObject {
    struct State {
        var getExperienceDetailResponse = ExperienceDetailModel(id: 0, title: "", content: "", address: "", addressTag: "", contact: "", homepage: "", time: "", amenity: "", details: "", keywords: [""], images: [], favorite: false)
        var getReviewDataResponse = ReviewModel(totalElements: 0, totalAvgRating: 0.0, data: [ReviewData(id: 0, memberId: 0, nickname: "", profileImage: ImageList(originUrl: "", thumbnailUrl: ""), memberReviewCount: 0, rating: 0, content: "", createdAt: "", heartCount: 0, images: [], reviewTypeKeywords: [], reviewHeart: false)])
    }
    
    enum Action {
        case getExperienceDetailItem(id: Int64, isSearch: Bool)
        case getReviewData(id: Int64, category: String, page: Int, size: Int)
        case toggleFavorite(body: FavoriteToggleRequest)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getExperienceDetailItem(id, isSearch):
            let response = await ExperienceService.getExperienceDetailItem(id: id, isSearch: isSearch)
            if response != nil {
                await MainActor.run {
                    state.getExperienceDetailResponse = response!.data!
                    print("\(state.getExperienceDetailResponse)")
                }
            } else {
                print("Error")
            }
        case let .getReviewData(id, category, page, size):
            let response = await ReviewService.getReviewData(id: id, category: category, page: page, size: size)
            if response != nil {
                await MainActor.run {
                    state.getReviewDataResponse = response!.data!
                    print(response!.data!)
                }
            }
        case .toggleFavorite(body: let body):
            let response = await FavoriteService.toggleFavorite(id: body.id, category: .experience)
            if response != nil {
                await MainActor.run {
                    state.getExperienceDetailResponse.favorite = response!.data.favorite
                }
            }
        }
    }
    
}
