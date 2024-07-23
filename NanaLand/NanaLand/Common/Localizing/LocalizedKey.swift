//
//  LocalizedKey.swift
//  NanaLand
//
//  Created by 정현우 on 5/27/24.
//

import Foundation

enum LocalizedKey: String {
	//MARK: - Common
	case resultCount
	case charCount
	case confirm
	case next
	case requiredWithBracket
	case optionalWithBracket
	case destination
	case gotoMainScreen
	case no
	case yes
	case emptyString
	case beingPrepared
	case notification
	
	//MARK: - Tab
	case home
	case favorite
	case jejuStory
	case myNana
	
	//MARK: - Category
	case all
	case nature
	case festival
	case market
	case experience
	case nanaPick
	
	
	//MARK: - Search
	case inputSearchTerm
	case recentSearchTerm
	case noRecentSearchTerm
	case removeAll
	case popularSearchTerm
	case searchVolumeUp
	case noResult
	
	//MARK: - Login/Register
	case appleLogin
	case googleLogin
	case nonMemeberLogin
	case welcomeToNanaLand
	case enterNicknameAndProfile
	case nicknameTextFieldPlaceHolder
	
	//MARK: - Terms
	case allAgree
	case termsOfUseAgree
	case marketingAgree
	case locationAgree
	
	//MARK: - Error/Alert
	case duplicatedNickname
	case invalidNickname
	case onlyCharSpaceNumberNickname
	case logoutAlertTitle
	case withdrawAlertTitle
	case withdrawAlertMessage
	case changeLanguageAlertTitle
	case invalidEmail
	case updateRequired
	case openAppstore
	
	//MARK: - TypeTest
	case skipTypeTest
	// Question
	// First Question, First Line
	case typeTest1Q1L
	case typeTest1Q2L
	case typeTest2Q1L
	case typeTest2Q2L
	case typeTest3Q1L
	case typeTest3Q2L
	case typeTest4Q1L
	case typeTest4Q2L
	case typeTest5Q1L
	case typeTest5Q2L
	// Answer
	case touristSpot
	case localSpot
	case flexible
	case organized
	case budgetTravel
	case luxuryTravel
	case photoRemain
	case captureWithEyes
	case sentimentalPlace
	case traditionalCulture
	case naturalScenery
	case themePark
	// Result
	case your
	case yourPreference
	case yourTravelStyle
	case tangerineJuiced
	case juiceCommingSoon
	case yourTravelStyleIs
	// Type
	case GAMGYUL_ICECREAM
	case GAMGYUL_ICECREAM_DESCRIPTION
	case GAMGYUL_RICECAKE
	case GAMGYUL_RICECAKE_DESCRIPTION
	case GAMGYUL
	case GAMGYUL_DESCRIPTION
	case GAMGYUL_CIDER
	case GAMGYUL_CIDER_DESCRIPTION
	case GAMGYUL_AFFOKATO
	case GAMGYUL_AFFOKATO_DESCRIPTION
	case GAMGYUL_HANGWA
	case GAMGYUL_HANGWA_DESCRIPTION
	case GAMGYUL_JUICE
	case GAMGYUL_JUICE_DESCRIPTION
	case GAMGYUL_CHOCOLATE
	case GAMGYUL_CHOCOLATE_DESCRIPTION
	case GAMGYUL_COCKTAIL
	case GAMGYUL_COCKTAIL_DESCRIPTION
	case TANGERINE_PEEL_TEA
	case TANGERINE_PEEL_TEA_DESCRIPTION
	case GAMGYUL_YOGURT
	case GAMGYUL_YOGURT_DESCRIPTION
	case GAMGYUL_FLATCCINO
	case GAMGYUL_FLATCCINO_DESCRIPTION
	case GAMGYUL_LATTE
	case GAMGYUL_LATTE_DESCRIPTION
	case GAMGYUL_SIKHYE
	case GAMGYUL_SIKHYE_DESCRIPTION
	case GAMGYUL_ADE
	case GAMGYUL_ADE_DESCRIPTION
	case GAMGYUL_BUBBLE_TEA
	case GAMGYUL_BUBBLE_TEA_DESCRIPTION
	case nanalandMadeYouJuice
	// 결과 값 추천 여행지
	case recommendedTravelPlace
	case recommenedeTravelTitleFirstLine
	case recommenedeTravelTitleSecondLine
	
    //MARK: - MyPage
    // main
    case mynana
	case loginRequired
	case none
    case editProfile
    case travelType
	case goTest
	case retest
    case introduction
    
    // editPage
    case nickName
    case complete
    case nickNameTypingLimitError
    case nickNameDuplicateError
    case introduceTypingLimitError
    case nickNameContainSpecialCharacterError
    
    // deleteAlertPage(삭제 확인창)
    case deleteAlertTitle
    case deleteAlertSubTitle
    case cancel
    case delete
    
    // settingPage
    case settings
    case setUsage
    case termsAndPolicies
    case accessPolicyGuide
    case languageSetting
    case versionInfomation
    case logout
    case memberWithdraw
    
    // termsAndPoliciesPage(약관 및 정책 페이지)
    case marketingConsent
    case locationConsent
    case noConsentError
    
    // accessPolicyGuidePage(접근 권한 안내 페이지)
    case mainDescription
    // 전화 기기 정보
    case phoneTitle
    case phoneDescription
    // 필수 접근권한 알림
    case requiredNotification
    // 저장공간
    case storageTitle
    case storageDescription
    // 위치정보
    case locationTitle
    case locationDescription
    // 카메라
    case cameraTitle
    case cameraDescription
    // 알림
    case notificationTitle
    case notificationDescription
    // 오디오
    case audioTitle
    case audioDescription
    // 선택 접근권한 알림
    case optionalNotification
    case notificate
	
