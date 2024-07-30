//
//  ProfileReview.swift
//  NanaLand
//
//  Created by wodnd on 7/27/24.
//

import SwiftUI

struct ProfileReviewView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    
    @Binding var searchTerm: String
    
    var body: some View {
        VStack{
            
            NavigationBar(title: LocalizedKey.write.localized(for: localizationManager.language))
                .frame(height: 56)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                .padding(.bottom, 10)
            
            ReviewSearchBar(searchTerm: .constant(""))
                .padding()

            
            Spacer()
        }
    }
}


struct ReviewSearchBar: View {
    
    @Binding var searchTerm: String
    
    let placeHolder: LocalizedKey
    let searchAction: () async -> Void
    
    init(
        placeHolder: LocalizedKey = .emptyString,
        searchTerm: Binding<String>,
        searchAction: @escaping () async -> Void = {}
    ) {
        self.placeHolder = placeHolder
        self._searchTerm = searchTerm
        self.searchAction = searchAction
    }
    
    var body: some View {
        HStack {
            TextField(text: $searchTerm, label: {
                Text(placeHolder)
                    .font(.gothicNeo(.medium, size: 14))
                    .foregroundStyle(Color.gray1)
            })
            .submitLabel(.search)
            .onSubmit {
                Task {
                    if searchTerm != "" {
                        await searchAction()
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .font(.gothicNeo(.medium, size: 14))
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(minWidth: Constants.screenWidth - 32, minHeight: 53)
                    .shadow(radius: 1)
            }
        }
    }
}
#Preview {
    ProfileReviewView(searchTerm: .constant(""))
        .environmentObject(LocalizationManager())
}
