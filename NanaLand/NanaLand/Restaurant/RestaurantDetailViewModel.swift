//
//  RestaurantDetailViewModel.swift
//  NanaLand
//
//  Created by wodnd on 7/21/24.
//

import Foundation

class RestaurantDetailViewModel: ObservableObject {
    struct State {
        var getRestaurantDetailResponse = RestaurantDetailModel(id: 1, title: "", content: "", address: "", addressTag: "", contact: "", homepage: "", instagram: "", time: "", service: "", menus: [Menu(menuName: "", price: "", firstImage: RestaurantDetailImagesList(originUrl: "", thumbnailUrl: ""))], keywords: [""], images: [RestaurantDetailImagesList(originUrl: "", thumbnailUrl: "")], favorite: false)
        var getReviewDataResponse = ReviewModel(totalElements: 0, totalAvgRating: 0.0, data: [ReviewData(id: 0, memberId: 0, nickname: "", profileImage: ImageList(originUrl: "", thumbnailUrl: ""), memberReviewCount: 0, rating: 0, content: "", createdAt: "", heartCount: 0, images: [], reviewTypeKeywords: [], reviewHeart: false)])
    }
    
    enum Action {
        case getRestaurantDetailItem(id: Int64, isSearch: Bool)
        case getReviewData(id: Int64, category: String, page: Int, size: Int)
        case toggleFavorite(body: FavoriteToggleRequest)
        case reviewFavorite(id: Int64)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
            switch action {
            case let .getRestaurantDetailItem(id, isSearch):
                if let response = await RestaurantService.getRestaurantDetailItem(id: id, isSearch: isSearch) {
                    if let data = response.data {
                        await MainActor.run {
                            state.getRestaurantDetailResponse = data
                            print(data)
                        }
                    } else {
                        print("Data is nil")
                    }
                } else {
                    print("Error: response is nil")
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
                if let response = await FavoriteService.toggleFavorite(id: body.id, category: .restaurant) {
                    await MainActor.run {
                        state.getRestaurantDetailResponse.favorite = response.data.favorite
                    }
                } else {
                    print("Eror: response is nil")
                }
                
            case let .reviewFavorite(id):
                let response = await ReviewService.reviewFavorite(id: id)
                if let responseData = response?.data {
                    await MainActor.run {
                        if let index = state.getReviewDataResponse.data.firstIndex(where: { $0.id == id }) {
                            state.getReviewDataResponse.data[index].reviewHeart = responseData.reviewHeart
                            if responseData.reviewHeart {
                                state.getReviewDataResponse.data[index].heartCount += 1
                            } else {
                                state.getReviewDataResponse.data[index].heartCount -= 1
                            }
                            print("Updated reviewHeart for review with id: \(id)")
                        } else {
                            print("Review with id: \(id) not found")
                        }
                    }
                } else {
                    print("Response data is nil")
                }
            }
        }
}

