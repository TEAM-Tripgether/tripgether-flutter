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

/// 프로필 헤더 위젯
///
/// **역할**:
/// - 사용자 프로필 정보 표시 (프로필 사진, 닉네임, 이메일)
/// - 로그인 상태에 따른 UI 분기 (로그인 / 미로그인)
/// - 로딩 상태 표시 (Shimmer 효과)
///
/// **사용 위치**: MyPageScreen 최상단
///
/// **데이터 소스**: UserNotifier (Riverpod)
///
/// **사용 예시**:
/// ```dart
/// ListView(
///   children: [
///     ProfileHeader(),  // ← 마이페이지 최상단
///     SizedBox(height: 16.h),
///     // ... 기타 컨텐츠
///   ],
/// )
/// ```
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

  /// 프로필 정보 표시 (로그인 상태)
  ///
  /// **구성**:
  /// - 프로필 사진 (ProfileAvatar)
  /// - 닉네임 (titleLarge, 굵은 폰트)
  /// - 이메일 (bodyMedium, 보조 색상)
  Widget _buildProfile(BuildContext context, User user) {
    return Card(
      margin: AppSpacing.cardPadding,
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          children: [
            // 프로필 사진 (xLarge: 120dp - 프로필 페이지에서 더 눈에 띄게)
            ProfileAvatar(
              imageUrl: user.profileImageUrl,
              size: ProfileAvatarSize.xLarge,
              showBorder: true,
            ),

            AppSpacing.verticalSpaceLG,

            // 닉네임 (titleLarge: 20px, 세미볼드)
            Text(
              user.nickname,
              style: AppTextStyles.greetingBold20.copyWith(
                color: AppColors.textColor1,
              ),
            ),

            AppSpacing.verticalSpaceXS,

            // 이메일 (bodyMedium: 14px, 레귤러)
            Text(
              user.email,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.7),
              ),
            ),

            AppSpacing.verticalSpaceMD,

            // 로그인 플랫폼 뱃지 (선택 사항)
            if (user.loginPlatform != null)
              _buildLoginPlatformBadge(context, user.loginPlatform!),
          ],
        ),
      ),
    );
  }

  /// 로그인 플랫폼 뱃지
  ///
  /// Google, Kakao 등의 로그인 플랫폼을 표시 (AppColorPalette 활용)
  Widget _buildLoginPlatformBadge(BuildContext context, String platform) {
    final l10n = AppLocalizations.of(context);

    // 플랫폼별 색상 (AppColorPalette 사용)
    Color badgeColor;
    IconData icon;

    switch (platform.toUpperCase()) {
      case 'GOOGLE':
        badgeColor = AppColorPalette.googleButton;
        icon = Icons.g_mobiledata;
        break;
      case 'KAKAO':
        badgeColor = AppColorPalette.kakaoButton;
        icon = Icons.chat_bubble;
        break;
      default:
        badgeColor = AppColors.mainColor;
        icon = Icons.person;
    }

    return Container(
      padding: AppSpacing.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.w, color: badgeColor),
          AppSpacing.horizontalSpaceXS,
          Text(
            l10n.accountSuffix(platform),
            style: AppTextStyles.buttonMediumMedium14.copyWith(
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  /// 미로그인 상태 UI
  ///
  /// **구성**:
  /// - 기본 아이콘
  /// - "로그인이 필요합니다" 메시지
  /// - "로그인하러 가기" 버튼
  Widget _buildNotLoggedIn(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: AppSpacing.cardPadding,
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            // 기본 아이콘
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 40.w,
                color: Colors.grey[400],
              ),
            ),

            AppSpacing.verticalSpaceLG,

            // 안내 메시지
            Text(
              l10n.profileLoginRequired,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textColor1,
              ),
            ),

            AppSpacing.verticalSpaceSM,

            Text(
              l10n.profileLoginPrompt,
              style: AppTextStyles.bodyRegular14.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.verticalSpaceXXL,

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.login);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.mainColor,
                foregroundColor: AppColors.white,
                padding: AppSpacing.buttonPaddingLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                l10n.profileLoginButton,
                style: AppTextStyles.buttonSelectSemiBold16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 로딩 중 UI (Shimmer)
  ///
  /// **구성**:
  /// - 프로필 사진 스켈레톤 (원형)
  /// - 닉네임 스켈레톤 (긴 막대)
  /// - 이메일 스켈레톤 (짧은 막대)
  Widget _buildLoading() {
    return Card(
      margin: AppSpacing.cardPadding,
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Shimmer.fromColors(
          baseColor: AppColors.subColor2.withValues(alpha: 0.3),
          highlightColor: AppColors.shimmerHighlight,
          child: Column(
            children: [
              // 프로필 사진 스켈레톤 (xLarge: 120dp와 동일)
              Container(
                width: 120.w,
                height: 120.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),

              AppSpacing.verticalSpaceLG,

              // 닉네임 스켈레톤
              Container(
                width: 150.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),

              AppSpacing.verticalSpaceSM,

              // 이메일 스켈레톤
              Container(
                width: 200.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 에러 상태 UI
  ///
  /// **구성**:
  /// - 에러 아이콘
  /// - 에러 메시지
  Widget _buildError(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: AppSpacing.cardPadding,
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: AppSpacing.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48.w, color: Colors.red[300]),

            AppSpacing.verticalSpaceLG,

            Text(
              l10n.profileLoadError,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.textColor1,
              ),
            ),

            AppSpacing.verticalSpaceSM,

            Text(
              error.toString(),
              style: AppTextStyles.metaMedium12.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
