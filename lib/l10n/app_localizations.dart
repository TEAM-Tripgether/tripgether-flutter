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
  /// **'TripTogether'**
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

  /// 코스 마켓 탭 라벨
  ///
  /// In ko, this message translates to:
  /// **'코스 마켓'**
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

  /// SNS 콘텐츠 섹션 제목
  ///
  /// In ko, this message translates to:
  /// **'최근 SNS에서 본 콘텐츠'**
  String get recentSnsContent;

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
