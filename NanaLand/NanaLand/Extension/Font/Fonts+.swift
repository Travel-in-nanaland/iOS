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
	
	enum GothicNeo {
		case light
		case regular
		case medium
		case semibold
		case bold
		case extrabold
		case heavy
		
		var name: String {
			switch self {
			case .light:
				return "AppleSDGothicNeoL00"
			case .regular:
				return "AppleSDGothicNeoR00"
			case .medium:
				return "AppleSDGothicNeoM00"
			case .semibold:
				return "AppleSDGothicNeoSB00"
			case .bold:
				return "AppleSDGothicNeoB00"
			case .extrabold:
				return "AppleSDGothicNeoEB00"
			case .heavy:
				return "AppleSDGothicNeoH00"
			}
		}
	}
	
	/// custom Font.
	// .font(.gothicNeo(.bold, size: 12))
	static func gothicNeo(_ weight: GothicNeo = .medium, size: CGFloat) -> Font {
		return .custom(weight.name, size: size)
	}
}
