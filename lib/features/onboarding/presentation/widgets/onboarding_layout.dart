import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

/// 온보딩 페이지 공통 레이아웃 위젯 (DRY 원칙 적용)
///
/// 모든 온보딩 페이지(STEP 1-5)에서 공통적으로 사용되는 레이아웃 구조를 캡슐화합니다.
///
/// **공통 구조**:
/// 1. verticalSpace36 (프로그레스바 아래 고정 간격)
/// 2. STEP 라벨 (hardcoded: "STEP 1", "STEP 2", etc.)
/// 3. verticalSpaceLG (STEP과 제목 사이)
/// 4. 제목 (titleBold24, mainColor) + 선택적 필수 마크(*)
/// 5. verticalSpaceLG (제목과 설명 사이)
/// 6. 설명 (buttonMediumMedium14, textColor1 alpha 0.5)
/// 7. content (페이지별 고유 콘텐츠 영역 - Expanded 사용)
/// 8. button (하단 버튼)
/// 9. verticalSpace60 (하단 고정 간격)
///
/// **contentPadding 파라미터 (2025-11-14 추가)**:
/// - null (기본값): content 영역이 전체 32px 패딩 안에 배치 (기존 동작)
/// - EdgeInsets 지정: content 영역만 별도 패딩 적용 (버튼은 여전히 32px 유지)
/// - 용도: interests_page처럼 특정 영역만 좁은 패딩이 필요한 경우
///
/// **사용 예시**:
/// ```dart
/// // 기본 사용 (전체 32px 패딩)
/// OnboardingLayout(
///   stepNumber: 1,
///   title: l10n.onboardingTermsPrompt,
///   description: l10n.onboardingTermsDescription,
///   showRequiredMark: true,
///   content: Column(children: [...]),
///   button: PrimaryButton(...),
/// )
///
/// // content만 16px 패딩 (버튼은 32px 유지)
/// OnboardingLayout(
///   stepNumber: 5,
///   contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.lg), // 16
///   content: Wrap(...), // 카테고리 버튼들
///   button: PrimaryButton(...), // 여전히 32px 패딩
/// )
/// ```
class OnboardingLayout extends StatelessWidget {
  /// STEP 번호 (1-5)
  /// "STEP 1", "STEP 2" 형식으로 표시됨
  final int stepNumber;

  /// 제목 텍스트
  final String title;

  /// 필수 입력 마크(*) 표시 여부
  final bool showRequiredMark;

  /// 설명 텍스트
  final String description;

  /// 페이지별 고유 콘텐츠 위젯
  /// Expanded로 감싸져서 남은 공간을 차지함
  final Widget content;

  /// content 영역에만 적용할 패딩 (옵션)
  /// - null: content가 전체 32px 패딩 안에 배치 (기본 동작)
  /// - EdgeInsets: content만 별도 패딩 적용 (버튼은 여전히 32px)
  final EdgeInsetsGeometry? contentPadding;

  /// 하단 버튼 위젯
  final Widget button;

  const OnboardingLayout({
    super.key,
    required this.stepNumber,
    required this.title,
    this.showRequiredMark = false,
    required this.description,
    required this.content,
    this.contentPadding,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    // contentPadding이 null일 때: 전체에 32px 패딩 적용 (기존 동작)
    // contentPadding이 있을 때: 헤더/버튼만 32px, content는 지정된 패딩 사용
    final defaultPadding = EdgeInsets.symmetric(horizontal: AppSpacing.xxxl);

    // 헤더 영역 (STEP, 제목, 설명)
    final headerSection = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. 프로그레스바 아래 고정 간격
        AppSpacing.verticalSpaceLG,

        // 2. STEP 라벨 (hardcoded, 국제화 불필요)
        Text(
          'STEP $stepNumber',
          style: AppTextStyles.buttonMediumMedium14.copyWith(
            color: AppColors.subColor2,
          ),
        ),

        // 3. STEP과 제목 사이 간격
        AppSpacing.verticalSpaceLG,

        // 4. 제목 + 선택적 필수 마크(*)
        if (showRequiredMark)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleBold24.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
              AppSpacing.horizontalSpace(4),
              Text(
                '*',
                style: AppTextStyles.greetingSemiBold20.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
          )
        else
          Text(
            title,
            style: AppTextStyles.titleBold24.copyWith(
              color: AppColors.mainColor,
            ),
          ),

        // 5. 제목과 설명 사이 간격
        AppSpacing.verticalSpaceLG,

        // 6. 설명
        Text(
          description,
          style: AppTextStyles.buttonMediumMedium14.copyWith(
            color: AppColors.textColor1.withValues(alpha: 0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    // contentPadding이 null인 경우: 기존 동작 (전체 32px 패딩)
    if (contentPadding == null) {
      return Padding(
        padding: defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            headerSection,
            Expanded(child: content),
            button,
            AppSpacing.verticalSpace90,
          ],
        ),
      );
    }

    // contentPadding이 있는 경우: 헤더/버튼만 32px, content는 별도 패딩
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 헤더 영역 (32px 패딩)
        Padding(padding: defaultPadding, child: headerSection),

        // 7. 페이지별 콘텐츠 영역 (지정된 패딩 적용)
        Expanded(
          child: Padding(padding: contentPadding!, child: content),
        ),

        // 8. 하단 버튼 (좌우 32px 패딩)
        Padding(padding: defaultPadding, child: button),

        // 9. 하단 고정 간격
        AppSpacing.verticalSpace80,
      ],
    );
  }
}
