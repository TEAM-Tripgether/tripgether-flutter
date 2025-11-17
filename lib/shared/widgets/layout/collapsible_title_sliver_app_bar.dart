import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// 스크롤 시 제목이 점진적으로 축소되며 사라지는 SliverAppBar
///
/// **DRY 원칙 적용**: home_screen.dart와 sns_contents_list_screen.dart의
/// FlexibleSpaceBar 애니메이션 로직을 공통화
///
/// **핵심 기능**:
/// - FlexibleSpaceBarSettings에서 스크롤 진행도(expandRatio) 자동 계산
/// - collapsibleContent 빌더를 통해 유연한 제목 영역 구성
/// - Opacity + Transform.scale 애니메이션으로 부드러운 축소 효과
///
/// **사용 예시**:
/// ```dart
/// // home_screen: 인사말 2줄 축소
/// CollapsibleTitleSliverAppBar(
///   expandedHeight: 190.h,
///   title: SvgPicture.asset('logo.svg'),
///   actions: [NotificationButton()],
///   collapsibleContent: (expandRatio) => Opacity(
///     opacity: expandRatio,
///     child: Text('안녕하세요!'),
///   ),
///   bottom: PreferredSize(child: SearchBar()),
/// )
///
/// // sns_contents_list_screen: 제목 1줄 축소
/// CollapsibleTitleSliverAppBar(
///   expandedHeight: 140.h,
///   actions: [PopupMenuButton()],
///   collapsibleContent: (expandRatio) => Opacity(
///     opacity: expandRatio,
///     child: Text('최근 본 콘텐츠'),
///   ),
///   bottom: PreferredSize(child: CategoryChips()),
/// )
/// ```
class CollapsibleTitleSliverAppBar extends StatelessWidget {
  /// 스크롤 시 축소되는 제목 영역 빌더
  ///
  /// **expandRatio**: 0.0 (완전 축소) ~ 1.0 (완전 확장)
  /// - 이 값을 사용하여 Opacity, Transform.scale 등의 애니메이션 구현
  /// - home_screen: 인사말 2줄에 적용
  /// - sns_contents_list_screen: "최근 본 콘텐츠" 제목에 적용
  final Widget Function(double expandRatio) collapsibleContent;

  /// 상단 고정 타이틀 위젯 (선택 사항)
  ///
  /// **home_screen**: Tripgether 로고 SVG
  /// **sns_contents_list_screen**: null (타이틀 없음)
  final Widget? title;

  /// 우측 액션 버튼들 (선택 사항)
  ///
  /// **home_screen**: [알림 버튼]
  /// **sns_contents_list_screen**: [PopupMenuButton(삭제, 오류제보)]
  final List<Widget>? actions;

  /// 하단 고정 영역 (선택 사항)
  ///
  /// **home_screen**: TripSearchBar (검색바)
  /// **sns_contents_list_screen**: SelectableChipList (카테고리 칩)
  final PreferredSizeWidget? bottom;

  /// SliverAppBar 확장 높이
  ///
  /// **home_screen**: 190.h (인사말 2줄 + 검색바)
  /// **sns_contents_list_screen**: 140.h (제목 1줄 + 칩)
  final double expandedHeight;

  /// 툴바 높이 (선택 사항, 기본값: kToolbarHeight)
  final double? toolbarHeight;

  /// 배경색 (기본값: AppColors.white)
  final Color? backgroundColor;

  /// 스크롤 시 최소 높이 유지 여부 (기본값: true)
  ///
  /// true: 스크롤 시에도 툴바 영역 고정
  /// false: 완전히 사라짐
  final bool pinned;

  /// title 위젯의 왼쪽 간격 (선택 사항)
  ///
  /// **home_screen**: AppSpacing.lg (로고 왼쪽 간격)
  final double? titleSpacing;

  /// title 위젯을 중앙 정렬할지 여부 (기본값: false)
  ///
  /// **home_screen**: false (왼쪽 정렬)
  final bool centerTitle;

  const CollapsibleTitleSliverAppBar({
    super.key,
    required this.collapsibleContent,
    required this.expandedHeight,
    this.title,
    this.actions,
    this.bottom,
    this.toolbarHeight,
    this.backgroundColor,
    this.pinned = true,
    this.titleSpacing,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: pinned,
      expandedHeight: expandedHeight,
      backgroundColor: backgroundColor ?? AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent, // Material 3 기본 틴트 제거
      automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
      toolbarHeight: toolbarHeight ?? kToolbarHeight,
      centerTitle: centerTitle,
      title: title,
      titleSpacing: titleSpacing,
      actions: actions,

      // FlexibleSpaceBar: 스크롤 정도에 따라 점진적 축소
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.zero, // 기본 패딩 제거

        background: Builder(
          builder: (context) {
            // FlexibleSpaceBarSettings에서 스크롤 진행도 추출
            final settings = context.dependOnInheritedWidgetOfExactType<
                FlexibleSpaceBarSettings>();
            final currentExtent = settings?.currentExtent ?? expandedHeight;
            final minExtent =
                settings?.minExtent ?? (toolbarHeight ?? kToolbarHeight);
            final maxExtent = settings?.maxExtent ?? expandedHeight;

            // expandRatio 계산 (0.0 = 완전 축소, 1.0 = 완전 확장)
            final expandRatio =
                ((currentExtent - minExtent) / (maxExtent - minExtent))
                    .clamp(0.0, 1.0);

            // collapsibleContent에 expandRatio 전달
            return SafeArea(
              bottom: false,
              child: collapsibleContent(expandRatio),
            );
          },
        ),
      ),

      bottom: bottom,
    );
  }
}
