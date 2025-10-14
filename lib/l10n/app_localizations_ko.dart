// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Tripgether';

  @override
  String get appDescription => '여행 순간을 공유하고 현지 명소를 발견하세요';

  @override
  String get navHome => '홈';

  @override
  String get navMap => '지도';

  @override
  String get navSchedule => '일정';

  @override
  String get navCourseMarket => '코스마켓';

  @override
  String get navMyPage => '마이페이지';

  @override
  String get btnConfirm => '확인';

  @override
  String get btnCancel => '취소';

  @override
  String get btnSave => '저장';

  @override
  String get btnDelete => '삭제';

  @override
  String get btnEdit => '편집';

  @override
  String get btnShare => '공유';

  @override
  String get loading => '로딩 중...';

  @override
  String get loadingData => '데이터를 불러오는 중...';

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get networkError => '네트워크 연결을 확인해주세요';

  @override
  String get retry => '다시 시도';

  @override
  String get trip => '여행';

  @override
  String get trips => '여행들';

  @override
  String get myTrips => '내 여행';

  @override
  String get createTrip => '여행 만들기';

  @override
  String get tripTitle => '여행 제목';

  @override
  String get tripDescription => '여행 설명';

  @override
  String get startDate => '시작일';

  @override
  String get endDate => '종료일';

  @override
  String get schedule => '일정';

  @override
  String get schedules => '일정들';

  @override
  String get addSchedule => '일정 추가';

  @override
  String get scheduleTime => '시간';

  @override
  String get scheduleLocation => '장소';

  @override
  String get map => '지도';

  @override
  String get currentLocation => '현재 위치';

  @override
  String get searchLocation => '장소 검색';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get languageSelection => '언어 선택';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get currentLanguage => '현재 언어';

  @override
  String get theme => '테마';

  @override
  String get darkMode => '다크 모드';

  @override
  String get lightMode => '라이트 모드';

  @override
  String get errorGeneral => '오류가 발생했습니다';

  @override
  String get errorInvalidInput => '잘못된 입력입니다';

  @override
  String get errorSaveData => '데이터 저장에 실패했습니다';

  @override
  String get dateFormat => 'yyyy년 MM월 dd일';

  @override
  String get timeFormat => 'a h:mm';

  @override
  String greeting(String userName) {
    return '안녕하세요, $userName님!';
  }

  @override
  String get greetingSubtitle => '현지의 하루, 어디로 떠날까요?';

  @override
  String get searchHint => '키워드·도시·장소를 검색해 보세요';

  @override
  String get clearInput => '입력 내용 지우기';

  @override
  String get recentSnsContent => '최근 SNS에서 본 콘텐츠';

  @override
  String get recentSavedPlaces => '최근 저장한 장소';

  @override
  String get seeMore => '더보기';

  @override
  String viewCount(String count) {
    return '$count회';
  }

  @override
  String get noMoreContent => '더 이상 콘텐츠가 없습니다';

  @override
  String get noSnsContentYet => 'SNS에서 공유된 컨텐츠가 없습니다.';

  @override
  String get noSavedPlacesYet => '아직 저장한 장소가 없습니다.';

  @override
  String get filterAll => '전체';

  @override
  String get filterYoutube => 'YouTube';

  @override
  String get filterInstagram => 'Instagram';

  @override
  String get placeVisited => '방문완료';

  @override
  String get seeMorePlaces => '더 많은 장소 보기';

  @override
  String get sharedDataReceived => '공유 데이터 수신됨';

  @override
  String get createTripFromShared => '여행 만들기';

  @override
  String get close => '닫기';

  @override
  String textCount(int count) {
    return '텍스트 ($count개)';
  }

  @override
  String mediaFileCount(int count) {
    return '미디어 파일 ($count개)';
  }

  @override
  String imageCount(int count) {
    return '이미지 $count';
  }

  @override
  String videoCount(int count) {
    return '동영상 $count';
  }

  @override
  String fileCount(int count) {
    return '파일 $count';
  }

  @override
  String get snsContentDetail => '콘텐츠 상세';

  @override
  String get description => '설명';

  @override
  String get openOriginalContent => '원본 콘텐츠 보기';

  @override
  String get cannotOpenLink => '링크를 열 수 없습니다';

  @override
  String get linkOpenError => '링크 열기 중 오류가 발생했습니다';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String daysAgo(int days) {
    return '$days일 전';
  }

  @override
  String weeksAgo(int weeks) {
    return '$weeks주 전';
  }

  @override
  String monthsAgo(int months) {
    return '$months개월 전';
  }

  @override
  String yearsAgo(int years) {
    return '$years년 전';
  }

  @override
  String get goToOriginalPost => '게시물 바로가기';

  @override
  String get aiContentSummary => 'AI 콘텐츠 요약';

  @override
  String get share => '공유';

  @override
  String get courseMarket => '코스마켓';

  @override
  String get searchCourse => '코스 검색';

  @override
  String get searchScreen => '검색';

  @override
  String get searchPlaceholder => '키워드·도시·장소를 검색해 보세요';

  @override
  String get popularCourses => '실시간 인기 코스 >';

  @override
  String get nearbyCourses => '내 주변';

  @override
  String nearbyCoursesWithLocation(String location) {
    return '내 주변 (현재 위치 : $location) >';
  }

  @override
  String get addPlace => '장소 추가';

  @override
  String get createCourse => '코스 생성';

  @override
  String get recentSearches => '최근 검색어';

  @override
  String get clearAllSearches => '전체 삭제';

  @override
  String get recommendedSearches => '추천 검색어';

  @override
  String get noSearchResults => '검색 결과가 없습니다';

  @override
  String get tryDifferentKeyword => '다른 검색어로 시도해보세요';

  @override
  String searchResults(int count) {
    return '검색 결과 $count개';
  }

  @override
  String placesCount(int count) {
    return '$count곳';
  }

  @override
  String get places => '곳';

  @override
  String get more => '더보기';

  @override
  String priceKrw(int thousands) {
    return '$thousands천원';
  }

  @override
  String hoursAndMinutes(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String get free => '무료';

  @override
  String get goBack => '뒤로 가기';

  @override
  String get loginFailedTryAgain => '로그인에 실패했습니다. 다시 시도해주세요.';

  @override
  String get googleLoginFailed => '구글 로그인에 실패했습니다.';

  @override
  String get signupScreenPreparation => '회원가입 화면 준비 중입니다';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'support@tripgether-official.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••••••';

  @override
  String get emailRequired => '이메일을 입력해주세요';

  @override
  String get emailInvalidFormat => '올바른 이메일 형식을 입력해주세요';

  @override
  String get passwordRequired => '비밀번호를 입력해주세요';

  @override
  String get passwordMinLength => '비밀번호는 최소 6자 이상이어야 합니다';

  @override
  String get autoLogin => '자동로그인';

  @override
  String get findId => '아이디';

  @override
  String get findPassword => '비밀번호 찾기';

  @override
  String get login => '로그인';

  @override
  String get signInWithGoogle => 'Google로 시작하기';

  @override
  String get signUpWithEmail => '이메일로 가입하기';
}
