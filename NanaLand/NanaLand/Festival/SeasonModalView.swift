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
    @State var selectedSeason = ""
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("계절 선택")
                    .font(.title02_bold)
                Spacer()
                Button {
                    Task {
                        switch selectedSeason {
                        case "봄":
                            await getSeasonFestivalMainItem(page: 0, size: 19, season: "spring")
                            season = "봄"
                        case "여름":
                            await getSeasonFestivalMainItem(page: 0, size: 19, season: "summer")
                            season = "여름"
                        case "가을":
                            await getSeasonFestivalMainItem(page: 0, size: 19, season: "autumn")
                            season = "가을"
                        case "겨울":
                            await getSeasonFestivalMainItem(page: 0, size: 19, season: "winter")
                            season = "겨울"
                        default:
                            await getSeasonFestivalMainItem(page: 0, size: 19, season: "spring")
                            season = "봄"
                        }
                    }
                    isModalShown = false
                } label: {
                    Image("icX")
                }

            }
            .padding(.leading, 17)
            .padding(.trailing, 17)
            .padding(.top, 24)
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Button {
                        selectedSeason = "봄"
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text("봄")
                                .font(selectedSeason == "봄" ? .body_bold : .body01)
                                .foregroundStyle(selectedSeason == "봄" ? Color.main : Color.black)
                                .padding(.trailing, 16)
                            if selectedSeason == "봄" {
                                Image("icCheck")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.main)
                            }
                          
                        Spacer()
                        }
                        
                    }
                    .frame(width: 100, height: 48)
                
                    Button {
                        selectedSeason = "여름"
                       
                    } label: {
                        HStack(spacing: 0) {
                            Text("여름")
                                .font(selectedSeason == "여름" ? .body_bold : .body01)
                                .foregroundStyle(selectedSeason == "여름" ? Color.main : Color.black)
                                .padding(.trailing, 16)
                            if selectedSeason == "여름" {
                                Image("icCheck")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.main)
                            }
                            Spacer()
                        }
                
                    }
                    .frame(width: 100, height: 48)
                    
                    
                    Button {
                        selectedSeason = "가을"
                       
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text("가을")
                                .font(selectedSeason == "가을" ? .body_bold : .body01)
                                .foregroundStyle(selectedSeason == "가을" ? Color.main : Color.black)
                                .padding(.trailing, 16)
                            if selectedSeason == "가을" {
                                Image("icCheck")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.main)
                            }
                            Spacer()
                        }
                        
                    }
                    .frame(width: 100, height: 48)
             
                    
                    Button {
                        selectedSeason = "겨울"
                       
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text("겨울")
                                .font(selectedSeason == "겨울" ? .body_bold : .body01)
                                .foregroundStyle(selectedSeason == "겨울" ? Color.main : Color.black)
                                .padding(.trailing, 16)
                            if selectedSeason == "겨울" {
                                Image("icCheck")
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.main)
                            }
                            Spacer()
                        }
                       
                    }
                    .frame(width: 100, height: 48)
                 
                }
                .padding(.leading, 17)
                Spacer()
            }
        }
       
        
    }
    
    func getSeasonFestivalMainItem(page: Int32, size: Int32, season: String) async {
        await viewModel.action(.getSeasonFestivalMainItem(page: page, size: size, season: season))
    }
}
