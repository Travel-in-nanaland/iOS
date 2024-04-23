//
//  NaNaPickMainViewModel.swift
//  NanaLand
//
//  Created by jun on 4/18/24.
//

import Foundation

class NaNaPickMainViewModel: ObservableObject {
    struct State {
        var getNaNaPickResponse = NaNaPickModel(data: [ImageInfo(id: 6, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/3.png"),
                                                      ImageInfo(id: 7, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/4.png"),
                                                      ImageInfo(id: 5, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/2.png"),
                                                      ImageInfo(id: 1, thumbnailUrl: "https://nanaland-image-bucket.s3.ap-northeast-2.amazonaws.com/images/1.png")])
    }
    
    enum Action {
        case getNaNaPick(page: Int, size: Int)
    }
    
    @Published var state: State
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) async {
        switch action {
        case let .getNaNaPick(page, size):
            
            let data = await NaNaPickService.getNaNaPick(page: page, size: size)
           
            if data != nil {
                await MainActor.run {
                    state.getNaNaPickResponse.data.append(contentsOf: data!.data.data)
                    
                }
            } else {
                print("Error")
            }
           
            
        }
    }
}
