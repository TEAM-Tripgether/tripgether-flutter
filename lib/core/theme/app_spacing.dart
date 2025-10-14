import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 앱 전체에서 사용하는 간격(Spacing) 상수
///
/// 모든 패딩, 마진, 간격은 이 클래스를 통해 일관되게 관리합니다.
/// ScreenUtil을 사용하여 반응형 크기를 지원합니다.
class AppSpacing {
  AppSpacing._(); // Private constructor to prevent instantiation

  // ==================== 기본 간격 단위 ====================
  /// 최소 간격: 4
  static double get xs => 4.w;

  /// 아주 작은 간격: 8
  static double get sm => 8.w;

  /// 작은 간격: 12
  static double get md => 12.w;

  /// 중간 간격: 16
  static double get lg => 16.w;

  /// 큰 간격: 20
  static double get xl => 20.w;

  /// 아주 큰 간격: 24
  static double get xxl => 24.w;

  /// 매우 큰 간격: 32
  static double get xxxl => 32.w;

  /// 초대형 간격: 40
  static double get huge => 40.w;

  // ==================== 화면별 패딩 ====================
  /// 화면 메인 패딩 (기본): 18
  static EdgeInsets get screenPadding => EdgeInsets.all(18.w);

  /// 화면 가로 패딩만: 18
  static EdgeInsets get screenHorizontal =>
      EdgeInsets.symmetric(horizontal: 18.w);

  /// 화면 큰 패딩 (로그인, 온보딩): 32
  static EdgeInsets get screenPaddingLarge => EdgeInsets.all(xxxl);

  /// 화면 큰 가로 패딩: 32
  static EdgeInsets get screenHorizontalLarge =>
      EdgeInsets.symmetric(horizontal: xxxl);

  // ==================== 카드/컨테이너 패딩 ====================
  /// 카드 내부 패딩: 16
  static EdgeInsets get cardPadding => EdgeInsets.all(lg);

  /// 카드 작은 패딩: 12
  static EdgeInsets get cardPaddingSmall => EdgeInsets.all(md);

  /// 리스트 아이템 패딩: 16
  static EdgeInsets get listItemPadding => EdgeInsets.all(lg);

  /// 리스트 아이템 가로 패딩: 16
  static EdgeInsets get listItemHorizontal =>
      EdgeInsets.symmetric(horizontal: lg);

