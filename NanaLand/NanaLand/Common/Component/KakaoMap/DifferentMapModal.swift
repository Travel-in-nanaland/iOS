//
//  DifferentMapModal.swift
//  NanaLand
//
//  Created by wodnd on 2/27/25.
//

import SwiftUI

struct DifferentMapModal: View {
    @Binding var isShowingModal: Bool
    @Binding var convertedCoordinate: (Double, Double)
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                Button(action: {
                    openGoogleMapsOrWeb(latitude: convertedCoordinate.1, longitude: convertedCoordinate.0)
                    isShowingModal = false
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                        .foregroundColor(.white)
                        .shadow(radius: 1)
                        .overlay {
                            Text("구글 지도")
                                .font(.body01)
                                .foregroundColor(.black)
                        }
                })
                
                Button(action: {
                   isShowingModal = false
                }, label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: Constants.screenWidth * (328 / 360), height: Constants.screenWidth * (47 / 360))
                        .foregroundColor(.gray3)
                        .shadow(radius: 1)
                        .overlay {
                            Text(.close)
                                .font(.body01)
                                .foregroundColor(.black)
                        }
                })
            }
        }
    }
    
    func openGoogleMapsOrWeb(latitude: Double, longitude: Double) {
        let googleMapsURL = URL(string: "comgooglemaps://?center=\(latitude),\(longitude)&zoom=17")
        let webURL = URL(string: "https://www.google.com/maps/@\(latitude),\(longitude),17z")

        if let googleMapsURL = googleMapsURL, UIApplication.shared.canOpenURL(googleMapsURL) {
            UIApplication.shared.open(googleMapsURL, options: [:], completionHandler: nil)
        } else if let webURL = webURL {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    DifferentMapModal(isShowingModal: .constant(false), convertedCoordinate: .constant((0.0, 0.0)))
}
