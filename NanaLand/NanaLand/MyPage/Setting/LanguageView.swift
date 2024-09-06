import SwiftUI

struct LanguageView: View {
    @StateObject var viewModel = LanguageViewModel()
    @State private var showAlert = false
  
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: .languageSetting, showBackButton: true)
                .padding(.bottom, 32)
            
            HStack(spacing: 0) {
                Text(viewModel.mainDescription)
                    .padding(.leading, 16)
                    .font(.title2)
                Spacer()
            }
            .padding(.bottom, 24)
            
            VStack(spacing: 0) {
                if let selectedLanguage = viewModel.state.selectedLanguage {
                    languageButton(language: selectedLanguage)
                }
                ForEach(Language.allCases.filter { $0 != viewModel.state.selectedLanguage }, id: \.self) { language in
                    languageButton(language: language)
                }
            }
            Spacer()
        }
        .toolbar(.hidden)
        .onAppear {
            viewModel.action(.viewOnAppear)
        }
        .fullScreenCover(isPresented: $showAlert) {
            AlertView(
                title: .changeLanguageAlertTitle,
                leftButtonTitle: .yes,
                rightButtonTitle: .no,
                leftButtonAction: {
                    viewModel.action(.changeLanguage)
                    showAlert = false
                },
                rightButtonAction: {
                    viewModel.action(.cancelChange)
                    showAlert = false
                }
            )
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
        } //애니메이션 효과 없애기
    }
    
    private func languageButton(language: Language) -> some View {
        Button(action: {
            showAlert = true
            viewModel.action(.selectLanguage(language: language))
        }, label: {
            HStack {
                Text(language.name)
                    .padding(.leading, 16)
                    .font(.body01)
                    .foregroundStyle(language == viewModel.state.selectedLanguage ? .main : .black)
                
                Spacer()
            }
        })
        .frame(height: 50)
        .background(language == viewModel.state.selectedLanguage ? .main10P : .baseWhite)
    }
}

#Preview {
    LanguageView()
}
