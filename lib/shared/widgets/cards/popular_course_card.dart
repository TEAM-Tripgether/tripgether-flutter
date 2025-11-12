import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';

/// 실시간 인기 코스 카드 위젯
///
/// **디자인 스펙:**
/// - 크기: 158w x 264h (고정 비율)
/// - 용도: 실시간 인기 코스 섹션 전용
/// - 구성: 배경 이미지 + 그라데이션 오버레이 + 설명 + 제목
/// - 텍스트: 하단 정렬, 흰색 (그라데이션 배경 위)
///
/// **사용 예시:**
/// ```dart
/// PopularCourseCard(
///   imageUrl: 'https://example.com/image.jpg',
///   title: '익선동 골목 데이트 산책코스',
///   description: '비 오는 날이 설렘 추억 하나로 충분한',
///   onTap: () => context.push('/course/123'),
/// )
/// ```
class PopularCourseCard extends StatelessWidget {
  /// 코스 대표 이미지 URL
  final String imageUrl;

  /// 코스 제목 (필수)
  ///
  /// 예: "익선동 골목 데이트 산책코스"
  final String title;

  /// 코스 설명 (캐치프레이즈)
  ///
  /// 예: "비 오는 날이 설렘 추억 하나로 충분한"
  final String? description;

  /// 카드 탭 콜백
  final VoidCallback? onTap;

  const PopularCourseCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 158.w, // 고정 너비 (디자인 스펙)
        height: 264.h, // 고정 높이 (디자인 스펙)
        decoration: BoxDecoration(
          borderRadius: AppRadius.allMedium,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.allMedium,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 배경 이미지
              _buildImage(),

              // 그라데이션 오버레이 (하단으로 갈수록 어두워짐)
              _buildGradientOverlay(),

              // 텍스트 콘텐츠 (하단 정렬)
              Positioned(
                left: AppSpacing.sm,
                right: AppSpacing.sm,
                bottom: AppSpacing.sm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 설명 텍스트 (작은 글씨)
                    if (description != null && description!.isNotEmpty) ...[
                      Text(
                        description!,
                        style: AppTextStyles.metaMedium12.copyWith(
                          color: AppColors.white,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppSpacing.xs),
                    ],

                    // 제목 텍스트 (큰 글씨, 볼드)
                    Text(
                      title,
                      style: AppTextStyles.greetingBold20.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 이미지 위젯 (CachedNetworkImage + Shimmer)
  Widget _buildImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Container(color: AppColors.surface),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.surfaceVariant,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textSecondary,
            size: 32.w,
          ),
        ),
      ),
    );
  }

  /// 그라데이션 오버레이
  ///
  /// 하단으로 갈수록 어두워져서 텍스트 가독성 확보
  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
            Colors.black.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}

/// 실시간 인기 코스 카드 스켈레톤 로딩 위젯
///
/// PopularCourseCard의 로딩 상태를 표시합니다.
class PopularCourseCardSkeleton extends StatelessWidget {
  const PopularCourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: 158.w,
        height: 264.h,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.allMedium,
        ),
      ),
    );
  }
}
