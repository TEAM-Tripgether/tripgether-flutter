import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../widgets/category_dropdown_button.dart';
import '../widgets/interest_chip.dart';
import '../widgets/onboarding_layout.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/onboarding_notifier.dart';
import '../../providers/interest_provider.dart';
import '../../utils/onboarding_error_handler.dart';
import '../../data/models/interest_response.dart';

/// 관심사 선택 페이지 (STEP 5/5)
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
  final void Function(String currentStep) onStepChange;
  final PageController pageController;

  const InterestsPage({
    super.key,
    required this.onNext,
    required this.onStepChange,
    required this.pageController,
  });

  @override
  ConsumerState<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends ConsumerState<InterestsPage> {
  // 로컬 상태: 선택된 관심사 ID들 (UUID)
  final Set<String> _selectedInterestIds = {};

  // 현재 열려있는 카테고리 코드 (한 번에 하나만 열림)
  String? _expandedCategoryCode;

  // 각 카테고리 버튼의 GlobalKey (위치 추적용)
  final Map<String, GlobalKey> _buttonKeys = {};

  // Overlay Entry (드롭다운 컨테이너)
  OverlayEntry? _overlayEntry;

  // API 호출 로딩 상태
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // onboardingProvider에서 저장된 관심사 불러오기 (UUID 목록)
    final savedInterests = ref.read(onboardingProvider).interests;
    _selectedInterestIds.addAll(savedInterests);
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
  void _handleInterestTap(String interestId) {
    setState(() {
      if (_selectedInterestIds.contains(interestId)) {
        _selectedInterestIds.remove(interestId);
      } else {
        if (_selectedInterestIds.length < 10) {
          _selectedInterestIds.add(interestId);
        }
      }
    });
  }

  /// Overlay 제거 함수
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 완료 버튼 핸들러 (API 호출)
  Future<void> _handleComplete() async {
    if (_selectedInterestIds.length < 3 || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      // 1. onboardingProvider에 관심사 저장 (로컬)
      ref
          .read(onboardingProvider.notifier)
          .updateInterests(_selectedInterestIds.toList());

      // 2. API 호출 (관심사 UUID 목록 전송)
      final response = await ref
          .read(onboardingNotifierProvider.notifier)
          .updateInterests(interestIds: _selectedInterestIds.toList());

      if (!mounted) return;

      // 3. API 응답 성공 시 currentStep에 따라 페이지 이동
      if (response != null) {
        debugPrint(
          '[InterestsPage] ✅ 관심사 설정 API 호출 성공 → 다음 단계: ${response.currentStep}',
        );
        widget.onStepChange(response.currentStep);
      }
    } catch (e) {
      debugPrint('[InterestsPage] ❌ 관심사 설정 API 호출 실패: $e');
      if (mounted) {
        await handleOnboardingError(context, ref, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 카테고리 드롭다운 토글 핸들러 (Overlay 방식)
  ///
  /// 같은 카테고리를 다시 탭하면 닫히고, 다른 카테고리를 탭하면 기존 것은 닫히고 새로운 것이 열립니다.
  void _toggleCategory(String categoryCode, InterestCategoryDto category) {
    // 이미 열려있는 경우 닫기
    if (_expandedCategoryCode == categoryCode) {
      setState(() {
        _expandedCategoryCode = null;
      });
      _removeOverlay();
      return;
    }

    // 기존 Overlay 제거
    _removeOverlay();

    // 새로운 카테고리 열기
    setState(() {
      _expandedCategoryCode = categoryCode;
    });

    // 버튼 위치 계산
    final buttonKey = _buttonKeys[categoryCode]!;
    final renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

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
                    _expandedCategoryCode = null;
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
              left: AppSpacing.lg, // 카테고리 영역과 동일한 패딩 16.w
              right: AppSpacing.lg, // 카테고리 영역과 동일한 패딩 16.w
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
                        color: AppColors.shadow.withValues(alpha: 0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: category.interests.map((item) {
                      final isSelected = _selectedInterestIds.contains(item.id);
                      return InterestChip(
                        label: item.name,
                        isSelected: isSelected,
                        onTap: () {
                          // 부모 위젯 상태 업데이트 (selectedCount 및 버튼 표시)
                          _handleInterestTap(item.id);
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
    final selectedCount = _selectedInterestIds.length;
    final isValid = selectedCount >= 3 && selectedCount <= 10;

    // API로부터 관심사 카테고리 데이터 로드
    final categoriesAsync = ref.watch(interestsProvider);

    return categoriesAsync.when(
      // 로딩 중
      loading: () => const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.mainColor),
        ),
      ),

      // 에러 발생
      error: (error, stack) {
        debugPrint('[InterestsPage] ❌ 관심사 조회 실패: $error');

        // 에러 발생 시 즉시 로그아웃 처리
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (context.mounted) {
            await handleOnboardingError(context, ref, error);
          }
        });

        // 로그아웃 처리 중 임시 화면 표시
        return const Scaffold(
          backgroundColor: AppColors.surface,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.mainColor),
          ),
        );
      },

      // 데이터 로드 성공
      data: (response) {
        // 하위 관심사 개수가 많은 순서로 정렬
        final categories = response.categories.toList()
          ..sort((a, b) => b.interests.length.compareTo(a.interests.length));

        // GlobalKey 초기화 (처음 한 번만)
        if (_buttonKeys.isEmpty) {
          for (var category in categories) {
            _buttonKeys[category.category] = GlobalKey();
          }
        }

        return OnboardingLayout(
          stepNumber: 5,
          title: l10n.onboardingInterestsPrompt,
          showRequiredMark: false,
          description: l10n.onboardingInterestsDescription,
          // 카테고리 버튼 영역만 16px 패딩 (버튼은 32px 유지)
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          content: Column(
            children: [
              AppSpacing.verticalSpaceMD,

              // 선택 개수 표시
              Text(
                l10n.onboardingInterestsSelectedCount(selectedCount),
                style: AppTextStyles.titleSemiBold16.copyWith(
                  color: AppColors.mainColor,
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
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: categories.map((category) {
                          final isExpanded =
                              _expandedCategoryCode == category.category;

                          // 이 카테고리에서 선택된 관심사 개수 계산
                          final selectedInCategory = category.interests
                              .where(
                                (item) =>
                                    _selectedInterestIds.contains(item.id),
                              )
                              .length;

                          return Container(
                            key: _buttonKeys[category.category],
                            child: CategoryDropdownButton(
                              categoryName: category.displayName,
                              isExpanded: isExpanded,
                              selectedCount: selectedInCategory,
                              onTap: () =>
                                  _toggleCategory(category.category, category),
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
                  color: AppColors.subColor2,
                ),
                textAlign: TextAlign.center,
              ),

              AppSpacing.verticalSpaceLG,
            ],
          ),
          button: PrimaryButton(
            text: l10n.btnComplete,
            onPressed: isValid && !_isLoading ? _handleComplete : null,
            isLoading: _isLoading,
            isFullWidth: true,
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.circle),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
