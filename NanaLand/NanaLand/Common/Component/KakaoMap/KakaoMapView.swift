//
//  KakaoMapView.swift
//  NanaLand
//
//  Created by wodnd on 2/24/25.
//

import SwiftUI
import KakaoMapsSDK

struct KakaoMapView: View {
    @State private var draw: Bool = false //지도 Appear 토글
    @State var convertedCoordinate: (Double, Double) = (0.0, 0.0) //DetailView에서 받은 좌표
    let title: String
    let address: String
    let koreanAddress: String
    
    var body: some View {
        ZStack{
            
            KakaoMapController(draw: $draw, coordinate: $convertedCoordinate)
                .onAppear {
                    print("🟢 KakaoMap appeared")
                    self.draw = true
                }
                .onDisappear {
                    print("🔴 KakaoMap disappeared")
                    self.draw = false
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack{
                NanaNavigationBar(title: .empty, showBackButton: true)
                    .frame(height: 56)
                
                Spacer()
            }
            
            VStack{
                Spacer()
                
                KakaoMapBottomView(title: title, address: address, koreanAddress: koreanAddress)
            }
        }
        .toolbar(.hidden)
        .onAppear(){
            convertAddressWithKakaoAPI(address: koreanAddress)
        }
    }
    
    /// 📌 **카카오 API를 사용하여 도로명 주소를 위도/경도로 변환**
    func convertAddressWithKakaoAPI(address: String) {
        print("📍 입력한 주소: \(address)")
        
        KakaoGeocoder.convertAddressToCoordinates(address: address) { latitude, longitude in
            DispatchQueue.main.async {
                if let lat = latitude, let lon = longitude {
                    self.convertedCoordinate = (lon, lat) // 🔄 위도, 경도 저장
                    print("✅ 변환된 좌표: \(lon), \(lat)")
                } else {
                    print("❌ 변환된 좌표 없음")
                }
            }
        }
    }
}


struct KakaoMapBottomView: View {
    let title: String
    let address: String
    let koreanAddress: String
    @EnvironmentObject var localizationManager: LocalizationManager
    
    @State var showCopyAlert: Bool = false
    @State var alertMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .font(.body_bold)
                .foregroundColor(.black)
                .frame(height: Constants.screenWidth * (26 / 360))
            
            if address != "" {
                Text(address)
                    .font(.caption01)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.gray1)
            }
            
            Button(action: {
                copyToClipboard(koreanAddress)
            }, label: {
                HStack(spacing: 4){
                    Text(koreanAddress)
                        .font(.body02)
                        .foregroundColor(.black)
                        .frame(height: Constants.screenWidth * (22 / 360))
                    
                    Image("icCopy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.screenWidth * (14 / 360))
                    
                    Spacer()
                }
                .padding(.top, Constants.screenWidth * (12 / 360))
            })
            .alert(isPresented: $showCopyAlert) {
                Alert(title: Text(.notification), message: Text(alertMessage), dismissButton: .default(Text(.check)))
            }
        }
        .padding(.leading, Constants.screenWidth * (16 / 360))
        .padding(.trailing, Constants.screenWidth * (16 / 360))
        .padding(.top, Constants.screenWidth * (16 / 360))
        .padding(.bottom, Constants.screenWidth * (16 / 360))
        .background(){
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(16, corners: .topLeft)
                .cornerRadius(16, corners: .topRight)
                .frame(width: Constants.screenWidth)
        }
    }
    
    func copyToClipboard(_ text: String){
        
        // 문자열이 비어있는 경우 예외처리
        guard !text.isEmpty else {
            alertMessage = ClipboardCopyStatus.emptyString.message(using: localizationManager)
            showCopyAlert = true
            return
        }
        
        if UIPasteboard.general.hasStrings {
            //복사 성공
            UIPasteboard.general.string = text
            alertMessage = ClipboardCopyStatus.success.message(using: localizationManager)
        } else {
            // 접근 권한 없어 복사 실패
            alertMessage = ClipboardCopyStatus.success.message(using: localizationManager)
        }
        
        showCopyAlert = true
    }
}

enum ClipboardCopyStatus{
    case success
    case emptyString
    case failAccess
    
    func message(using localizationManager: LocalizationManager) -> String {
        switch self {
        case .success:
            return LocalizedKey.copySuccess.localized(for: localizationManager.language)
        case .emptyString:
            return LocalizedKey.emptyCopyString.localized(for: localizationManager.language)
        case .failAccess:
            return LocalizedKey.failAccess.localized(for: localizationManager.language)
        }
    }
}

#Preview {
    KakaoMapView(title: "", address: "", koreanAddress: "")
}
