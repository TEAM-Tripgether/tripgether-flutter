import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../data/models/policy_model.dart';
import '../../data/services/policy_service.dart';

/// 약관/정책 상세 페이지 (심플 버전)
///
/// **디자인 원칙**:
/// - 텍스트 중심의 심플한 UI
/// - 섹션 구분 없이 연속된 텍스트 흐름
/// - 카드/그림자 효과 제거
///
/// **사용처**:
/// - 온보딩 약관 동의 화면에서 "자세히 보기" 클릭 시
/// - 마이페이지 "정책 & 안전" 섹션에서 이용약관/개인정보처리방침 클릭 시
class PolicyDetailScreen extends ConsumerWidget {
  const PolicyDetailScreen({
    super.key,
    required this.policyType,
  });

  final PolicyType policyType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final policyAsync = ref.watch(policyProvider(policyType));

    return Scaffold(
      appBar: CommonAppBar.forSubPage(title: policyType.displayName),
      backgroundColor: AppColors.white,
      body: policyAsync.when(
        data: (policy) => _PolicyContent(policy: policy),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _PolicyErrorView(
          error: error,
          onRetry: () => ref.invalidate(policyProvider(policyType)),
        ),
      ),
    );
  }
}

/// 약관 콘텐츠 (심플 버전)
class _PolicyContent extends StatelessWidget {
  const _PolicyContent({required this.policy});

  final PolicyModel policy;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 메타 정보 (버전 · 최종 수정일)
          Text(
            '버전 ${policy.version} · 최종 수정일 ${policy.lastUpdated}',
            style: AppTextStyles.caption12.copyWith(
              color: AppColors.subColor2,
            ),
          ),
          AppSpacing.verticalSpaceLG,

          // 약관 전체 내용 (섹션 구분 없이 연속)
          ...policy.sections.map((section) => _buildSection(section)),

          AppSpacing.verticalSpaceXXL,
        ],
      ),
    );
  }

  /// 섹션 빌드 (제목 + 내용, 구분선 없음)
  Widget _buildSection(PolicySection section) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            section.heading,
            style: AppTextStyles.titleSemiBold16.copyWith(
              color: AppColors.textColor1,
            ),
          ),
          AppSpacing.verticalSpaceSM,
          // 섹션 내용
          Text(
            section.content,
            style: AppTextStyles.bodyRegular14.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// 오류 표시 (심플 버전)
class _PolicyErrorView extends StatelessWidget {
  const _PolicyErrorView({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 에러 메시지
            Text(
              '약관을 불러오지 못했습니다',
              style: AppTextStyles.titleSemiBold16.copyWith(
                color: AppColors.textColor1,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceSM,
            Text(
              error is PolicyLoadException
                  ? (error as PolicyLoadException).message
                  : '네트워크 연결을 확인해 주세요',
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.subColor2,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.verticalSpaceLG,
            // 다시 시도 버튼 (심플)
            TextButton(
              onPressed: onRetry,
              child: Text(
                '다시 시도',
                style: AppTextStyles.bodyMedium14.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