	// withdrawType(서비스 탈퇴 사유)
	case INSUFFICIENT_CONTENT
	case INCONVENIENT_SERVICE
    case INCONVENIENT_COMMUNITY
	case RARE_VISITS
	
    // languageSettingPage(언어 설정 페이지)
    case languageMainDescription
    // withDrawMembershipPage(회원 탈퇴 페이지)
    case withDrawNotification
    case firstNotification
    case secondNotification
    case thirdNotification
    case fourthNotification
    case fifthNotification
    case notificationConsent
    case withDrawReason
    case withdraw
    case accountDeletion
	
	// MARK: - 비회원
	case nonMemeberAlertDescription
	case nonMemeberAlertGoRegister
    
    // MARK: - Home
    case recommendTitle
	case ourNana
    case firstAdvertismentTitle
    case firstAdvertismentSubTitle
    case secondAdvertismentTitle
    case secondAdvertismentSubTitle
    case thirdAdvertismentTitle
    case thirdAdvertismentSubTitle
    case fourthAdvertismentTitle
    case fourthAdvertismentSubTitle
	// 홈화면 검색 placeholder
	case jejuCanolaFestival
	case jejuGreenTeaField
	case jejuFiveDayMarket
	case udoToday
	case trendyGujwa
	case hallasanTrail
	case jejuNightDrive
	case nearJejuAirport
	case jejuSummerHydrangea
	case jejuCharmingHanok
    
    // MARK: - FilterView(아이템 개수, 지역, 계절, 날짜)
    case count
    // 지역
    case location
    case allLocation
    case jejuCity
    case Aewol
    case Jocheon
    case Hangyeong
    case Gunjwa
    case Hallim
    case Udo
    case Chuja
    case SeogwipoCity
    case Daejeong
    case Andeok
    case Namwon
    case Pyoseon
    case Seongsan
    case allSelect
    case reset
    case apply
    case photoDescription
    // MARK: - NatureDetailView(7대자연 디테일 뷰)
    case unfoldView // 더보기
    case foldView // 접기
    case introduce
    case address
    case phoneNumber
    case time
    case fee
    case detailInfo
    case amenity
    case proposeUpdateInfo
    
    // MARK: - FestivalView
    case thisMonthFestival
    case pastFestival
    case seasonFestival
    
    // MARK: - SeasonModalView
    case selectSeason
    case spring
    case summer
    case autumn
    case winter
    case month
    case springMonth
    case summerMonth
    case autumnMonth
    case winterMonth
    
    // MARK: - MarketDetailView
    case homepage
  
    // MARK: - FestivalDetailView
    case duration
    
    // MARK: - CalendarView
    case chooseDate
    case calendarMonth
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    case jan
    case feb
    case mar
    case apr
    case may
    case jun
    case jul
    case aug
    case sep
    case oct
    case nov
    case dec
    
    case year
    
    // MARK: - 정보 수정 제안
	case reportInfo
	case reportInfoTitle
	case reportInfoDescription
	case numberAndHomepage
	case oprationTime
	case placeNameAndLocation
	case priceInfo
	case deletePlace
	case etcReportInfoTitle
	case provideService
	case addPhoto
	case addPhotoDescription
	case reportInfoContentTitle
	case reportInfoContentPlaceHolder
	case email
	case reportInfoEmailDescription
	case send
	case thxForReportInfoTitle
	case thxForReportInfoDescription
	case showContentAgain
	case reportAgain    
    
    // MARK: - 후기
    case blank
    case review
    case write
    case keyword
    case selectRating
    case visitReview
    case writeContent
    case addKeyword
    case upload
    case keywordDescription
    
    // MARK: - 키워드 내용
    case mood
    case anniversary
    case cute
    case luxurious
    case beautiful
    case kind
    case companion
    case descendant
    case friend
    case parent
    case alone
    case spouse
    case relative
    case animal
    case amenities
    case socket
    case largeSpace
    case parking
    case cleanBathroom
    case warning
    case warningDescription
    case check
    
    // MARK: - 제주 맛집
    case restaurant
    case meatblackpork
    case seaFood
    case koreanFood
    case chineseFood
    case japaneseFood
    case westernFood
    case vegan
    case halalFood
    case snacks
    case southAmericanFood
    case southeastAsianFood
    case chickenBurger
    case cafeDessert
    case pubRestaurant
    case menu
    case writeReview
    
	//MARK: - localized()
	func localized(for language: Language) -> String {
		guard let path = Bundle.main.path(forResource: language.localizedName, ofType: "lproj"),
			  let bundle = Bundle(path: path) else {
			return NSLocalizedString(self.rawValue, comment: "")
		}
		return NSLocalizedString(self.rawValue, bundle: bundle, comment: "")
	}

	func localized(for language: Language, _ arguments: [CVarArg]) -> String {
			let format = localized(for: language)
			return String(format: format, arguments: arguments)
		}
	
	static func + (lhs: LocalizedKey, rhs: LocalizedKey) -> String {
		let leftLocalizedString = lhs.localized(for: LocalizationManager.shared.language)
		let rightLocalizedString = rhs.localized(for: LocalizationManager.shared.language)
		return leftLocalizedString + rightLocalizedString
	}

	static func + (lhs: String, rhs: LocalizedKey) -> String {
		let localizedString = rhs.localized(for: LocalizationManager.shared.language)
		return lhs + localizedString
	}

	static func + (lhs: LocalizedKey, rhs: String) -> String {
		let localizedString = lhs.localized(for: LocalizationManager.shared.language)
		return localizedString + rhs
	}
}
