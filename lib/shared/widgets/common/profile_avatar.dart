import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/theme/app_colors.dart';

/// 프로필 아바타 크기 Enum
///
/// 다양한 상황에 맞는 프로필 사진 크기를 제공합니다.
enum ProfileAvatarSize {
  /// 작은 사이즈 (32dp)
  ///
  /// **사용 위치**: 댓글, 채팅 리스트
  small(32),

  /// 중간 사이즈 (56dp)
  ///
  /// **사용 위치**: 앱바, 네비게이션 헤더
  medium(56),

  /// 큰 사이즈 (80dp)
  ///
  /// **사용 위치**: 프로필 헤더
  large(80),

  /// 매우 큰 사이즈 (120dp)
  ///
  /// **사용 위치**: 프로필 수정 화면
  xLarge(120);

  const ProfileAvatarSize(this.value);

  /// 크기 값 (dp)
  final double value;
}

/// 프로필 아바타 위젯
///
/// **기능**:
/// - CachedNetworkImage로 이미지 캐싱 (네트워크 효율성)
/// - Shimmer 로딩 효과
/// - 기본 아이콘 fallback
/// - 다양한 크기 지원 (small, medium, large, xLarge)
/// - 테두리 옵션
/// - 탭 이벤트 지원
///
/// **사용 예시**:
/// ```dart
/// // 기본 사용
/// ProfileAvatar(
///   imageUrl: user.profileImageUrl,
///   size: ProfileAvatarSize.large,
/// )
///
/// // 테두리 + 탭 이벤트
/// ProfileAvatar(
///   imageUrl: user.profileImageUrl,
///   size: ProfileAvatarSize.medium,
///   showBorder: true,
///   onTap: () => context.push('/profile/edit'),
/// )
/// ```
class ProfileAvatar extends StatelessWidget {
  /// 프로필 이미지 URL
  ///
  /// null이면 기본 아이콘 표시
  final String? imageUrl;

  /// 아바타 크기
  final ProfileAvatarSize size;

  /// 테두리 표시 여부
  ///
  /// true이면 흰색 테두리 추가 (두께: 2dp)
  final bool showBorder;

  /// 탭 이벤트 콜백
  ///
  /// null이면 탭 불가
  final VoidCallback? onTap;

  /// 배경색 (기본 아이콘 사용 시)
  ///
  /// null이면 회색 배경
  final Color? backgroundColor;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = ProfileAvatarSize.medium,
    this.showBorder = false,
    this.onTap,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: size.value.w,
      height: size.value.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // 테두리 설정
        border: showBorder ? Border.all(color: Colors.white, width: 2.w) : null,
        // 그림자 효과 (테두리 있을 때만)
        boxShadow: showBorder
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : null,
      ),
      child: ClipOval(child: _buildContent()),
    );

    // 탭 이벤트가 있으면 GestureDetector로 감싸기
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }

    return widget;
  }

  /// 아바타 내용 빌드
  ///
  /// - imageUrl이 있으면: CachedNetworkImage
  /// - imageUrl이 없으면: 기본 아이콘
  Widget _buildContent() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        // 로딩 중: Shimmer 효과
        placeholder: (context, url) => _buildShimmerPlaceholder(),
        // 에러 발생: 기본 아이콘
        errorWidget: (context, url, error) => _buildDefaultIcon(),
      );
    } else {
      return _buildDefaultIcon();
    }
  }

  /// Shimmer 로딩 플레이스홀더
  ///
  /// 이미지 로딩 중에 표시되는 스켈레톤 효과
  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: size.value.w,
        height: size.value.h,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// 기본 아이콘 (이미지 없을 때)
  ///
  /// 회색 배경 + 사람 아이콘
  Widget _buildDefaultIcon() {
    return Container(
      width: size.value.w,
      height: size.value.h,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: size.value * 0.5,
        color: Colors.grey[400],
      ),
    );
  }
}

/// 프로필 아바타 with 뱃지
///
/// 아바타 우측 하단에 뱃지를 표시합니다.
///
/// **사용 예시**:
/// ```dart
/// ProfileAvatarWithBadge(
///   imageUrl: user.profileImageUrl,
///   size: ProfileAvatarSize.medium,
///   badgeIcon: Icons.verified,
///   badgeColor: Colors.blue,
/// )
/// ```
class ProfileAvatarWithBadge extends StatelessWidget {
  /// 프로필 이미지 URL
  final String? imageUrl;

  /// 아바타 크기
  final ProfileAvatarSize size;

  /// 테두리 표시 여부
  final bool showBorder;

  /// 탭 이벤트 콜백
  final VoidCallback? onTap;

  /// 뱃지 아이콘
  final IconData badgeIcon;

  /// 뱃지 배경색
  final Color badgeColor;

  const ProfileAvatarWithBadge({
    super.key,
    this.imageUrl,
    this.size = ProfileAvatarSize.medium,
    this.showBorder = false,
    this.onTap,
    required this.badgeIcon,
    this.badgeColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 프로필 아바타
        ProfileAvatar(
          imageUrl: imageUrl,
          size: size,
          showBorder: showBorder,
          onTap: onTap,
        ),

        // 뱃지 (우측 하단)
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: size.value * 0.3,
            height: size.value * 0.3,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
            ),
            child: Icon(badgeIcon, size: size.value * 0.2, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// 프로필 아바타 with 편집 버튼
///
/// 프로필 수정 화면에서 사용합니다.
///
/// **사용 예시**:
/// ```dart
/// ProfileAvatarWithEdit(
///   imageUrl: user.profileImageUrl,
///   size: ProfileAvatarSize.xLarge,
///   onEditPressed: () async {
///     // 이미지 선택 로직
///     final image = await ImagePicker().pickImage(source: ImageSource.gallery);
///     // ...
///   },
/// )
/// ```
class ProfileAvatarWithEdit extends StatelessWidget {
  /// 프로필 이미지 URL
  final String? imageUrl;

  /// 아바타 크기
  final ProfileAvatarSize size;

  /// 편집 버튼 클릭 콜백
  final VoidCallback onEditPressed;

  const ProfileAvatarWithEdit({
    super.key,
    this.imageUrl,
    this.size = ProfileAvatarSize.xLarge,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 프로필 아바타
        ProfileAvatar(imageUrl: imageUrl, size: size, showBorder: true),

        // 편집 버튼 (우측 하단)
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditPressed,
            child: Container(
              width: size.value * 0.3,
              height: size.value * 0.3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                size: size.value * 0.18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
