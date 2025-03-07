//
//  KakaoMapView.swift
//  NanaLand
//
//  Created by wodnd on 2/24/25.
//

import SwiftUI
import KakaoMapsSDK

struct KakaoMapView: View {
    @State private var draw: Bool = false // 지도 Appear 토글
    @State private var convertedCoordinate: (Double, Double)? = nil // 초기에는 nil
    @State var isShowingModal: Bool = false
    
    let title: String
    let address: String
    let koreanAddress: String
    
    var body: some View {
        ZStack {
            if let coordinate = convertedCoordinate {
                // ✅ 위도/경도를 받은 후에만 지도를 띄움
                KakaoMapController(draw: $draw, coordinate: .constant(coordinate))
                    .onAppear {
                        print("🟢 KakaoMap appeared")
                        self.draw = true
                    }
                    .onDisappear {
                        print("🔴 KakaoMap disappeared")
                        self.draw = false
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // ✅ 위도/경도를 받을 때까지 로딩 화면 표시
                VStack {
                    ProgressView("Loading map...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            
            VStack {
                NanaNavigationBar(title: .empty, showBackButton: true)
                    .frame(height: 56)
                
                Spacer()
            }
            
            VStack {
                Spacer()
                
                HStack(spacing: 0){
                    
                    Spacer()
                    
                    Button {
                        isShowingModal.toggle()
                    } label: {
                        HStack(spacing: 0){
                            Text(.differentMap)
                                .font(.caption01_semibold)
                                .foregroundColor(.main)
                                .frame(height: Constants.screenWidth * (20 / 360))
                            
                            Image("icMainArrow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: Constants.screenWidth * (12 / 360))
                        }
                        .padding(.top, Constants.screenWidth * (8 / 360))
                        .padding(.bottom, Constants.screenWidth * (8 / 360))
                        .padding(.leading, Constants.screenWidth * (13.5 / 360))
                        .padding(.trailing, Constants.screenWidth * (13.5 / 360))
                        .background(){
                            RoundedRectangle(cornerRadius: 100)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.trailing, Constants.screenWidth * (16 / 360))
                    .padding(.bottom, Constants.screenWidth * (12 / 360))
                }
                .sheet(isPresented: $isShowingModal) {
                    if let coordinate = convertedCoordinate {
                        DifferentMapModal(isShowingModal: $isShowingModal, convertedCoordinate: .constant(coordinate))
                            .environmentObject(LocalizationManager())
                            .presentationDetents([.height(Constants.screenWidth * (140 / 360))]) // 팝업 뷰 height 조절
                    }
                }

                
                KakaoMapBottomView(title: title, address: address, koreanAddress: koreanAddress)
            }
        }
        .toolbar(.hidden)
        .onAppear {
            Task {
                // ✅ Kakao Geocoder API를 호출하고 변환된 좌표를 저장
                await fetchCoordinates()
            }
        }
    }
    
    /// 📌 **카카오 API를 사용하여 도로명 주소를 위도/경도로 변환**
    func fetchCoordinates() async {
        print("📍 입력한 주소: \(koreanAddress)")
        
        KakaoGeocoder.convertAddressToCoordinates(address: koreanAddress) { latitude, longitude in
            DispatchQueue.main.async {
                if let lat = latitude, let lon = longitude {
                    self.convertedCoordinate = (lon, lat) // ✅ 좌표 설정
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
    
    @State private var isShowingToast: Bool = false
    @State private var toastMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text(title)
                .font(.body_bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            if !address.isEmpty {
                Text(address)
                    .font(.caption01)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.gray1)
            }
            
            Button(action: {
                copyToClipboard(koreanAddress)
            }, label: {
                HStack(spacing: 4){
                    Text(koreanAddress)
                        .font(.body02)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                    
                    Image("icCopy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.screenWidth * (14 / 360))
                    
                    Spacer()
                }
                .padding(.top, Constants.screenWidth * (12 / 360))
            })
        }
        .padding(.leading, Constants.screenWidth * (16 / 360))
        .padding(.trailing, Constants.screenWidth * (16 / 360))
        .padding(.top, Constants.screenWidth * (16 / 360))
        .padding(.bottom, Constants.screenWidth * (16 / 360))
        .background {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(16, corners: .topLeft)
                .cornerRadius(16, corners: .topRight)
                .frame(width: Constants.screenWidth)
        }
        .overlay(
            Toast(message: toastMessage, isShowing: $isShowingToast)
        )
    }
    
    func copyToClipboard(_ text: String){
        guard !text.isEmpty else {
            toastMessage = ClipboardCopyStatus.emptyString.message(using: localizationManager)
            showToast()
            return
        }
        
        if UIPasteboard.general.hasStrings {
            UIPasteboard.general.string = text
            toastMessage = ClipboardCopyStatus.success.message(using: localizationManager)
        } else {
            toastMessage = ClipboardCopyStatus.failAccess.message(using: localizationManager)
        }
        
        showToast()
    }
    
    func showToast() {
        isShowingToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isShowingToast = false
        }
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
