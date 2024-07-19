//
//  MapView.swift
//  NanaLand
//
//  Created by wodnd on 7/19/24.
//

import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var localizationManager: LocalizationManager
    var selectedLocation: [LocalizedKey]
    
    var locationArray: [LocalizedKey] {
            let unselectedLocations = [
                .jejuCity,
                .Aewol,
                .Jocheon,
                .Hangyeong,
                .Gunjwa,
                .Hallim,
                .Udo,
                .Chuja,
                .SeogwipoCity,
                .Andeok,
                .Namwon,
                .Pyoseon,
                .Seongsan
            ].filter { !selectedLocation.contains($0) }
            
            let selectedLocations = selectedLocation
            
            return unselectedLocations + selectedLocations
        }
    var body: some View {
        GeometryReader{ geo in
            ZStack {
                ForEach(locationArray, id: \.self) { location in
                    let isSelected = selectedLocation.contains(location)
                    
                    let imageName_off = getImageName(for: location, language: localizationManager.language, isSelected: isSelected)
                    Image(imageName_off)
                        .position(position(for: location))
                }
            }
        }
    }
    
    func getImageName(for locationKey: LocalizedKey, language: Language, isSelected: Bool) -> String {
        let state = isSelected ? "선택" : "기본"
        let langSuffix: String
        
        switch language {
        case .english:
            langSuffix = "영어"
        case .chinese:
            langSuffix = "중국어"
        case .korean:
            langSuffix = "한국어"
        default:
            langSuffix = "한국어"
        }
        
        let localizedLocation = locationKey.localized(for: .korean)
        
        return "\(localizedLocation)_\(state)_\(langSuffix)"
    }
    
    func position(for location: LocalizedKey) -> CGPoint {
        switch location {
        case .jejuCity:
            return CGPoint(x: 179.3, y: 201)
        case .Aewol:
            return CGPoint(x: 145.9, y: 211)
        case .Jocheon:
            return CGPoint(x: 216.3, y: 194.2)
        case .Hangyeong:
            return CGPoint(x: 63, y: 245)
        case .Gunjwa:
            return CGPoint(x: 290.9, y: 184.5)
        case .Hallim:
            return CGPoint(x: 105.8, y: 221.5)
        case .Udo:
            return CGPoint(x: 363, y: 171)
        case .Chuja:
            return CGPoint(x: 125, y: 150)
        case .SeogwipoCity:
            return CGPoint(x: 164.1, y: 268.8)
        case .Daejeong:
            return CGPoint(x: 61.7, y: 282.7)
        case .Andeok:
            return CGPoint(x: 113.4, y: 271.4)
        case .Namwon:
            return CGPoint(x: 226.9, y: 262.7)
        case .Pyoseon:
            return CGPoint(x: 260.5, y: 240.1)
        case .Seongsan:
            return CGPoint(x: 311.8, y: 221.7)
        default:
            return CGPoint(x: 0, y: 0)
        }
    }
}

#Preview {
    MapView(selectedLocation: [LocalizedKey.Hangyeong,LocalizedKey.Daejeong, LocalizedKey.Hallim, LocalizedKey.Aewol, LocalizedKey.jejuCity, LocalizedKey.Jocheon, LocalizedKey.Gunjwa, LocalizedKey.Andeok, LocalizedKey.SeogwipoCity, LocalizedKey.Namwon, LocalizedKey.Pyoseon, LocalizedKey.Seongsan])
        .environmentObject(LocalizationManager())
}
