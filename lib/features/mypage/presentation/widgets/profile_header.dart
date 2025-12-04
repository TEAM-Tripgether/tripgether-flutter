import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/core/router/routes.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/shared/widgets/common/profile_avatar.dart';

/// 프로필 헤더 위젯 (새 디자인)
///
/// **역할**:
/// - 사용자 프로필 정보를 가로로 표시 (아바타 + "닉네임 님" + 화살표)
/// - 터치 시 프로필 수정 화면으로 이동 (로그아웃은 그 화면에서 가능)
/// - 로그인 상태에 따른 UI 분기 (로그인 / 미로그인)
/// - 로딩 상태 표시 (Shimmer 효과)
///
/// **디자인 스펙**:
/// - 배경: backgroundLight (#F8F8F8)
/// - 모서리: radius 8
/// - 텍스트: textColor1 (#130537), bodyMedium16
///
/// **사용 위치**: MyPageScreen 최상단
class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UserNotifier에서 사용자 정보 가져오기
    final userAsync = ref.watch(userNotifierProvider);

    return userAsync.when(
      // 로딩 중: Shimmer 스켈레톤 표시
      loading: () => _buildLoading(),

      // 에러 발생: 에러 메시지 표시
      error: (error, stack) => _buildError(context, error),

      // 데이터 로드 완료
      data: (user) {
        if (user == null) {
          // 로그인하지 않은 상태
          return _buildNotLoggedIn(context);
        } else {
          // 로그인된 상태: 프로필 정보 표시
          return _buildProfile(context, user);
        }
      },
    );
  }

  /// 프로필 정보 표시 (로그인 상태) - 새 디자인
  ///
  /// **구성**:
  /// - 흰색 배경 위에 가로 배치: [아바타] [닉네임 님] [>]
  /// - 전체 영역 터치 시 프로필 수정 화면으로 이동
  Widget _buildProfile(BuildContext context, User user) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // 프로필 수정 화면으로 이동 (로그아웃도 여기서 가능)
          context.push(AppRoutes.profileEdit);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              // 프로필 아바타 (medium: 48dp)
              ProfileAvatar(
                imageUrl: user.profileImageUrl,
                size: ProfileAvatarSize.large,
                showBorder: false,
              ),

              AppSpacing.horizontalSpaceMD,

              // 닉네임 + "님"
              Expanded(
                child: Text(
                  '${user.nickname} 님',
                  style: AppTextStyles.bodyMedium16.copyWith(
                    color: AppColors.textColor1,
                  ),
                ),
              ),

              // 오른쪽 화살표
              Icon(
                Icons.chevron_right,
                color: AppColors.subColor2,
                size: AppSizes.iconDefault,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 미로그인 상태 UI
  ///
  /// **구성**:
  /// - 흰색 배경 위에 가로 배치: [기본 아이콘] [로그인이 필요합니다] [>]
  /// - 터치 시 로그인 화면으로 이동
  Widget _buildNotLoggedIn(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(AppRoutes.login);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              // 기본 아바타
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.subColor2.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  size: AppSizes.iconDefault,
                  color: AppColors.subColor2,
                ),
              ),

              AppSpacing.horizontalSpaceMD,

              // 로그인 안내 메시지
              Expanded(
                child: Text(
                  l10n.profileLoginRequired,
                  style: AppTextStyles.bodyMedium16.copyWith(
                    color: AppColors.textColor1,
                  ),
                ),
              ),

              // 오른쪽 화살표
              Icon(
                Icons.chevron_right,
                color: AppColors.subColor2,
                size: AppSizes.iconDefault,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 로딩 중 UI (Shimmer)
  ///
  /// **구성**: 흰색 배경 위에 가로 배치 스켈레톤
  Widget _buildLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.subColor2.withValues(alpha: 0.3),
        highlightColor: AppColors.shimmerHighlight,
        child: Row(
          children: [
            // 아바타 스켈레톤
            Container(
              width: 48.w,
              height: 48.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            AppSpacing.horizontalSpaceMD,

            // 텍스트 스켈레톤
            Expanded(
              child: Container(
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),

            SizedBox(width: 24.w),
          ],
        ),
      ),
    );
  }

  /// 에러 상태 UI
  Widget _buildError(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconDefault,
            color: AppColors.redAccent,
          ),

          AppSpacing.horizontalSpaceMD,

          Expanded(
            child: Text(
              l10n.profileLoadError,
              style: AppTextStyles.bodyMedium16.copyWith(
                color: AppColors.textColor1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
