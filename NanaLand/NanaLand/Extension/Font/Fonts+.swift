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

extension Font {
	static var largeTitle01: Font {
		return .gothicNeo(.bold, size: 28)
	}
	
	static var largeTitle02: Font {
		return .gothicNeo(.bold, size: 22)
	}
	
	static var largeTitle02_regular: Font {
		return .gothicNeo(.regular, size: 22)
	}
	
	static var title01_bold: Font {
		return .gothicNeo(.bold, size: 20)
	}
	
	static var title02: Font {
		return .gothicNeo(.medium, size: 18)
	}
	
	static var title02_bold: Font {
		return .gothicNeo(.bold, size: 18)
	}
	
	static var body_bold: Font {
		return .gothicNeo(.bold, size: 16)
	}
	
	static var body_semibold: Font {
		return .gothicNeo(.semibold, size: 16)
	}
	
	static var body01: Font {
		return .gothicNeo(.medium, size: 16)
	}
	
	static var body02_bold: Font {
		return .gothicNeo(.bold, size: 14)
	}
	
	static var body02_semibold: Font {
		return .gothicNeo(.semibold, size: 14)
	}
	
	static var body02: Font {
		return .gothicNeo(.medium, size: 14)
	}
	
	static var caption01: Font {
		return .gothicNeo(.medium, size: 12)
	}
	
	static var caption01_semibold: Font {
		return .gothicNeo(.semibold, size: 12)
	}
	
	static var caption02: Font {
		return .gothicNeo(.medium, size: 10)
	}
	
	static var caption02_semibold: Font {
		return .gothicNeo(.semibold, size: 10)
	}
}
