//
//  AuthorizeView.swift
//  NanaLand
//
//  Created by jun on 5/23/24.
//

import SwiftUI

struct AuthorizeView: View {
    var body: some View {
        VStack(spacing: 0) {
            NanaNavigationBar(title: "접근 권한 안내", showBackButton: true)
                .padding(.bottom, 32)
            ScrollView {
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        Text("나나랜드인제주 사용을 위해\n다음 접근 권한 허용이 필요합니다.")
                            .padding(.leading, 16)
                    }
                    Spacer()
                }
                
                Divider()
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                
                VStack(spacing: 16) {
                    AuthorizeItemView(title: "전화 기기 정보 (필수)", content: "휴대폰 상태 및 ID 검증을 위해 접근 권한이 필요합니다.\n단말기 위변조 탐지 솔루션 제공시 필요합니다.")
                    VStack(spacing: 4) {
                        HStack(alignment: .center, spacing: 0) {
                            Image("icWarningCircle")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.main)
                                .padding(.trailing, 4)
                            Text("알려드립니다.")
                                .foregroundStyle(.main)
                                .font(.caption01_semibold)
                                .frame(height: 24)
                                
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.leading, 8)
                        
                        HStack(spacing: 0) {
                            Text("필수적 접근권한은 나나랜드인제주 서비스 이용에 반드시 필요하며, 권한이 거부되면 서비스 이용이 제한되는 점 안내드립니다.")
                                .font(.caption01)
                                .padding(.leading, 8)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        
                    }
                    .frame(width: Constants.screenWidth - 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.main10P)
                    )
                    .padding(.bottom, 16)
                    
                    AuthorizeItemView(title: "저장공간 (선택)", content:"사진 저장 기능을 제공하기 위해 필요합니다.")
                    AuthorizeItemView(title: "위치정보 (선택)", content:"현재 위치기반으로 주변 맛집 관광지 등 정보를 제공하기 위해 필요합니다.")
                    AuthorizeItemView(title: "카메라 (선택)", content:"리뷰 사진 등록 및 맛집정보 등록을 위해 필요합니다.")
                    AuthorizeItemView(title: "알림 (선택)", content:"이벤트 및 혜택정보 알림 수신을 위해 필요합")
                    AuthorizeItemView(title: "오디오 및 음악 (선택)", content:"영상 콘텐츠 등록을 위해 필요합니다.")
                    VStack(spacing: 4) {
                        HStack(alignment: .center, spacing: 0) {
                            Image("icWarningCircle")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundStyle(Color.main)
                                .padding(.trailing, 4)
                            Text("알려드립니다.")
                                .foregroundStyle(.main)
                                .font(.caption01_semibold)
                                .frame(height: 24)
                                
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.leading, 8)
                        
                        HStack(spacing: 0) {
                            Text("선택적 접근 권한에 동의하지 않으셨을 경우에,  나나랜드인제주 서비스의 일부 기능을 제한 받으실 수 있는 점 안내드립니다.")
                                .font(.caption01)
                                .padding(.leading, 8)
                                .padding(.bottom, 8)
                            Spacer()
                        }
                        
                    }
                    .frame(width: Constants.screenWidth - 32)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.main10P)
                    )
                    .padding(.bottom, 16)
                }
            }
            
            
            
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}



struct AuthorizeItemView: View {
    var title = ""
    var content = ""
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Text(title)
                    .font(.body02_semibold)
                    .padding(.leading, 16)
                Spacer()
            }
            HStack(spacing: 0) {
                Text(content)
                    .font(.caption01)
                    .foregroundStyle(.gray1)
                    .padding(.leading, 16)
                Spacer()
            }
        }
    }
}
#Preview {
    AuthorizeView()
}
