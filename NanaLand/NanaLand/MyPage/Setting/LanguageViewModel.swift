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
        case cancelChange // 언어 변경 취소
    }
    
    @Published var state: State
    @Published var mainDescription: String = LocalizedKey.languageMainDescription.localized(for: .korean) // 기본 언어 설정
    private var tempSelectedLanguage: Language? // 임시로 선택된 언어
    
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
            tempSelectedLanguage = language // 임시로 언어 저장
        case .changeLanguage:
            changeLanguage()
        case .cancelChange:
                    tempSelectedLanguage = nil // 언어 변경 취소
        }
    }
    
    private func selectLanguage(language: Language) {
        state.selectedLanguage = language
    }
    
    private func changeLanguage() {
            if let selectedLanguage = tempSelectedLanguage { // 최종적으로 언어를 변경
                state.selectedLanguage = selectedLanguage
                Task {
                    await LocalizationManager.shared.setLanguage(selectedLanguage)
                    let response = await UserInfoService.getUserInfo()
                    if response != nil {
                        await MainActor.run {
                            AppState.shared.userInfo = response!.data
                        }
                    }
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
