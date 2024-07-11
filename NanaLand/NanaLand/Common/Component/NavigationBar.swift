//
//  NavigationBar.swift
//  NanaLand
//
//  Created by jun on 4/24/24.
//

import SwiftUI

struct NavigationBar: View {
    var title: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            HStack {
                Button (action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("icLeft")
                        .padding(.leading, 16)
                }
                )
                Spacer()
            }
            HStack{
                Text("\(title)")
                    .font(.gothicNeo(.bold, size: 20))
            }
        }
    }
}

#Preview {
    NavigationBar(title: "hello")
}
