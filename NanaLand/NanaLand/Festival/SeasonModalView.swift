//
//  LocationModalView.swift
//  NanaLand
//
//  Created by jun on 5/6/24.
//

import SwiftUI

struct SeasonModalView: View {
    @ObservedObject var viewModel: FestivalMainViewModel
    @EnvironmentObject var localizationManager: LocalizationManager
    
    @Binding var season: String
    @Binding var isModalShown: Bool
    @State var selectedSeason = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(.selectSeason)
                    .font(.title02_bold)
                Spacer()
                Button {
                    isModalShown = false
                } label: {
                    Image("icX")
                }

            }
            .frame(width: Constants.screenWidth - 32)
            .padding(.top, 24)
            Spacer()
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Button {
                  
                            Task {
                                viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                                await getSeasonFestivalMainItem(page: 0, size: 12, season: "spring")
                                selectedSeason = LocalizedKey.spring.localized(for: localizationManager.language)
                                viewModel.state.page = 0
                                season = selectedSeason
                            }
                           
                        
                        
                    } label: {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(.spring)
                                    .frame(height: 22)
                                    .font(selectedSeason == LocalizedKey.spring.localized(for: localizationManager.language) ? .body_bold : .body01)
                                    .foregroundStyle(selectedSeason == LocalizedKey.spring.localized(for: localizationManager.language) ? Color.main : Color.black)
                                    .padding(.trailing, 16)
                              
                            Spacer()
                            }
                            HStack(spacing: 0) {
                                Text(.springMonth)
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                            
                        }
                        .padding(.leading, 16)
                       
                        
                    }
                    .frame(width: Constants.screenWidth, height: 48)
                    .background(selectedSeason == LocalizedKey.spring.localized(for: localizationManager.language) ? .main10P : .white)
                
                    Button {
                       
                            Task {
                                viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                                selectedSeason = LocalizedKey.summer.localized(for: localizationManager.language)
                                viewModel.state.page = 0
                                await getSeasonFestivalMainItem(page: 0, size: 12, season: "summer")
                                season = selectedSeason
                            }
                           
                        
                        
                    } label: {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(.summer)
                                    .frame(height: 22)
                                    .font(selectedSeason == LocalizedKey.summer.localized(for: localizationManager.language) ? .body_bold : .body01)
                                    .foregroundStyle(selectedSeason == LocalizedKey.summer.localized(for: localizationManager.language) ? Color.main : Color.black)
                                    .padding(.trailing, 16)
                                Spacer()
                            }
                            HStack(spacing: 0) {
                                Text(.summerMonth)
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                            
                        }
                        .padding(.leading, 16)
                       
                
                    }
                    .frame(width: Constants.screenWidth, height: 48)
                    .background(selectedSeason == LocalizedKey.summer.localized(for: localizationManager.language) ? .main10P : .white)
                    
                    Button {
                
                            Task {
                                viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                                selectedSeason = LocalizedKey.autumn.localized(for: localizationManager.language)
                                viewModel.state.page = 0
                                await getSeasonFestivalMainItem(page: 0, size: 12, season: "autumn")
                                season = selectedSeason
                            }
                            
                        
                        
                    } label: {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(.autumn)
                                    .frame(height: 22)
                                    .font(selectedSeason == LocalizedKey.autumn.localized(for: localizationManager.language) ? .body_bold : .body01)
                                    .foregroundStyle(selectedSeason == LocalizedKey.autumn.localized(for: localizationManager.language) ? Color.main : Color.black)
                                    .padding(.trailing, 16)
                              
                                Spacer()
                            }
                            HStack(spacing: 0) {
                                Text(.autumnMonth)
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                            
                        }
                        .padding(.leading, 16)
                        
                        
                    }
                    .frame(width: Constants.screenWidth, height: 48)
                    .background(selectedSeason == LocalizedKey.autumn.localized(for: localizationManager.language) ? .main10P : .white)
                    
                    Button {
         
                            Task {
                                viewModel.state.getFestivalMainResponse = FestivalModel(totalElements: 0, data: [])
                                selectedSeason = LocalizedKey.winter.localized(for: localizationManager.language)
                                viewModel.state.page = 0
                                await getSeasonFestivalMainItem(page: 0, size: 12, season: "winter")
                                season = selectedSeason
                            }
                        
                        
                    } label: {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Text(.winter)
                                    .frame(height: 22)
                                    .font(selectedSeason == LocalizedKey.winter.localized(for: localizationManager.language) ? .body_bold : .body01)
                                    .foregroundStyle(selectedSeason == LocalizedKey.winter.localized(for: localizationManager.language) ? Color.main : Color.black)
                                    .padding(.trailing, 16)
                            
                                Spacer()
                            }
                            HStack(spacing: 0) {
                                Text(.winterMonth)
                                    .font(.body02)
                                    .foregroundStyle(.gray1)
                                Spacer()
                            }
                           
                        }
                        .padding(.leading, 16)
                       
                       
                    }
                    .frame(width: Constants.screenWidth, height: 48)
                    .background(selectedSeason == LocalizedKey.winter.localized(for: localizationManager.language) ? .main10P : .white)
                }
                .padding(.leading, 17)
                Spacer()
            }
            Spacer()
        }
       
        
    }
    
    func getSeasonFestivalMainItem(page: Int32, size: Int32, season: String) async {
        await viewModel.action(.getSeasonFestivalMainItem(page: page, size: size, season: season))
    }
}
