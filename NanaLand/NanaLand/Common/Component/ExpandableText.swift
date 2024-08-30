//
//  ExpandableText.swift
//  NanaLand
//
//  Created by juni on 8/5/24.
//

import SwiftUI

struct ExpandableText: View {
    @State private var expanded: Bool = false
    @State private var truncated: Bool = false
    private var text: String

    let lineLimit: Int

    init(_ text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }

    private var moreLessText: String {
        if !truncated {
            return ""
        } else {
            return self.expanded ? LocalizedKey.folding.localized(for: LocalizationManager().language) : LocalizedKey.opening.localized(for: LocalizationManager().language)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .background(
                    Text(text).lineLimit(lineLimit)
                        .background(GeometryReader { visibleTextGeometry in
                            ZStack { //large size zstack to contain any size of text
                                Text(self.text)
                                    .background(GeometryReader { fullTextGeometry in
                                        Color.clear.onAppear {
                                            self.truncated = fullTextGeometry.size.height > visibleTextGeometry.size.height
                                        }
                                    })
                            }
                            .frame(height: .greatestFiniteMagnitude)
                        })
                        .hidden() //keep hidden
            )
            HStack(spacing: 0) {
                Spacer()
                if truncated {
                    Button(action: {
                        withAnimation(nil) {
                            expanded.toggle()
                        }
                    }, label: {
                        Text(moreLessText)
                            .font(.caption01)
                            .foregroundStyle(Color.gray1)
                    })
                    
                }
            }
            
        }
    }
}

//#Preview {
//    ExpandableText()
//}
