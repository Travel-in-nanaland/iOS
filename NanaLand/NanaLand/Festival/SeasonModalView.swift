//
//  LocationModalView.swift
//  NanaLand
//
//  Created by jun on 5/6/24.
//

import SwiftUI

struct SeasonModalView: View {
    @ObservedObject var viewModel: FestivalMainViewModel
    @Binding var season: String
    @Binding var isModalShown: Bool
    var body: some View {
        VStack(spacing: 0) {
            Button {
                Task {
                    await getSeasonFestivalMainItem(page: 0, size: 19, season: "spring")
                    season = "봄"
                    isModalShown = false
                }
            } label: {
                Text("봄")
            }
            .padding(.bottom, 10)
            
            Button {
                Task {
                    await getSeasonFestivalMainItem(page: 0, size: 12, season: "summer")
                    season = "여름"
                    isModalShown = false
                }
            } label: {
                Text("여름")
            }
            .padding(.bottom, 10)
            
            Button {
                Task {
                    await getSeasonFestivalMainItem(page: 0, size: 12, season: "autumn")
                    season = "가을"
                    isModalShown = false
                }
                
            } label: {
                Text("가을")
            }
            .padding(.bottom, 10)
            
            Button {
                Task {
                    await getSeasonFestivalMainItem(page: 0, size: 12, season: "winter")
                    season = "겨울"
                    isModalShown = false
                }
                
            } label: {
                Text("겨울")
            }
            .padding(.bottom, 10)

        }
    }
    
    func getSeasonFestivalMainItem(page: Int32, size: Int32, season: String) async {
        await viewModel.action(.getSeasonFestivalMainItem(page: page, size: size, season: season))
    }
}