  // ==================== 버튼 패딩 ====================
  /// 버튼 기본 패딩: 가로 24, 세로 14
  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: xxl, vertical: 14.h);

  /// 버튼 작은 패딩: 가로 16, 세로 12
  static EdgeInsets get buttonPaddingSmall =>
      EdgeInsets.symmetric(horizontal: lg, vertical: 12.h);

  /// 버튼 큰 패딩: 가로 32, 세로 16
  static EdgeInsets get buttonPaddingLarge =>
      EdgeInsets.symmetric(horizontal: xxxl, vertical: lg.h);

  // ==================== 수직 간격 (SizedBox용) ====================
  /// 최소 수직 간격: 4
  static SizedBox get verticalSpaceXS => SizedBox(height: xs.h);

  /// 아주 작은 수직 간격: 8
  static SizedBox get verticalSpaceSM => SizedBox(height: sm.h);

  /// 작은 수직 간격: 12
  static SizedBox get verticalSpaceMD => SizedBox(height: md.h);

  /// 중간 수직 간격: 16
  static SizedBox get verticalSpaceLG => SizedBox(height: lg.h);

  /// 큰 수직 간격: 20
  static SizedBox get verticalSpaceXL => SizedBox(height: xl.h);

  /// 아주 큰 수직 간격: 24
  static SizedBox get verticalSpaceXXL => SizedBox(height: xxl.h);

  /// 매우 큰 수직 간격: 32
  static SizedBox get verticalSpaceXXXL => SizedBox(height: xxxl.h);

  /// 초대형 수직 간격: 40
  static SizedBox get verticalSpaceHuge => SizedBox(height: huge.h);

  // ==================== 수평 간격 (SizedBox용) ====================
  /// 최소 수평 간격: 4
  static SizedBox get horizontalSpaceXS => SizedBox(width: xs);

  /// 아주 작은 수평 간격: 8
  static SizedBox get horizontalSpaceSM => SizedBox(width: sm);

  /// 작은 수평 간격: 12
  static SizedBox get horizontalSpaceMD => SizedBox(width: md);

  /// 중간 수평 간격: 16
  static SizedBox get horizontalSpaceLG => SizedBox(width: lg);

  /// 큰 수평 간격: 20
  static SizedBox get horizontalSpaceXL => SizedBox(width: xl);

  /// 아주 큰 수평 간격: 24
  static SizedBox get horizontalSpaceXXL => SizedBox(width: xxl);

  /// 매우 큰 수평 간격: 32
  static SizedBox get horizontalSpaceXXXL => SizedBox(width: xxxl);

  // ==================== 모달/다이얼로그 패딩 ====================
  /// 모달 내부 패딩: 24
  static EdgeInsets get modalPadding => EdgeInsets.all(xxl);

  /// 다이얼로그 내부 패딩: 24
  static EdgeInsets get dialogPadding => EdgeInsets.all(xxl);

  // ==================== 특수 패딩 ====================
  /// 세션 정보 컨테이너 패딩: 가로 16, 세로 12
  static EdgeInsets get sessionInfoPadding =>
      EdgeInsets.symmetric(horizontal: lg, vertical: md.h);

  /// AppBar 타이틀 좌측 패딩: 8
  static EdgeInsets get appBarTitlePadding => EdgeInsets.only(left: sm);

  /// AppBar 액션 우측 패딩: 8
  static EdgeInsets get appBarActionPadding => EdgeInsets.only(right: sm);

  /// 리스트 하단 여백 (스크롤용): 80
  static SizedBox get listBottomSpace => SizedBox(height: 80.h);

  // ==================== 유틸리티 메서드 ====================
  /// 커스텀 수직 간격
  static SizedBox verticalSpace(double height) => SizedBox(height: height.h);

  /// 커스텀 수평 간격
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  /// 커스텀 패딩 (전체)
  static EdgeInsets all(double value) => EdgeInsets.all(value.w);

  /// 커스텀 패딩 (대칭)
  static EdgeInsets symmetric({double? horizontal, double? vertical}) =>
      EdgeInsets.symmetric(
        horizontal: horizontal?.w ?? 0,
        vertical: vertical?.h ?? 0,
      );

  /// 커스텀 패딩 (개별)
  static EdgeInsets only({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) => EdgeInsets.only(
    left: left?.w ?? 0,
    top: top?.h ?? 0,
    right: right?.w ?? 0,
    bottom: bottom?.h ?? 0,
  );
}

// ==================== Border Radius 상수 ====================

/// 앱 전체에서 사용하는 Border Radius 상수
///
/// 모든 모서리 둥글기는 이 클래스를 통해 일관되게 관리합니다.
/// ScreenUtil을 사용하여 반응형 크기를 지원합니다.
class AppRadius {
  AppRadius._(); // Private constructor to prevent instantiation

  /// 아주 작은 반지름: 4 (체크박스, 라디오 버튼)
  static double get small => 4.r;

  /// 작은 반지름: 8 (칩, 스낵바, 툴팁, 텍스트 버튼)
  static double get medium => 8.r;

  /// 중간 반지름: 12 (버튼, 입력 필드, 카드)
  static double get large => 12.r;

  /// 큰 반지름: 16 (다이얼로그, 바텀시트)
  static double get xlarge => 16.r;

  /// 완전한 원형: 999 (아바타, FAB 등)
  static double get circle => 999.r;

  // ==================== BorderRadius 객체 ====================

  /// 전체 모서리에 small radius 적용
  static BorderRadius get allSmall => BorderRadius.circular(small);

  /// 전체 모서리에 medium radius 적용
  static BorderRadius get allMedium => BorderRadius.circular(medium);

  /// 전체 모서리에 large radius 적용
  static BorderRadius get allLarge => BorderRadius.circular(large);

  /// 전체 모서리에 xlarge radius 적용
  static BorderRadius get allXLarge => BorderRadius.circular(xlarge);

