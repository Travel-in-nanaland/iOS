//
//  Fonts+.swift
//  NanaLand
//
//  Created by yoonyeosong on 4/14/24.
//

import Foundation
import SwiftUI

// 무슨폰트, 사이즈
// font(.gothicNeo(size: 18 , font: "bold") 형태로 사용
extension Font {
    static func gothicNeo(size fontSize: CGFloat, font: String) -> Font{
        
        var fontName: String
        switch font {
        case "heavy":
            fontName = "AppleSDGothicNeoH00"
        case "heavy2":
            fontName = "AppleSDGothicNeoEB00"
        case "bold":
            fontName = "AppleSDGothicNeoB00"
        case "mid":
            fontName = "AppleSDGothicNeoM00"
        case "reg":
            fontName = "AppleSDGothicNeoR00"
        case "semibold":
            fontName = "AppleSDGothicNeoSB00"
        case "light":
            fontName = "AppleSDGothicNeoL00"
        default:
            fontName = "AppleSDGothicNeoR00"
        }
        return Font.custom(fontName, size: fontSize)
    }
}
