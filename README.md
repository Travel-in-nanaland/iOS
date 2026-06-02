# NanaLand in Jeju

![Swift](https://img.shields.io/badge/Swift-5-orange?style=flat-square)
![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-blue?style=flat-square)
![iOS](https://img.shields.io/badge/iOS-16.0%2B-black?style=flat-square)
![SPM](https://img.shields.io/badge/Dependency-Swift%20Package%20Manager-green?style=flat-square)

<img width="185" height="400" alt="400x800bb" src="https://github.com/user-attachments/assets/a2bead80-a43d-440c-8f54-bc31e4872577" /> <img width="185" height="400" alt="400x800bb-2" src="https://github.com/user-attachments/assets/e902b13e-7867-4f60-90eb-6d309967d5e2" /> <img width="185" height="400" alt="400x800bb-3" src="https://github.com/user-attachments/assets/25fded8d-5cec-48a3-989b-48f3b74b636d" /> <img width="185" height="400" alt="400x800bb-4" src="https://github.com/user-attachments/assets/bfaaf035-1feb-4b93-9562-c4c29be8ee2b" /> <img width="185" height="400" alt="400x800bb-5" src="https://github.com/user-attachments/assets/8920e8b1-21b8-403b-a53e-f0cf54cb0a33" /> <img width="185" height="400" alt="400x800bb-6" src="https://github.com/user-attachments/assets/b79e26c8-ed87-4f2a-8e7d-037492c13d93" />

제주 여행자를 위한 맞춤형 콘텐츠 탐색 앱, **NanaLand**의 iOS 프로젝트입니다.  
제주의 자연, 축제, 전통시장, 액티비티, 문화예술, 맛집 정보를 다국어로 제공하고, 사용자 여행 타입과 취향에 맞춘 추천 경험을 제공합니다.

## 프로젝트 한눈에 보기

| 항목 | 내용 |
| --- | --- |
| 앱 이름 | NanaLand |
| 플랫폼 | iOS 16.0 이상 |
| UI | SwiftUI |
| 아키텍처 | View, ViewModel, Service, EndPoint 기반의 MVVM 스타일 |
| 네트워킹 | Alamofire + async/await |
| 인증 | Kakao Login, Google Sign-In, Apple Login, 비회원 로그인 |
| 주요 외부 서비스 | Firebase, FCM, Firebase Remote Config, Kakao Maps |
| 다국어 | 한국어, 영어, 중국어, 말레이어, 베트남어 |

## 주요 기능

### 여행 콘텐츠 탐색

- 홈 배너, 검색, 알림 진입점 제공
- 제주 7대 자연, 축제, 전통시장, 액티비티, 문화예술, 맛집 카테고리 탐색
- 지역, 키워드, 시즌 등 콘텐츠별 필터링
- 상세 화면에서 지도, 이미지, 운영 정보, 리뷰, 공유 링크 제공

### NaNa Pick

- NanaLand가 큐레이션한 제주 추천 콘텐츠
- 기획전, 특집 콘텐츠, 상세 콘텐츠 탐색
- 딥링크 기반 공유 플로우 지원

### 사용자 경험

- 언어 선택 후 온보딩 진행
- 로그인, 회원가입, 약관 동의, 닉네임 및 프로필 설정
- 여행 타입 테스트와 타입별 추천 장소 제공
- 즐겨찾기, 리뷰 작성, 리뷰 조회 및 삭제
- 마이페이지에서 프로필, 리뷰, 공지사항, 설정 관리

### 운영 및 안정성

- Firebase Remote Config를 통한 최소 지원 버전 확인
- FCM 기반 푸시 알림
- Access Token, Refresh Token 기반 인증 갱신
- Pre-signed URL 기반 파일 업로드
- 신고 및 정보 수정 요청 플로우

## 기술 스택

| 영역 | 사용 기술 |
| --- | --- |
| UI | SwiftUI, SwiftUIIntrospect |
| Network | Alamofire |
| Image | Kingfisher, SDWebImageSwiftUI |
| Animation | Lottie |
| Auth | Kakao SDK, GoogleSignIn, FirebaseAuth, SwiftJWT |
| Map | KakaoMapsSDK |
| Backend 연동 | REST API, multipart upload, S3 pre-signed upload |
| Push & Config | FirebaseMessaging, FirebaseRemoteConfig |
| Layout | MasonryStack |
| Calendar | SwiftUICalendar |

## 폴더 구조

```text
NanaLand/
├── App/                 # 앱 진입점, 스플래시, 탭, 전역 상태
├── Onboarding/          # 언어 선택, 로그인, 회원가입, 여행 타입 테스트
├── Home/                # 홈, 검색, 알림, 추천 콘텐츠
├── Nature/              # 제주 자연 콘텐츠
├── Festival/            # 축제 콘텐츠
├── Shop/                # 전통시장 콘텐츠
├── Experience/          # 액티비티, 문화예술 콘텐츠
├── Restaurant/          # 맛집 콘텐츠
├── NaNaPick/            # 큐레이션 콘텐츠
├── Favorite/            # 즐겨찾기
├── Review/              # 리뷰 작성, 리뷰 목록, 리뷰 상세
├── MyPage/              # 프로필, 설정, 공지사항, 내 리뷰
├── Report/              # 신고
├── ReportInfo/          # 정보 수정 요청
├── Networks/            # API EndPoint, Service, NetworkManager
├── Common/              # 공통 컴포넌트, 유틸, 로컬라이징, Lottie
├── Extension/           # SwiftUI/UIKit 확장, 폰트, 색상
└── Assets.xcassets/     # 이미지, 아이콘, 컬러, 앱 아이콘
```

## 앱 흐름

```text
NanaLandApp
  └─ NanaHome
      ├─ SplashView
      ├─ LanguageSelectView
      ├─ RegisterNavigationView
      ├─ LoginView
      └─ NanaLandTabView
          ├─ HomeMainView
          ├─ FavoriteMainView
          ├─ NewNanaPickMainView
          └─ ProfileMainView
```

앱 시작 시 토큰 갱신, 사용자 정보 조회, Firebase Remote Config 기반 버전 체크가 진행됩니다. 이후 언어 선택 여부, 회원가입 필요 여부, 로그인 여부에 따라 온보딩 또는 메인 탭으로 이동합니다.

## 네트워크 구조

NanaLand의 API 호출은 다음 흐름을 따릅니다.

```text
View
  → ViewModel.action(...)
  → Service
  → EndPoint
  → NetworkManager
  → BaseResponse / OldBaseResponse
```

- `EndPoint`는 `baseURL`, `path`, `method`, `headers`, `task`를 정의합니다.
- `APITask`는 일반 요청, 파라미터 요청, JSON Body 요청, multipart 이미지 업로드, pre-signed URL 업로드를 지원합니다.
- `NetworkManager`는 Alamofire 요청을 생성하고 응답을 `Decodable` 모델로 변환합니다.
- 인증이 필요한 요청은 `Interceptor`를 통해 토큰을 처리합니다.

## 실행 방법

### 1. 프로젝트 열기

```bash
open NanaLand/NanaLand.xcodeproj
```

또는 Xcode에서 `NanaLand/NanaLand.xcodeproj`를 직접 엽니다.

### 2. 패키지 의존성 설치

Xcode가 Swift Package Manager 의존성을 자동으로 해석합니다.  
필요한 경우 아래 메뉴를 실행합니다.

```text
File > Packages > Resolve Package Versions
```

### 3. 필수 설정 파일 확인

실행 전 아래 설정 파일과 키가 올바르게 준비되어 있어야 합니다.

| 파일 또는 값 | 용도 |
| --- | --- |
| `GoogleService-Info.plist` | Firebase 초기화 |
| `Common/Util/secret.swift` | 서버 주소, Kakao, Apple, 딥링크 등 민감 설정 |
| Apple `.p8` 키 파일 | Apple 로그인 JWT 생성 |
| 앱 서명 설정 | 실제 기기 실행 및 푸시 알림 |

민감 정보는 저장소 외부에서 전달받거나 팀의 별도 관리 방식에 따라 구성합니다.

### 4. 빌드 및 실행

1. Xcode에서 `NanaLand` scheme을 선택합니다.
2. 시뮬레이터 또는 실제 기기를 선택합니다.
3. `Cmd + R`로 실행합니다.

푸시 알림, Kakao Maps, 소셜 로그인 일부 기능은 실제 기기와 올바른 번들 ID, URL Scheme, 인증서 설정이 필요할 수 있습니다.

## 테스트

프로젝트에는 기본 단위 테스트와 UI 테스트 타깃이 포함되어 있습니다.

```bash
xcodebuild test \
  -project NanaLand/NanaLand.xcodeproj \
  -scheme NanaLand \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

사용 가능한 시뮬레이터 이름은 로컬 Xcode 환경에 따라 다를 수 있습니다.

## 협업 가이드

- 화면별 로직은 가능하면 각 도메인의 `ViewModel`에 둡니다.
- API 추가 시 `Networks/{Domain}` 아래에 `EndPoint`와 `Service`를 함께 구성합니다.
- 사용자에게 노출되는 문자열은 `LocalizedKey`와 `LocalizationManager`를 통해 관리합니다.
- 공통 UI는 `Common/Component`, 공통 상태 및 유틸은 `Common/Util`에 배치합니다.
- 민감 정보는 코드 리뷰와 커밋 전에 반드시 확인합니다.

## 관련 링크

- App Store: `https://apps.apple.com/app/id6502518614`
- Bundle Identifier: `com.jeju.nanaland`

---

NanaLand는 제주를 처음 만나는 여행자도, 익숙한 제주를 새롭게 보고 싶은 사용자도 각자의 취향대로 탐색할 수 있도록 돕는 iOS 앱입니다.