  /// 상단만 large radius 적용 (바텀시트)
  static BorderRadius get topLarge => BorderRadius.only(
        topLeft: Radius.circular(large),
        topRight: Radius.circular(large),
      );

  /// 상단만 xlarge radius 적용
  static BorderRadius get topXLarge => BorderRadius.only(
        topLeft: Radius.circular(xlarge),
        topRight: Radius.circular(xlarge),
      );

  /// 하단만 large radius 적용
  static BorderRadius get bottomLarge => BorderRadius.only(
        bottomLeft: Radius.circular(large),
        bottomRight: Radius.circular(large),
      );

  /// 커스텀 radius
  static BorderRadius circular(double radius) =>
      BorderRadius.circular(radius.r);

  /// 커스텀 radius (개별 지정)
  static BorderRadius only({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) =>
      BorderRadius.only(
        topLeft: Radius.circular((topLeft ?? 0).r),
        topRight: Radius.circular((topRight ?? 0).r),
        bottomLeft: Radius.circular((bottomLeft ?? 0).r),
        bottomRight: Radius.circular((bottomRight ?? 0).r),
      );
}

// ==================== Elevation 상수 ====================

/// 앱 전체에서 사용하는 Elevation (고도) 상수
///
/// 모든 그림자 높이는 이 클래스를 통해 일관되게 관리합니다.
/// Material Design 3 기준을 따릅니다.
class AppElevation {
  AppElevation._(); // Private constructor to prevent instantiation

  /// 그림자 없음: 0 (AppBar 기본 상태)
  static const double none = 0;

  /// 낮은 그림자: 1 (AppBar 스크롤 시, 칩)
  static const double low = 1;

  /// 중간 그림자: 2 (카드, Elevated Button)
  static const double medium = 2;

  /// 높은 그림자: 3 (Navigation Bar)
  static const double high = 3;

  /// 더 높은 그림자: 6 (Dialog, FAB)
  static const double higher = 6;

  /// 네비게이션 그림자: 8 (Bottom Navigation Bar, Drawer)
  static const double navigation = 8;
}

// ==================== Size 상수 ====================

/// 앱 전체에서 사용하는 Size 상수
///
/// 아이콘 크기, 컴포넌트 높이 등 다양한 크기 값을 관리합니다.
class AppSizes {
  AppSizes._(); // Private constructor to prevent instantiation

  // ==================== Icon Sizes ====================

  /// 작은 아이콘: 16
  static const double iconSmall = 16;

  /// 중간 아이콘: 20
  static const double iconMedium = 20;

  /// 일반 아이콘: 24 (기본)
  static const double iconDefault = 24;

  /// 큰 아이콘: 32
  static const double iconLarge = 32;

  /// 매우 큰 아이콘: 48
  static const double iconXLarge = 48;

  // ==================== Border Widths ====================

  /// 얇은 테두리: 1 (기본)
  static const double borderThin = 1;

  /// 중간 테두리: 2 (포커스 상태)
  static const double borderMedium = 2;

  /// 두꺼운 테두리: 3
  static const double borderThick = 3;

  // ==================== Component Heights ====================

  /// 버튼 최소 높이: 48
  static double get buttonHeight => 48.h;

  /// 텍스트 버튼 최소 높이: 40
  static double get textButtonHeight => 40.h;

  /// Navigation Bar 높이: 80
  static double get navigationBarHeight => 80.h;

  /// App Bar 높이: 56 (Material Design 기본)
  static double get appBarHeight => 56.h;

  /// Bottom Sheet 핸들 높이: 4
  static double get bottomSheetHandleHeight => 4.h;

  // ==================== Component Widths ====================

  /// 버튼 최소 너비: 88
  static const double buttonMinWidth = 88;

  /// 텍스트 버튼 최소 너비: 48
  static const double textButtonMinWidth = 48;

  /// FAB 크기: 56
  static const double fabSize = 56;

  /// FAB 작은 크기: 40
  static const double fabSmallSize = 40;

  /// FAB 큰 크기: 96
  static const double fabLargeSize = 96;
}

