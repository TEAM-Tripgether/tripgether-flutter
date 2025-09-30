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
