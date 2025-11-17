import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// 애플리케이션 이름
  ///
  /// In ko, this message translates to:
  /// **'Tripgether'**
  String get appTitle;

  /// 앱 설명
  ///
  /// In ko, this message translates to:
  /// **'여행 순간을 공유하고 현지 명소를 발견하세요'**
  String get appDescription;

  /// 홈 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// 지도 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'지도'**
  String get navMap;

  /// 일정 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get navSchedule;

  /// 코스마켓 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'코스마켓'**
  String get navCourseMarket;

  /// 마이페이지 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get navMyPage;

  /// 확인 버튼
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get btnConfirm;

  /// 취소 버튼
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get btnCancel;

  /// 저장 버튼
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get btnSave;

  /// 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get btnDelete;

  /// 편집 버튼
  ///
  /// In ko, this message translates to:
  /// **'편집'**
  String get btnEdit;

  /// 공유 버튼
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get btnShare;

  /// 로딩 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'로딩 중...'**
  String get loading;

  /// 데이터 로딩 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터를 불러오는 중...'**
  String get loadingData;

  /// 데이터가 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'데이터가 없습니다'**
  String get noData;

  /// 네트워크 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인해주세요'**
  String get networkError;

  /// 재시도 버튼
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get retry;

  /// 여행 단수형
  ///
  /// In ko, this message translates to:
  /// **'여행'**
  String get trip;

  /// 여행 복수형
  ///
  /// In ko, this message translates to:
  /// **'여행들'**
  String get trips;

  /// 내 여행 목록
  ///
  /// In ko, this message translates to:
  /// **'내 여행'**
  String get myTrips;

  /// 새 여행 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'여행 만들기'**
  String get createTrip;

  /// 여행 제목 입력 라벨
  ///
  /// In ko, this message translates to:
  /// **'여행 제목'**
  String get tripTitle;

  /// 여행 설명 입력 라벨
  ///
  /// In ko, this message translates to:
  /// **'여행 설명'**
  String get tripDescription;

  /// 여행 시작일
  ///
  /// In ko, this message translates to:
  /// **'시작일'**
  String get startDate;

  /// 여행 종료일
  ///
  /// In ko, this message translates to:
  /// **'종료일'**
  String get endDate;

  /// 일정 단수형
  ///
  /// In ko, this message translates to:
  /// **'일정'**
  String get schedule;

  /// 일정 복수형
  ///
  /// In ko, this message translates to:
  /// **'일정들'**
  String get schedules;

  /// 새 일정 추가 버튼
  ///
  /// In ko, this message translates to:
  /// **'일정 추가'**
  String get addSchedule;

  /// 일정 시간
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get scheduleTime;

  /// 일정 장소
  ///
  /// In ko, this message translates to:
  /// **'장소'**
  String get scheduleLocation;

  /// 지도
  ///
  /// In ko, this message translates to:
  /// **'지도'**
  String get map;

  /// 현재 위치
  ///
  /// In ko, this message translates to:
  /// **'현재 위치'**
  String get currentLocation;

  /// 장소 검색 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'장소 검색'**
  String get searchLocation;

  /// 설정 메뉴
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get settings;

  /// 언어 설정
  ///
  /// In ko, this message translates to:
  /// **'언어'**
  String get language;

  /// 언어 선택 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'언어 선택'**
  String get languageSelection;

  /// 한국어
  ///
  /// In ko, this message translates to:
  /// **'한국어'**
  String get korean;

  /// 영어
  ///
  /// In ko, this message translates to:
  /// **'English'**
  String get english;

  /// 현재 선택된 언어
  ///
  /// In ko, this message translates to:
  /// **'현재 언어'**
  String get currentLanguage;

  /// 테마 설정
  ///
  /// In ko, this message translates to:
  /// **'테마'**
  String get theme;

  /// 다크 모드 설정
  ///
  /// In ko, this message translates to:
  /// **'다크 모드'**
  String get darkMode;

  /// 라이트 모드 설정
  ///
  /// In ko, this message translates to:
  /// **'라이트 모드'**
  String get lightMode;

  /// 일반적인 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'오류가 발생했습니다'**
  String get errorGeneral;

  /// 입력 검증 오류
  ///
  /// In ko, this message translates to:
  /// **'잘못된 입력입니다'**
  String get errorInvalidInput;

  /// 데이터 저장 실패 오류
  ///
  /// In ko, this message translates to:
  /// **'데이터 저장에 실패했습니다'**
  String get errorSaveData;

  /// 한국어 날짜 형식
  ///
  /// In ko, this message translates to:
  /// **'yyyy년 MM월 dd일'**
  String get dateFormat;

  /// 한국어 시간 형식 (오전/오후)
  ///
  /// In ko, this message translates to:
  /// **'a h:mm'**
  String get timeFormat;

  /// 홈 화면 인사말
  ///
  /// In ko, this message translates to:
  /// **'안녕하세요, {userName}님!'**
  String greeting(String userName);

  /// 홈 화면 인사말 부제목
  ///
  /// In ko, this message translates to:
  /// **'현지의 하루, 어디로 떠날까요?'**
  String get greetingSubtitle;

  /// 검색창 힌트 텍스트
  ///
  /// In ko, this message translates to:
  /// **'키워드·도시·장소를 검색해 보세요'**
  String get searchHint;

  /// 검색창 X 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'입력 내용 지우기'**
  String get clearInput;

  /// 홈 화면 SNS 컨텐츠 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 SNS에서 본 컨텐츠'**
  String get recentSnsContent;

  /// SNS 컨텐츠 리스트 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 본 컨텐츠'**
  String get recentViewedContent;

  /// 저장한 장소 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 저장한 장소'**
  String get recentSavedPlaces;

  /// 더보기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get seeMore;

  /// 조회수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String viewCount(String count);

  /// 콘텐츠 끝 메시지
  ///
  /// In ko, this message translates to:
  /// **'더 이상 콘텐츠가 없습니다'**
  String get noMoreContent;

  /// SNS 콘텐츠가 없을 때 표시되는 메시지
  ///
  /// In ko, this message translates to:
  /// **'SNS에서 공유된 컨텐츠가 없습니다.'**
  String get noSnsContentYet;

  /// 저장한 장소가 없을 때 표시되는 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 저장한 장소가 없습니다.'**
  String get noSavedPlacesYet;

  /// 전체 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get filterAll;

  /// 유튜브 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'YouTube'**
  String get filterYoutube;

  /// 인스타그램 필터 옵션
  ///
  /// In ko, this message translates to:
  /// **'Instagram'**
  String get filterInstagram;

  /// 장소 방문 완료 표시
  ///
  /// In ko, this message translates to:
  /// **'방문완료'**
  String get placeVisited;

  /// 장소 더보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'더 많은 장소 보기'**
  String get seeMorePlaces;

  /// 공유 데이터 수신 알림
  ///
  /// In ko, this message translates to:
  /// **'공유 데이터 수신됨'**
  String get sharedDataReceived;

  /// 공유 데이터로 여행 생성 버튼
  ///
  /// In ko, this message translates to:
  /// **'여행 만들기'**
  String get createTripFromShared;

  /// 닫기 버튼
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get close;

  /// 텍스트 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'텍스트 ({count}개)'**
  String textCount(int count);

  /// 미디어 파일 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'미디어 파일 ({count}개)'**
  String mediaFileCount(int count);

  /// 이미지 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'이미지 {count}'**
  String imageCount(int count);

  /// 동영상 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'동영상 {count}'**
  String videoCount(int count);

  /// 파일 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'파일 {count}'**
  String fileCount(int count);

  /// SNS 콘텐츠 상세 화면 타이틀
  ///
  /// In ko, this message translates to:
  /// **'콘텐츠 상세'**
  String get snsContentDetail;

  /// 설명 라벨
  ///
  /// In ko, this message translates to:
  /// **'설명'**
  String get description;

  /// 외부 링크 열기 버튼
  ///
  /// In ko, this message translates to:
  /// **'원본 콘텐츠 보기'**
  String get openOriginalContent;

  /// 링크 열기 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'링크를 열 수 없습니다'**
  String get cannotOpenLink;

  /// 링크 열기 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'링크 열기 중 오류가 발생했습니다'**
  String get linkOpenError;

  /// 오늘 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get today;

  /// 어제 날짜 표시
  ///
  /// In ko, this message translates to:
  /// **'어제'**
  String get yesterday;

  /// N일 전 표시
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String daysAgo(int days);

  /// N주 전 표시
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 전'**
  String weeksAgo(int weeks);

  /// N개월 전 표시
  ///
  /// In ko, this message translates to:
  /// **'{months}개월 전'**
  String monthsAgo(int months);

  /// N년 전 표시
  ///
  /// In ko, this message translates to:
  /// **'{years}년 전'**
  String yearsAgo(int years);

  /// SNS 게시물 외부 링크 버튼
  ///
  /// In ko, this message translates to:
  /// **'게시물 바로가기'**
  String get goToOriginalPost;

  /// AI가 생성한 콘텐츠 요약 태그
  ///
  /// In ko, this message translates to:
  /// **'AI 콘텐츠 요약'**
  String get aiContentSummary;

  /// 공유 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'공유'**
  String get share;

  /// 코스마켓 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'코스마켓'**
  String get courseMarket;

  /// 코스 검색 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'코스 검색'**
  String get searchCourse;

  /// 검색 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'검색'**
  String get searchScreen;

  /// 검색창 플레이스홀더 텍스트
  ///
  /// In ko, this message translates to:
  /// **'키워드·도시·장소를 검색해 보세요'**
  String get searchPlaceholder;

  /// 실시간 인기 코스 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'실시간 인기 코스 >'**
  String get popularCourses;

  /// 내 주변 코스 섹션 제목 (위치 정보 없음)
  ///
  /// In ko, this message translates to:
  /// **'내 주변'**
  String get nearbyCourses;

  /// 내 주변 코스 섹션 제목 (위치 정보 포함)
  ///
  /// In ko, this message translates to:
  /// **'내 주변 (현재 위치 : {location}) >'**
  String nearbyCoursesWithLocation(String location);

  /// 장소 추가 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'장소 추가'**
  String get addPlace;

  /// 코스 생성 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'코스 생성'**
  String get createCourse;

  /// 최근 검색어 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 검색어'**
  String get recentSearches;

  /// 최근 검색어 전체 삭제 버튼
  ///
  /// In ko, this message translates to:
  /// **'전체 삭제'**
  String get clearAllSearches;

  /// 추천 검색어 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'추천 검색어'**
  String get recommendedSearches;

  /// 검색 결과 없음 메시지
  ///
  /// In ko, this message translates to:
  /// **'검색 결과가 없습니다'**
  String get noSearchResults;

  /// 다른 검색어 시도 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'다른 검색어로 시도해보세요'**
  String get tryDifferentKeyword;

  /// 검색 결과 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'검색 결과 {count}개'**
  String searchResults(int count);

  /// 장소 개수 표시 (단위 포함)
  ///
  /// In ko, this message translates to:
  /// **'{count}곳'**
  String placesCount(int count);

  /// 장소 단위
  ///
  /// In ko, this message translates to:
  /// **'곳'**
  String get places;

  /// 더보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'더보기'**
  String get more;

  /// 가격 표시 (천원 단위)
  ///
  /// In ko, this message translates to:
  /// **'{thousands}천원'**
  String priceKrw(int thousands);

  /// 소요시간 표시 (시간과 분)
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 {minutes}분'**
  String hoursAndMinutes(int hours, int minutes);

  /// 무료 코스 표시
  ///
  /// In ko, this message translates to:
  /// **'무료'**
  String get free;

  /// 뒤로 가기 버튼
  ///
  /// In ko, this message translates to:
  /// **'뒤로 가기'**
  String get goBack;

  /// 이메일 로그인 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인에 실패했습니다. 다시 시도해주세요.'**
  String get loginFailedTryAgain;

  /// 구글 로그인 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'구글 로그인에 실패했습니다.'**
  String get googleLoginFailed;

  /// 회원가입 화면 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'회원가입 화면 준비 중입니다'**
  String get signupScreenPreparation;

  /// 이메일 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// 이메일 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'support@tripgether-official.com'**
  String get emailHint;

  /// 비밀번호 입력 필드 라벨
  ///
  /// In ko, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// 비밀번호 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'••••••••••••'**
  String get passwordHint;

  /// 이메일 필수 입력 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get emailRequired;

  /// 이메일 형식 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식을 입력해주세요'**
  String get emailInvalidFormat;

  /// 비밀번호 필수 입력 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해주세요'**
  String get passwordRequired;

  /// 비밀번호 최소 길이 오류 메시지
  ///
  /// In ko, this message translates to:
  /// **'비밀번호는 최소 6자 이상이어야 합니다'**
  String get passwordMinLength;

  /// 자동로그인 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'자동로그인'**
  String get autoLogin;

  /// 아이디 찾기 버튼
  ///
  /// In ko, this message translates to:
  /// **'아이디'**
  String get findId;

  /// 비밀번호 찾기 버튼
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 찾기'**
  String get findPassword;

  /// 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get login;

  /// 구글 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'구글로 시작하기'**
  String get signInWithGoogle;

  /// 카카오 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'카카오로 시작하기'**
  String get signInWithKakao;

  /// 네이버 로그인 버튼
  ///
  /// In ko, this message translates to:
  /// **'네이버로 시작하기'**
  String get signInWithNaver;

  /// 이메일 회원가입 버튼
  ///
  /// In ko, this message translates to:
  /// **'이메일로 가입하기'**
  String get signUpWithEmail;

  /// SNS 로그인 구분선 텍스트
  ///
  /// In ko, this message translates to:
  /// **'SNS 계정으로 로그인/회원가입'**
  String get snsLoginDivider;

  /// 로그아웃 버튼
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logout;

  /// 로그아웃 확인 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get logoutConfirmTitle;

  /// 로그아웃 확인 메시지
  ///
  /// In ko, this message translates to:
  /// **'정말 로그아웃하시겠습니까?'**
  String get logoutConfirmMessage;

  /// 로그아웃 안내 문구
  ///
  /// In ko, this message translates to:
  /// **'로그아웃하시면 다시 로그인해야 합니다'**
  String get logoutHint;

  /// 로그아웃 성공 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그아웃되었습니다'**
  String get logoutSuccess;

  /// 로그아웃 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그아웃 실패: {error}'**
  String logoutFailed(String error);

  /// 프로필 화면 로그인 필요 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요합니다'**
  String get profileLoginRequired;

  /// 프로필 화면 로그인 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'로그인하시면 더 많은 기능을 이용할 수 있습니다'**
  String get profileLoginPrompt;

  /// 프로필 화면 로그인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'로그인하러 가기'**
  String get profileLoginButton;

  /// 프로필 정보 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'프로필 정보를 불러올 수 없습니다'**
  String get profileLoadError;

  /// 로그인 플랫폼 계정 표시
  ///
  /// In ko, this message translates to:
  /// **'{platform} 계정'**
  String accountSuffix(String platform);

  /// 일정 생성 권한 부족 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'일정을 생성하려면 로그인이 필요합니다.'**
  String get permissionCreateScheduleRequired;

  /// 코스 구매 권한 부족 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'코스를 구매하려면 로그인이 필요합니다.'**
  String get permissionPurchaseCourseRequired;

  /// 프로필 편집 권한 부족 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'프로필을 편집하려면 로그인이 필요합니다.'**
  String get permissionEditProfileRequired;

  /// 지도 접근 권한 부족 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'지도를 사용하려면 위치 권한이 필요합니다.'**
  String get permissionAccessMapRequired;

  /// 일반 권한 부족 에러 메시지
  ///
  /// In ko, this message translates to:
  /// **'이 기능을 사용하려면 적절한 권한이 필요합니다.'**
  String get permissionGeneralRequired;

  /// 온보딩 환영 화면 메시지
  ///
  /// In ko, this message translates to:
  /// **'이제 Tripgether와 함께\n특별한 여행을 계획해보세요 ✈️'**
  String get onboardingWelcomeMessage;

  /// Tripgether 시작하기 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'Tripgether 시작하기'**
  String get startTripgether;

  /// 온보딩 생년월일 입력 안내
  ///
  /// In ko, this message translates to:
  /// **'생년월일을 입력해주세요'**
  String get onboardingBirthdatePrompt;

  /// 온보딩 생년월일 사용 목적 설명
  ///
  /// In ko, this message translates to:
  /// **'다른 유저에게는 보이지 않아요.\n연령별 콘텐츠 설정 및 추천에만 사용돼요.'**
  String get onboardingBirthdateDescription;

  /// 온보딩 생년월일 연령 제한 안내
  ///
  /// In ko, this message translates to:
  /// **'※ 만 14세 이상만 사용 가능합니다'**
  String get onboardingBirthdateAgeLimit;

  /// 온보딩 관심사 선택 안내
  ///
  /// In ko, this message translates to:
  /// **'관심사를 선택해주세요'**
  String get onboardingInterestsPrompt;

  /// 온보딩 관심사 변경 가능 안내
  ///
  /// In ko, this message translates to:
  /// **'선택한 관심사는 언제든 설정에서 바꿀 수 있어요.'**
  String get onboardingInterestsChangeHint;

  /// 리뷰 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}개 리뷰'**
  String reviewCount(int count);

  /// 지도 화면 내 위치 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'내 위치로 이동'**
  String get mapMyLocationTooltip;

  /// 지도 화면 플레이스홀더 메시지
  ///
  /// In ko, this message translates to:
  /// **'지도 기능이 곧 추가될 예정입니다'**
  String get mapPlaceholder;

  /// 장소 상세 화면의 장소 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'장소 정보'**
  String get placeInfo;

  /// 장소 상세 화면의 영업 정보 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'영업 정보'**
  String get businessInfo;

  /// 장소 상세 화면의 위치 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'위치'**
  String get location;

  /// 장소 상세 화면 하단의 지도에서 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'지도에서 보기'**
  String get viewOnMap;

  /// 장소 상세 화면 하단의 길찾기 버튼
  ///
  /// In ko, this message translates to:
  /// **'길찾기'**
  String get getDirections;

  /// 기능 준비 중 메시지
  ///
  /// In ko, this message translates to:
  /// **'준비 중입니다'**
  String get comingSoon;

  /// 인기 코스가 없을 때 표시되는 메시지
  ///
  /// In ko, this message translates to:
  /// **'아직 인기 코스가 없어요'**
  String get noPopularCoursesYet;

  /// 온보딩 닉네임 입력 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'이름을 설정해주세요'**
  String get onboardingNicknamePrompt;

  /// 온보딩 성별 선택 안내 제목
  ///
  /// In ko, this message translates to:
  /// **'성별을 선택해주세요'**
  String get onboardingGenderPrompt;

  /// 성별 선택 - 남성
  ///
  /// In ko, this message translates to:
  /// **'남성'**
  String get genderMale;

  /// 성별 선택 - 여성
  ///
  /// In ko, this message translates to:
  /// **'여성'**
  String get genderFemale;

  /// 성별 선택 - 기타
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get genderOther;

  /// 성별 선택 - 건너뛰기
  ///
  /// In ko, this message translates to:
  /// **'건너뛰기'**
  String get genderSkip;

  /// 온보딩 환영 화면 설명 (닉네임 포함)
  ///
  /// In ko, this message translates to:
  /// **'모든 준비가 끝났어요 🎉\n현지의 하루로 들어가요 {userName}님'**
  String onboardingWelcomeDescription(String userName);

  /// SNS 장소추출 튜토리얼 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'SNS 장소추출 튜토리얼'**
  String get snsPlaceExtractionTutorial;

  /// 계속하기 버튼 (온보딩 진행)
  ///
  /// In ko, this message translates to:
  /// **'계속하기'**
  String get btnContinue;

  /// 완료하기 버튼 (온보딩 마지막 단계)
  ///
  /// In ko, this message translates to:
  /// **'완료하기'**
  String get btnComplete;

  /// 온보딩 성별 선택 사용 목적 설명
  ///
  /// In ko, this message translates to:
  /// **'맞춤 추천을 위해 사용돼요\n선택하지 않아도 괜찮아요'**
  String get onboardingGenderDescription;

  /// 온보딩 관심사 선택 개수 안내
  ///
  /// In ko, this message translates to:
  /// **'최소 3개, 최대 10개를 선택하면 맞춤 추천 정확도가 높아져요'**
  String get onboardingInterestsDescription;

  /// 온보딩 관심사 변경 가능 안내
  ///
  /// In ko, this message translates to:
  /// **'선택한 관심사는 언제든 설정에서 바꿀 수 있어요'**
  String get onboardingInterestsChangeInfo;

  /// 온보딩 완료 환영 메시지 (닉네임 포함)
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님,\n환영해요!'**
  String onboardingWelcomeTitle(String nickname);

  /// 온보딩 완료 환영 메시지 (닉네임 없을 때)
  ///
  /// In ko, this message translates to:
  /// **'환영해요!'**
  String get onboardingWelcomeTitleFallback;

  /// 온보딩 닉네임 입력 전 기본 플레이스홀더
  ///
  /// In ko, this message translates to:
  /// **'여행러버'**
  String get defaultNickname;

  /// 콘텐츠 로드 실패 메시지
  ///
  /// In ko, this message translates to:
  /// **'콘텐츠를 불러올 수 없습니다'**
  String get cannotLoadContent;

  /// SNS 콘텐츠 빈 상태 안내 메시지
  ///
  /// In ko, this message translates to:
  /// **'SNS에서 콘텐츠를 공유하면\n여기에서 확인할 수 있습니다'**
  String get noSnsContentMessage;

  /// 제목이 없을 때 기본 텍스트
  ///
  /// In ko, this message translates to:
  /// **'제목 없음'**
  String get noTitle;

  /// 뒤로가기 버튼 접근성 라벨 (스크린 리더용)
  ///
  /// In ko, this message translates to:
  /// **'뒤로가기 버튼'**
  String get backButtonLabel;

  /// 뒤로가기 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'뒤로가기'**
  String get backButtonTooltip;

  /// 메뉴 버튼 접근성 라벨 (스크린 리더용)
  ///
  /// In ko, this message translates to:
  /// **'메뉴 버튼'**
  String get menuButtonLabel;

  /// 메뉴 버튼 툴팁
  ///
  /// In ko, this message translates to:
  /// **'메뉴'**
  String get menuButtonTooltip;

  /// 알림 버튼 접근성 라벨 (스크린 리더용)
  ///
  /// In ko, this message translates to:
  /// **'알림 버튼'**
  String get notificationButtonLabel;

  /// 알림 다이얼로그 제목
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationTitle;

  /// 새로운 알림이 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'현재 새로운 알림이 없습니다.'**
  String get noNewNotifications;

  /// 설정 버튼 접근성 라벨 (스크린 리더용)
  ///
  /// In ko, this message translates to:
  /// **'설정 버튼'**
  String get settingsButtonLabel;

  /// 검색 버튼 접근성 라벨 (스크린 리더용)
  ///
  /// In ko, this message translates to:
  /// **'검색 버튼'**
  String get searchButtonLabel;

  /// 온보딩 약관 동의 페이지 제목
  ///
  /// In ko, this message translates to:
  /// **'약관에 동의해주세요'**
  String get onboardingTermsPrompt;

  /// 온보딩 약관 동의 페이지 설명
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용을 위해 약관 동의가 필요해요'**
  String get onboardingTermsDescription;

  /// 서비스 이용약관 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get termsOfService;

  /// 개인정보 처리방침 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'개인정보 처리방침'**
  String get privacyPolicy;

  /// 만 14세 이상 확인 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'만 14세 이상입니다'**
  String get ageConfirmation;

  /// 마케팅 정보 수신 동의 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'마케팅 정보 수신 동의 (선택)'**
  String get marketingConsent;

  /// 약관 전체 동의 체크박스 라벨
  ///
  /// In ko, this message translates to:
  /// **'전체 동의'**
  String get agreeToAll;

  /// 약관 상세 내용 보기 버튼
  ///
  /// In ko, this message translates to:
  /// **'자세히 보기'**
  String get viewDetails;

  /// 온보딩 닉네임 페이지 설명
  ///
  /// In ko, this message translates to:
  /// **'다른 유저에게 보이는 이름이에요\n비속어/광고 문구는 제한돼요'**
  String get onboardingNicknameDescription;

  /// 온보딩 닉네임 입력 힌트
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력하세요'**
  String get onboardingNicknameHint;

  /// 선택된 관심사 개수 표시
  ///
  /// In ko, this message translates to:
  /// **'{count}개 선택'**
  String onboardingInterestsSelectedCount(int count);

  /// 온보딩 완료 후 시작 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'바로 시작하기'**
  String get startNow;

  /// 환영 페이지 통합 메시지 (닉네임 포함)
  ///
  /// In ko, this message translates to:
  /// **'모든 준비가 끝났어요 🎉\n현지의 하루로 들어가요 {nickname}님'**
  String onboardingWelcomeUnified(String nickname);

  /// 알림 화면 제목
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notifications;

  /// 알림 섹션 헤더 - 오늘
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get notificationSectionToday;

  /// 알림이 없을 때 메시지
  ///
  /// In ko, this message translates to:
  /// **'새로운 알림이 없습니다'**
  String get noNotifications;

  /// 알림 빈 상태 설명 메시지
  ///
  /// In ko, this message translates to:
  /// **'외부 앱에서 공유된 링크가 여기에 표시됩니다'**
  String get sharedContentMessage;

  /// 알림 진행 중 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'AI가 위치정보를 파악하고 있습니다'**
  String get aiAnalyzingLocation;

  /// 알림 완료 상태 메시지
  ///
  /// In ko, this message translates to:
  /// **'AI가 {count}곳의 위치정보를 파악했습니다'**
  String aiAnalyzedLocations(String count);

  /// 작성자 게시물 표시
  ///
  /// In ko, this message translates to:
  /// **'{author}님의 게시물'**
  String authorPost(String author);

  /// 알림 진행 중 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'진행 중'**
  String get notificationStatusProcessing;

  /// 알림 완료 확인 버튼 텍스트
  ///
  /// In ko, this message translates to:
  /// **'확인하기'**
  String get notificationStatusCheckButton;

  /// 방금 전 타임스탬프
  ///
  /// In ko, this message translates to:
  /// **'방금'**
  String get timestampJustNow;

  /// N분 전 타임스탬프
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String timestampMinutesAgo(int minutes);

  /// N시간 전 타임스탬프
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String timestampHoursAgo(int hours);

  /// N일 전 타임스탬프
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String timestampDaysAgo(int days);

  /// 기본 작성자명 (파싱 실패 시)
  ///
  /// In ko, this message translates to:
  /// **'사용자'**
  String get defaultAuthor;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
