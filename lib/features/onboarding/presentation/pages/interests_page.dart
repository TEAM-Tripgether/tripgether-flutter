import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../constants/interest_categories.dart';
import '../widgets/category_dropdown_button.dart';
import '../widgets/interest_chip.dart';
import '../../providers/onboarding_provider.dart';

/// 관심사 선택 페이지 (페이지 4/5)
///
/// 14개 카테고리에서 최소 3개, 최대 10개의 관심사를 선택할 수 있습니다.
/// Wrap 레이아웃으로 카테고리 버튼을 배치하고, 탭 시 바텀시트로 세부 항목 선택합니다.
///
/// **디자인 변경 (2025-11-02)**:
/// - 기존: Accordion 방식 (한 번에 하나씩 펼침)
/// - 신규: Wrap 레이아웃 (화면 너비에 맞춰 자동 배치) + BottomSheet
///
/// **Provider 연동**:
/// - onboardingProvider에 관심사 목록 저장
class InterestsPage extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  final PageController pageController;

  const InterestsPage({
    super.key,
    required this.onNext,
    required this.pageController,
  });

  @override
  ConsumerState<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends ConsumerState<InterestsPage> {
  // 로컬 상태: 선택된 관심사들
  final Set<String> _selectedInterests = {};

  // 현재 열려있는 카테고리 ID (한 번에 하나만 열림)
  String? _expandedCategoryId;

  // 각 카테고리 버튼의 GlobalKey (위치 추적용)
  final Map<String, GlobalKey> _buttonKeys = {};

  // Overlay Entry (드롭다운 컨테이너)
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    // onboardingProvider에서 저장된 관심사 불러오기
    final savedInterests = ref.read(onboardingProvider).interests;
    _selectedInterests.addAll(savedInterests);

    // 각 카테고리에 GlobalKey 할당
    for (var category in interestCategories) {
      _buttonKeys[category.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    // Overlay 정리
    _removeOverlay();
    super.dispose();
  }

  /// 관심사 항목 탭 핸들러
  ///
  /// 이미 선택된 항목이면 제거하고, 선택되지 않은 항목이면 추가합니다.
  /// 단, 최대 10개까지만 선택할 수 있습니다.
  void _handleInterestTap(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        if (_selectedInterests.length < 10) {
          _selectedInterests.add(interest);
        }
      }
    });
  }

  /// Overlay 제거 함수
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 카테고리 드롭다운 토글 핸들러 (Overlay 방식)
  ///
  /// 같은 카테고리를 다시 탭하면 닫히고, 다른 카테고리를 탭하면 기존 것은 닫히고 새로운 것이 열립니다.
  void _toggleCategory(String categoryId) {
    // 이미 열려있는 경우 닫기
    if (_expandedCategoryId == categoryId) {
      setState(() {
        _expandedCategoryId = null;
      });
      _removeOverlay();
      return;
    }

    // 기존 Overlay 제거
    _removeOverlay();

    // 새로운 카테고리 열기
    setState(() {
      _expandedCategoryId = categoryId;
    });

    // 버튼 위치 계산
    final buttonKey = _buttonKeys[categoryId]!;
    final renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    // 카테고리 데이터
    final category = interestCategories.firstWhere(
      (cat) => cat.id == categoryId,
    );

    // Overlay 생성 및 표시
    _overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
        builder: (context, overlaySetState) => Stack(
          children: [
            // 배경 영역 (탭 시 드롭다운 닫기)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedCategoryId = null;
                  });
                  _removeOverlay();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),

            // 드롭다운 컨테이너
            Positioned(
              top:
                  buttonPosition.dy +
                  buttonSize.height +
                  AppSpacing.sm, // 버튼 아래 8.h
              left: AppSpacing.xxl, // 화면 좌측 패딩 24.w
              right: AppSpacing.xxl, // 화면 우측 패딩 24.w
              child: Material(
                elevation: 4,
                borderRadius: AppRadius.allLarge,
                color: AppColors.surface,
                child: Container(
                  padding: AppSpacing.cardPadding, // 16 (좌우상하)
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: AppRadius.allLarge,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: AppSpacing.sm,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: category.items.map((item) {
                      final isSelected = _selectedInterests.contains(item);
                      return InterestChip(
                        label: item,
                        isSelected: isSelected,
                        onTap: () {
                          // 부모 위젯 상태 업데이트 (selectedCount 및 버튼 표시)
                          _handleInterestTap(item);
                          // Overlay 내부만 재빌드 (칩 선택 상태 시각적 업데이트)
                          overlaySetState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final selectedCount = _selectedInterests.length;
    final isValid = selectedCount >= 3 && selectedCount <= 10;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 상단 여백 (위로 올림)
          AppSpacing.verticalSpaceHuge,

          // 제목 (고정)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingInterestsPrompt,
                style: AppTextStyles.greetingSemiBold20.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gradient2, // #5325CB - 선명한 보라색
                ),
              ),
              AppSpacing.horizontalSpace(4),
              Text(
                '*',
                style: AppTextStyles.greetingSemiBold20.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          // 제목-설명 간격
          AppSpacing.verticalSpaceSM,

          // 설명 (제목 바로 아래, 국제화 적용)
          Text(
            l10n.onboardingInterestsDescription,
            style: AppTextStyles.metaMedium12.copyWith(
              color: AppColors.onboardingDescription, // #130537 - 진한 남보라
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalSpaceMD,

          // 선택 개수 표시
          Text(
            '$selectedCount개 선택',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),

          AppSpacing.verticalSpaceMD,

          // 카테고리 버튼 목록 영역 (스크롤 가능)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 카테고리 드롭다운 버튼들 (Wrap 레이아웃)
                  // 화면 너비에 따라 자동으로 배치됨 (4글자 = 3개/줄, 7글자 = 2개/줄)
                  // 각 버튼에 GlobalKey를 연결하여 위치 추적
                  Wrap(
                    spacing: 8, // 버튼 간 가로 간격
                    runSpacing: 8, // 버튼 간 세로 간격
                    children: interestCategories.map((category) {
                      final isExpanded = _expandedCategoryId == category.id;

                      // 이 카테고리에서 선택된 관심사 개수 계산
                      final selectedInCategory = category.items
                          .where((item) => _selectedInterests.contains(item))
                          .length;

                      return Container(
                        key: _buttonKeys[category.id], // GlobalKey 연결
                        child: CategoryDropdownButton(
                          categoryName: category.name,
                          isExpanded: isExpanded,
                          selectedCount: selectedInCategory,
                          onTap: () => _toggleCategory(category.id),
                        ),
                      );
                    }).toList(),
                  ),

                  // 하단 여백 (스크롤용)
                  AppSpacing.verticalSpaceLG,
                ],
              ),
            ),
          ),

          // 안내 문구 (버튼 위, 국제화 적용)
          Text(
            l10n.onboardingInterestsChangeInfo,
            style: AppTextStyles.metaMedium12.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          AppSpacing.verticalSpaceMD,

          // 완료하기 버튼 (국제화 적용)
          PrimaryButton(
            text: l10n.btnComplete,
            onPressed: isValid
                ? () {
                    // onboardingProvider에 관심사 저장
                    ref
                        .read(onboardingProvider.notifier)
                        .updateInterests(_selectedInterests.toList());

                    // 다음 페이지로 이동 (welcome_page)
                    widget.onNext();
                  }
                : null,
            isFullWidth: true,
            // 소셜 로그인 버튼과 동일한 완전한 pill 모양 적용
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
              ),
            ),
          ),

          // 하단 여백 (버튼을 조금 위로)
          AppSpacing.verticalSpace60,
        ],
      ),
    );
  }
}
