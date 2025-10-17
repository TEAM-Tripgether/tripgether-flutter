import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/constants/app_colors.dart';
import 'package:tripgether/features/auth/data/models/user_model.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';
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
      error: (error, stack) => _buildError(error),

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
  /// - 닉네임 (크고 굵은 폰트)
  /// - 이메일 (작고 회색)
  Widget _buildProfile(BuildContext context, User user) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // 프로필 사진
          ProfileAvatar(
            imageUrl: user.profileImageUrl,
            size: ProfileAvatarSize.large,
            showBorder: true,
          ),

          SizedBox(height: 16.h),

          // 닉네임
          Text(
            user.nickname,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 4.h),

          // 이메일
          Text(
            user.email,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),

          SizedBox(height: 12.h),

          // 로그인 플랫폼 뱃지 (선택 사항)
          if (user.loginPlatform != null) _buildLoginPlatformBadge(user.loginPlatform!),
        ],
      ),
    );
  }

  /// 로그인 플랫폼 뱃지
  ///
  /// Google, Kakao 등의 로그인 플랫폼을 표시
  Widget _buildLoginPlatformBadge(String platform) {
    // 플랫폼별 색상
    Color badgeColor;
    IconData icon;

    switch (platform.toUpperCase()) {
      case 'GOOGLE':
        badgeColor = const Color(0xFF4285F4);
        icon = Icons.g_mobiledata;
        break;
      case 'KAKAO':
        badgeColor = const Color(0xFFFEE500);
        icon = Icons.chat_bubble;
        break;
      default:
        badgeColor = AppColors.primary;
        icon = Icons.person;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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
          Icon(
            icon,
            size: 16.w,
            color: badgeColor,
          ),
          SizedBox(width: 4.w),
          Text(
            '$platform 계정',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
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

          SizedBox(height: 16.h),

          // 안내 메시지
          Text(
            '로그인이 필요합니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            '로그인하시면 더 많은 기능을 이용할 수 있습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

          // 로그인 버튼
          ElevatedButton(
            onPressed: () {
              // TODO: 로그인 화면으로 이동
              // context.push(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              '로그인하러 가기',
              style: TextStyle(
                fontFamily: 'Pretendard',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            // 프로필 사진 스켈레톤
            Container(
              width: 80.w,
              height: 80.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            SizedBox(height: 16.h),

            // 닉네임 스켈레톤
            Container(
              width: 150.w,
              height: 20.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),

            SizedBox(height: 8.h),

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
    );
  }

  /// 에러 상태 UI
  ///
  /// **구성**:
  /// - 에러 아이콘
  /// - 에러 메시지
  Widget _buildError(Object error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48.w,
            color: Colors.red[300],
          ),

          SizedBox(height: 16.h),

          Text(
            '프로필 정보를 불러올 수 없습니다',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),

          Text(
            error.toString(),
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
