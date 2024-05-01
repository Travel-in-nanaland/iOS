//
//  NatureMainView.swift
//  NanaLand
//
//  Created by jun on 4/16/24.
//

import SwiftUI

struct NatureMainView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "7대자연")
                .frame(height: 56)
                .padding(.bottom, 24)
        
            HStack(spacing: 0) {
                Text("2건")
                    .padding(.leading, 16)
                    .foregroundStyle(Color.gray1)
                
                Spacer()
                
                Menu {
                    Text("hello")
                } label: {
                    Text("지역")
                        .font(.gothicNeo(.medium, size: 12))
                        .padding(.leading, 12)
                    Spacer()
                    Image("icDownSmall")
                        .padding(.trailing, 12)
                }
                .foregroundStyle(Color.gray1)
                .frame(width: 70, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color.gray1, lineWidth: 1)
                )
                .padding(.trailing, 16)
            }
            .padding(.bottom, 16)
            
            NatureMainGridView()
            Spacer()
        }
        .toolbar(.hidden)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct NatureMainGridView: View {
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach((0...19), id: \.self) { _ in
                    NavigationLink(destination: NatureDetailView()) {
                        VStack(alignment: .leading) {
                            Text("photo")
                                .foregroundStyle(.black)
                            Text("title")
                                .foregroundStyle(.black)
                            Text("hashtag")
                                .foregroundStyle(.black)
                        }
                        .frame(width: (UIScreen.main.bounds.width - 40) / 2, height: 120)
                        .background(.skyBlue)
                        .padding(.leading, 0)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
}
#Preview {
    NatureMainView()
}
