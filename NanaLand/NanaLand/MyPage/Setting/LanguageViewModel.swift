//
//  LanguageViewModel.swift
//  NanaLand
//
//  Created by jun on 5/27/24.
//

import Foundation

class LanguageViewModel: ObservableObject {
    struct State {
        var selectedLanguage: Language? = nil
    }
    
    enum Action {
        case viewOnAppear
        case selectLanguage(language: Language)
        case changeLanguage
    }
    
    @Published var state: State
    @Published var mainDescription: String = LocalizedKey.languageMainDescription.localized(for: .korean) // 기본 언어 설정
    
    init(
        state: State = .init()
    ) {
        self.state = state
    }
    
    func action(_ action: Action) {
        switch action {
        case .viewOnAppear:
            getLocaleFromUserDefaults()
        case let .selectLanguage(language):
            selectLanguage(language: language)
        case .changeLanguage:
            changeLanguage()
        }
    }
    
    private func selectLanguage(language: Language) {
        state.selectedLanguage = language
    }
    
    private func changeLanguage() {
        if let selectedLanguage = state.selectedLanguage {
            Task {
                await LocalizationManager.shared.setLanguage(selectedLanguage)
                // 언어 변경 후 유저 정보 다시 받아오기
                let response = await UserInfoService.getUserInfo()
                if response != nil {
                    await MainActor.run {
                        print(response!.data)
                        AppState.shared.userInfo = response!.data
                    }
                }
                // 언어 변경 후 설명 업데이트
                await MainActor.run {
                    self.updateDescription()
                }
            }
        }
    }
    
    private func getLocaleFromUserDefaults() {
        let languageCode = UserDefaults.standard.string(forKey: "locale") ?? ""
        if let language = Language(rawValue: languageCode) {
            state.selectedLanguage = language
            updateDescription() // 저장된 언어에 따라 설명 업데이트
        }
    }
    
    private func updateDescription() {
        if let selectedLanguage = state.selectedLanguage {
            mainDescription = LocalizedKey.languageMainDescription.localized(for: selectedLanguage)
        }
    }
}
