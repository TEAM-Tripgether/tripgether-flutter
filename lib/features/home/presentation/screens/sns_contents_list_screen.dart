import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/models/content_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/cards/sns_content_card.dart';
import '../../../../shared/widgets/common/app_snackbar.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/empty_state.dart';
import '../../../../shared/widgets/common/chip_list.dart';
import '../../../../shared/widgets/dialogs/common_dialog.dart';
import '../providers/content_provider.dart';

/// SNS 콘텐츠 리스트 화면
///
/// 완료된 모든 SNS 콘텐츠를 그리드 레이아웃으로 표시합니다.
/// 홈 화면의 "최근 SNS에서 본 콘텐츠" 섹션에서 더보기 버튼을 통해 접근합니다.
/// 카테고리별 필터링 기능 포함 (전체/유튜브/인스타그램/틱톡)
class SnsContentsListScreen extends ConsumerStatefulWidget {
  const SnsContentsListScreen({super.key});

  @override
  ConsumerState<SnsContentsListScreen> createState() =>
      _SnsContentsListScreenState();
}

class _SnsContentsListScreenState extends ConsumerState<SnsContentsListScreen> {
  /// 선택된 카테고리 ('전체', 'YOUTUBE', 'INSTAGRAM', 'TIKTOK')
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentListAsync = ref.watch(completedContentsProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar.forSubPage(
        title: '', // 타이틀 제거
        rightActions: [
          // 편집 버튼 (PopupMenu)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            color: AppColors.white,
            offset: Offset(0, AppSpacing.xs), // 메뉴 위치를 아래로 이동
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            itemBuilder: (BuildContext context) {
              return [
                // 삭제 메뉴
                PopupMenuItem<String>(
                  value: 'delete',
                  height: AppSpacing.xxl,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      l10n.delete,
                      style: AppTextStyles.buttonMediumMedium14,
                    ),
                  ),
                ),
                // 구분선
                PopupMenuItem<String>(
                  enabled: false,
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  height: AppSizes.dividerThin,
                  child: Divider(
                    color: AppColors.subColor2,
                    thickness: AppSizes.dividerThin,
                  ),
                ),
                // 오류제보 메뉴
                PopupMenuItem<String>(
                  value: 'reportError',
                  height: AppSpacing.xxl,
                  padding: EdgeInsets.zero,
                  child: Center(
                    child: Text(
                      l10n.reportError,
                      style: AppTextStyles.buttonMediumMedium14,
                    ),
                  ),
                ),
              ];
            },
            onSelected: (String value) {
              switch (value) {
                case 'delete':
                  _handleDelete();
                  break;
                case 'reportError':
                  _handleReportError();
                  break;
              }
            },
          ),
        ],
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 제목 섹션 (notification_screen 패턴)
            Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.xxl,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                l10n.recentViewedContent,
                style: AppTextStyles.titleBold24.copyWith(
                  color: AppColors.textColor1,
                ),
              ),
            ),

            // 카테고리 필터 칩
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildCategoryChips(l10n),
            ),

            AppSpacing.verticalSpaceSM,

            // 콘텐츠 그리드
            Expanded(
              child: Container(
                color: AppColors.backgroundLight,
                child: contentListAsync.when(
                  data: (contents) {
                    // 카테고리 필터링
                    final filteredContents = _getFilteredContents(contents);

                    if (filteredContents.isEmpty) {
                      // 필터링 결과가 없을 때
                      return Center(
                        child: EmptyStates.noData(
                          title: _selectedCategory == '전체'
                              ? l10n.noSnsContentYet
                              : '해당 카테고리의 콘텐츠가 없습니다',
                          message: _selectedCategory == '전체'
                              ? l10n.noSnsContentMessage
                              : '다른 카테고리를 선택해보세요',
                        ),
                      );
                    }

                    // 콘텐츠 그리드 표시
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(completedContentsProvider);
                      },
                      child: GridView.builder(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.sm,
                          crossAxisSpacing: AppSpacing.sm,
                          childAspectRatio: 0.60,
                        ),
                        itemCount: filteredContents.length,
                        itemBuilder: (context, index) {
                          final content = filteredContents[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SNS 콘텐츠 카드
                              SnsContentCard(
                                content: content,
                                width: AppSizes.snsCardLargeWidth,
                                height: AppSizes.snsCardLargeHeight,
                                showTextOverlay: false,
                                logoPadding: EdgeInsets.all(AppSpacing.md),
                                logoIconSize: AppSizes.iconDefault,
                                onTap: () {
                                  context.push(
                                    '/home/sns-contents/detail/${content.contentId}',
                                    extra: content,
                                  );
                                },
                              ),

                              AppSpacing.verticalSpaceXSM,

                              // 콘텐츠 메타데이터
                              _buildContentMetadata(content),
                            ],
                          );
                        },
                      ),
                    );
                  },
                  loading: () => _buildLoadingShimmer(),
                  error: (error, stack) => Center(
                    child: EmptyStates.networkError(
                      title: l10n.cannotLoadContent,
                      message: l10n.networkError,
                      action: TextButton(
                        onPressed: () {
                          // Provider를 다시 로드하여 재시도
                          ref.invalidate(completedContentsProvider);
                        },
                        child: Text(
                          l10n.retry,
                          style: AppTextStyles.buttonMediumMedium14.copyWith(
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 카테고리 필터 칩 리스트
  ///
  /// 전체/유튜브/인스타그램 카테고리 선택 칩
  /// - 활성 칩: mainColor 배경 + white 텍스트
  /// - 비활성 칩: subColor2.withAlpha(0.2) 배경 + textColor1.withAlpha(0.4) 텍스트
  Widget _buildCategoryChips(AppLocalizations l10n) {
    final categories = ['전체', '유튜브', '인스타그램'];

    return SelectableChipList(
      items: categories,
      selectedItems: {_selectedCategory},
      onSelectionChanged: (selected) {
        if (selected.isNotEmpty) {
          setState(() {
            _selectedCategory = selected.first;
          });
        }
      },
      singleSelection: true,
      textStyle: AppTextStyles.bodyMedium14, // 사용자 요구사항: medium14
      horizontalPadding: 0, // 이미 부모에서 padding 적용
      showBorder: false, // 외곽선 제거
      borderRadius: 100, // 완전한 pill 모양
      horizontalSpacing: AppSpacing.sm, // 칩 간격 8px
      chipPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg, // 16px (기본 8px에서 증가)
        vertical: AppSpacing.sm, // 8px (기본 4px에서 증가)
      ),
      unselectedTextColor: AppColors.textColor1.withValues(
        alpha: 0.4,
      ), // 비활성 칩 텍스트 투명도
    );
  }

  /// 카테고리별 콘텐츠 필터링
  ///
  /// - '전체': 모든 콘텐츠 반환
  /// - '유튜브': platform == 'YOUTUBE'
  /// - '인스타그램': platform == 'INSTAGRAM'
  List<ContentModel> _getFilteredContents(List<ContentModel> contents) {
    if (_selectedCategory == '전체') {
      return contents;
    }

    // 카테고리명을 플랫폼 enum으로 매핑
    final platformMap = {'유튜브': 'YOUTUBE', '인스타그램': 'INSTAGRAM'};

    final platform = platformMap[_selectedCategory];
    if (platform == null) {
      return contents;
    }

    return contents
        .where((content) => content.platform.toUpperCase() == platform)
        .toList();
  }

  /// 콘텐츠 메타데이터 (채널명 + 제목)
  ///
  /// 카드 아래에 표시되는 텍스트 정보:
  /// - Line 1: platformUploader (채널명) - metaMedium12 + subColor2
  /// - Line 2: title 또는 caption (제목) - titleSemiBold14 + textColor1
  Widget _buildContentMetadata(ContentModel content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 채널명 (platformUploader)
        Text(
          content.platformUploader ?? '채널 정보 없음',
          style: AppTextStyles.metaMedium12.copyWith(
            color: AppColors.subColor2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        // 제목 (title 또는 caption)
        Text(
          content.title ?? content.caption ?? '제목 없음',
          style: AppTextStyles.titleSemiBold14,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  /// 로딩 중 Shimmer 효과
  Widget _buildLoadingShimmer() {
    return GridView.builder(
      padding: EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio:
            AppSizes.snsCardLargeWidth / AppSizes.snsCardLargeHeight,
      ),
      itemCount: 6, // 로딩 중 6개의 플레이스홀더 표시
      itemBuilder: (context, index) {
        return Container(
          width: AppSizes.snsCardLargeWidth,
          height: AppSizes.snsCardLargeHeight,
          decoration: BoxDecoration(
            borderRadius: AppRadius.allMedium,
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.5),
              width: AppSizes.borderThin,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSizes.borderThin),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                AppRadius.medium - AppSizes.borderThin,
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.subColor2.withValues(alpha: 0.3),
                highlightColor: AppColors.shimmerHighlight,
                child: Container(color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 삭제 기능 핸들러
  ///
  /// SNS 콘텐츠 삭제 확인 다이얼로그 표시 후 삭제 수행
  void _handleDelete() {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: const Text('선택한 콘텐츠를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.btnCancel),
          ),
          TextButton(
            onPressed: () {
              // TODO: 실제 삭제 로직 구현
              Navigator.of(context).pop();
              debugPrint('[SnsContentsListScreen] 삭제 실행');
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  /// 오류 제보 다이얼로그 표시
  ///
  /// CommonDialog.forInput을 사용한 텍스트 입력 다이얼로그 표시
  /// Controller는 애니메이션 완료 후 안전하게 dispose
  void _handleReportError() {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => CommonDialog.forInput(
        title: l10n.reportErrorTitle,
        subtitle: l10n.reportErrorDescription,
        inputHint: l10n.reportErrorHint,
        controller: controller,
        submitText: l10n.reportErrorSubmit,
        cancelText: l10n.btnCancel,
        onSubmit: _submitErrorReport,
        onCancel: () {}, // autoDismiss가 처리
      ),
    ).then((_) {
      // 애니메이션 완료 후 dispose (다이얼로그 닫힘 애니메이션 대기)
      Future.delayed(const Duration(milliseconds: 300), () {
        controller.dispose();
      });
    });
  }

  /// 오류 제보 제출 처리
  ///
  /// **로직 흐름**:
  /// 1. 입력값 검증 (빈 문자열 체크)
  /// 2. 빈 입력 → 경고 메시지 표시 후 종료 (다이얼로그 열린 상태 유지)
  /// 3. 정상 입력 → 디버그 출력 + 성공 메시지
  ///
  /// **autoDismiss: true 동작**:
  /// - onSubmit 콜백이 완료되면 CommonDialog가 자동으로 닫힘
  /// - 빈 입력일 때는 return으로 조기 종료하여 다이얼로그 유지
  void _submitErrorReport(String text) {
    final trimmedText = text.trim();

    // 빈 입력 검증
    if (trimmedText.isEmpty) {
      AppSnackBar.showInfo(context, '오류 내용을 입력해주세요.');
      return; // return만 하면 다이얼로그 유지됨
    }

    // 디버그 출력 (실제 API 호출 전)
    debugPrint('[SnsContentsListScreen] 오류 제보: $trimmedText');

    // 성공 메시지 표시
    AppSnackBar.showInfo(context, '소중한 제보 감사합니다.');

    // Navigator.pop() 불필요 - autoDismiss: true가 자동 처리
  }
}
