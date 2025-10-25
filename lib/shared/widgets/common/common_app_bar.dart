import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../l10n/app_localizations.dart';

/// Tripgether 앱에서 사용하는 공용 AppBar 컴포넌트
///
/// 모든 화면에서 일관된 AppBar UI를 제공하며, 다양한 커스터마이징이 가능합니다.
/// Material 3 디자인 시스템과 앱의 테마를 완전히 준수합니다.
///
/// 주요 기능:
/// - 제목 커스터마이징 (기본값: "Tripgether")
/// - 왼쪽 액션 버튼 설정 (기본값: 햄버거 메뉴 또는 자동 뒤로가기)
/// - 오른쪽 액션 버튼들 설정 (기본값: 알림 아이콘)
/// - ScreenUtil을 활용한 반응형 사이즈 적용
/// - 접근성 및 시맨틱 라벨 지원
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// AppBar에 표시될 제목
  /// 기본값은 "Tripgether"이며, 다른 화면에서는 해당 화면의 제목을 사용
  final String title;

  /// 왼쪽에 표시될 액션 위젯
  /// null일 경우 자동으로 햄버거 메뉴 또는 뒤로가기 버튼을 표시
  final Widget? leftAction;

  /// 오른쪽에 표시될 액션 위젯들의 리스트
  /// 기본값은 알림 아이콘 하나가 표시됨
  final List<Widget>? rightActions;

  /// 제목의 텍스트 스타일
  /// null일 경우 앱 테마의 기본 스타일 사용
  final TextStyle? titleStyle;

  /// AppBar의 배경색
  /// null일 경우 앱 테마의 기본 색상 사용
  final Color? backgroundColor;

  /// AppBar의 그림자 높이
  /// 기본값은 0 (그림자 없음)
  final double elevation;

  /// 스크롤 시 AppBar 아래에 나타나는 그림자 높이
  /// 기본값은 1
  final double scrolledUnderElevation;

  /// 햄버거 메뉴 버튼을 눌렀을 때 실행될 콜백
  /// null일 경우 기본 Drawer를 열거나 뒤로가기 동작 수행
  final VoidCallback? onMenuPressed;

  /// 알림 아이콘을 눌렀을 때 실행될 콜백
  /// null일 경우 기본 동작 없음
  final VoidCallback? onNotificationPressed;

  /// 뒤로가기 버튼 표시 여부를 강제로 설정
  /// null일 경우 Navigator의 canPop() 상태에 따라 자동 결정
  final bool? showBackButton;

  /// 햄버거 메뉴 버튼 표시 여부
  /// 기본값은 true
  final bool showMenuButton;

  /// 알림 아이콘 표시 여부
  /// 기본값은 true
  final bool showNotificationIcon;

  const CommonAppBar({
    super.key,
    this.title = 'Tripgether',
    this.leftAction,
    this.rightActions,
    this.titleStyle,
    this.backgroundColor,
    this.elevation = 0,
    this.scrolledUnderElevation = 1,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.showBackButton,
    this.showMenuButton = true,
    this.showNotificationIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 제목 설정
      title: Text(
        title,
        style: titleStyle, // AppTheme에서 이미 AppBar 제목 스타일이 정의되어 있음
      ),

      // 제목을 중앙에 정렬
      centerTitle: true,

      // 배경색 설정 (기본값: 앱 테마 색상)
      backgroundColor: backgroundColor ?? AppColors.surface,

      // 텍스트 및 아이콘 색상
      foregroundColor: AppColors.onSurface,

      // 그림자 설정
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,

      // Surface tint 색상 (Material 3)
      surfaceTintColor: AppColors.surfaceTint,

      // 왼쪽 액션 설정
      leading: _buildLeftAction(context),

      // 자동 뒤로가기 버튼 표시 여부
      automaticallyImplyLeading: false,

      // 오른쪽 액션들 설정
      actions: _buildRightActions(context),

      // 아이콘 테마
      iconTheme: IconThemeData(
        color: AppColors.onSurface,
        size: AppSizes.iconDefault, // ScreenUtil로 반응형 크기
      ),
    );
  }

  /// 왼쪽 액션 위젯을 빌드하는 메서드
  /// 우선순위: leftAction > 강제 뒤로가기 > 자동 뒤로가기 > 햄버거 메뉴
  Widget? _buildLeftAction(BuildContext context) {
    // 1. 커스텀 leftAction이 제공된 경우
    if (leftAction != null) {
      return leftAction;
    }

    // 2. 뒤로가기 버튼을 강제로 표시하거나, GoRouter에 이전 화면이 있는 경우
    // GoRouter 사용 시 context.canPop() 사용 (Navigator.canPop()과 다름)
    final shouldShowBackButton = showBackButton ?? context.canPop();

    if (shouldShowBackButton) {
      return Semantics(
        label: '뒤로가기 버튼', // 스크린 리더용 시맨틱 라벨
        button: true,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: AppSizes.iconMedium, // ScreenUtil로 반응형 크기
          ),
          onPressed: () {
            // GoRouter 사용 시 context.pop() 사용
            // 안전을 위해 canPop() 체크 후 pop 실행
            if (context.canPop()) {
              context.pop();
            }
          },
          tooltip: '뒤로가기', // 접근성을 위한 툴팁
        ),
      );
    }

    // 3. 햄버거 메뉴 버튼 표시 (showMenuButton이 true인 경우)
    if (showMenuButton) {
      return Semantics(
        label: '메뉴 버튼', // 스크린 리더용 시맨틱 라벨
        button: true,
        child: IconButton(
          icon: Icon(
            Icons.menu,
            size: AppSizes.iconDefault, // ScreenUtil로 반응형 크기
          ),
          onPressed: onMenuPressed ?? () => _openDrawer(context),
          tooltip: '메뉴', // 접근성을 위한 툴팁
        ),
      );
    }

    return null;
  }

  /// 오른쪽 액션들을 빌드하는 메서드
  List<Widget>? _buildRightActions(BuildContext context) {
    // 커스텀 rightActions가 제공된 경우
    if (rightActions != null) {
      return rightActions;
    }

    // 기본 알림 아이콘 표시
    if (showNotificationIcon) {
      return [
        Semantics(
          label: '알림 버튼', // 스크린 리더용 시맨틱 라벨
          button: true,
          child: IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              size: AppSizes.iconDefault, // ScreenUtil로 반응형 크기
            ),
            onPressed:
                onNotificationPressed ?? () => _showNotificationDialog(context),
            tooltip: '알림', // 접근성을 위한 툴팁
          ),
        ),
        // 오른쪽 마진 추가 (Material Design 가이드라인)
        SizedBox(width: AppSpacing.sm),
      ];
    }

    return null;
  }

  /// Drawer를 여는 기본 동작
  /// Scaffold.of(context).openDrawer()를 호출하거나, Drawer가 없으면 아무 동작 안함
  void _openDrawer(BuildContext context) {
    try {
      Scaffold.of(context).openDrawer();
    } catch (e) {
      // Drawer가 없는 경우 무시
      debugPrint('Drawer가 설정되어 있지 않습니다.');
    }
  }

  /// 알림 아이콘의 기본 동작
  /// 현재는 간단한 다이얼로그를 표시 (향후 알림 페이지로 이동하도록 변경 가능)
  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('알림'), // AppTheme의 dialogTheme.titleTextStyle 사용
        content: Text(
          '현재 새로운 알림이 없습니다.',
        ), // AppTheme의 dialogTheme.contentTextStyle 사용
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppLocalizations.of(context).btnConfirm,
            ), // AppTheme의 textButtonTheme.style.textStyle 사용
          ),
        ],
      ),
    );
  }

  /// PreferredSizeWidget 인터페이스 구현
  /// AppBar의 기본 높이를 반환 (ScreenUtil 적용)
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);

  /// 홈 화면용 AppBar 생성
  /// 기본 설정으로 "Tripgether" 제목과 햄버거 메뉴, 알림 아이콘을 표시
  static CommonAppBar forHome({
    VoidCallback? onMenuPressed,
    VoidCallback? onNotificationPressed,
  }) {
    return CommonAppBar(
      title: 'Tripgether',
      onMenuPressed: onMenuPressed,
      onNotificationPressed: onNotificationPressed,
    );
  }

  /// 서브 페이지용 AppBar 생성
  /// 뒤로가기 버튼과 커스텀 제목을 표시
  static CommonAppBar forSubPage({
    required String title,
    List<Widget>? rightActions,
    VoidCallback? onNotificationPressed,
  }) {
    return CommonAppBar(
      title: title,
      showBackButton: true,
      showMenuButton: false,
      rightActions: rightActions,
      onNotificationPressed: onNotificationPressed,
    );
  }

  /// 설정 화면용 AppBar 생성
  /// 뒤로가기 버튼과 저장 버튼을 표시
  static CommonAppBar forSettings({
    String title = '설정',
    VoidCallback? onSavePressed,
  }) {
    return CommonAppBar(
      title: title,
      showBackButton: true,
      showMenuButton: false,
      showNotificationIcon: false,
      rightActions: onSavePressed != null
          ? [
              Semantics(
                label: '설정 버튼', // 스크린 리더용 시맨틱 라벨
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: onSavePressed,
                  tooltip: '설정',
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ]
          : null,
    );
  }

  /// 검색 화면용 AppBar 생성
  /// 뒤로가기 버튼과 검색 아이콘을 표시
  static CommonAppBar forSearch({
    String title = '검색',
    VoidCallback? onSearchPressed,
  }) {
    return CommonAppBar(
      title: title,
      showBackButton: true,
      showMenuButton: false,
      showNotificationIcon: false,
      rightActions: onSearchPressed != null
          ? [
              Semantics(
                label: '검색 버튼', // 스크린 리더용 시맨틱 라벨
                button: true,
                child: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: onSearchPressed,
                  tooltip: '검색',
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ]
          : null,
    );
  }
}
