import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/buttons/common_button.dart';
import '../../data/models/place_model.dart';

/// 장소 상세 화면
///
/// 저장한 장소의 상세 정보를 카드 기반 레이아웃으로 표시
/// SNS 콘텐츠 상세와 차별화된 UI 구조
class PlaceDetailScreen extends StatelessWidget {
  /// 표시할 장소 정보
  final SavedPlace place;

  const PlaceDetailScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      // CommonAppBar 사용
      appBar: CommonAppBar.forSubPage(
        title: place.name,
        rightActions: [
          // 즐겨찾기 버튼
          IconButton(
            icon: Icon(
              place.isFavorite ? Icons.favorite : Icons.favorite_border,
              size: 24.w,
              color: place.isFavorite
                  ? colorScheme.error
                  : colorScheme.onSurfaceVariant,
            ),
            onPressed: () {
              // TODO: 즐겨찾기 토글
              debugPrint('즐겨찾기 버튼 클릭');
            },
          ),
          // 공유 버튼
          IconButton(
            icon: Icon(Icons.share_outlined, size: 24.w),
            onPressed: () {
              // TODO: 공유 기능
              debugPrint('공유 버튼 클릭');
            },
            tooltip: l10n.share,
          ),
          AppSpacing.horizontalSpaceSM,
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero 이미지 갤러리
            _buildHeroImageGallery(),

            AppSpacing.verticalSpaceLG,

            // 기본 정보 카드
            _buildBasicInfoCard(context, l10n),

            AppSpacing.verticalSpaceMD,

            // 상세 정보 카드
            _buildDetailInfoCard(context, l10n),

            AppSpacing.verticalSpaceMD,

            // 영업 정보 카드
            if (place.businessHours != null || place.phoneNumber != null)
              _buildBusinessInfoCard(context, l10n),

            AppSpacing.verticalSpaceMD,

            // 위치 정보 카드
            _buildLocationCard(context, l10n),

            AppSpacing.verticalSpaceXXXL,
          ],
        ),
      ),
      // 하단 액션 버튼
      bottomNavigationBar: _buildBottomActions(context, l10n),
    );
  }

  /// Hero 애니메이션이 적용된 이미지 갤러리
  Widget _buildHeroImageGallery() {
    if (place.imageUrls.isEmpty) {
      return SizedBox.shrink();
    }

    return SizedBox(
      height: 300.h,
      child: PageView.builder(
        itemCount: place.imageUrls.length,
        itemBuilder: (context, index) {
          // 첫 번째 이미지에만 Hero 애니메이션 적용
          if (index == 0) {
            return Hero(
              tag: 'place_${place.id}',
              child: CachedNetworkImage(
                imageUrl: place.imageUrls[index],
                width: double.infinity,
                height: 300.h,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  final theme = Theme.of(context);
                  return Container(
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  final colorScheme = Theme.of(context).colorScheme;
                  return Container(
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64.w,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            );
          }

          // 나머지 이미지는 일반 이미지
          return CachedNetworkImage(
            imageUrl: place.imageUrls[index],
            width: double.infinity,
            height: 300.h,
            fit: BoxFit.cover,
            placeholder: (context, url) {
              final theme = Theme.of(context);
              return Container(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.primaryColor,
                    ),
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              final colorScheme = Theme.of(context).colorScheme;
              return Container(
                color: colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.image_not_supported,
                  size: 64.w,
                  color: colorScheme.onSurfaceVariant,
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 기본 정보 카드 (이름, 카테고리, 평점)
  Widget _buildBasicInfoCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: AppSpacing.symmetric(horizontal: 16),
      padding: AppSpacing.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리와 방문 여부
          Row(
            children: [
              Container(
                padding: AppSpacing.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(place.category.emoji, style: AppTextStyles.labelLarge),
                    AppSpacing.horizontalSpaceXS,
                    Text(
                      place.category.displayName,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.horizontalSpaceSM,
              if (place.isVisited)
                Container(
                  padding: AppSpacing.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.green[200]!, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14.w,
                        color: Colors.green[700],
                      ),
                      AppSpacing.horizontalSpaceXS,
                      Text(
                        l10n.placeVisited,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.green[700], // 의미론적 녹색 유지
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          AppSpacing.verticalSpaceLG,

          // 장소명
          Text(
            place.name,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),

          AppSpacing.verticalSpaceMD,

          // 평점 및 리뷰
          if (place.rating != null)
            Row(
              children: [
                ...List.generate(
                  5,
                  (index) => Icon(
                    index < place.rating!.floor()
                        ? Icons.star
                        : (index < place.rating!
                              ? Icons.star_half
                              : Icons.star_border),
                    size: 20.w,
                    color: Colors.amber,
                  ),
                ),
                AppSpacing.horizontalSpaceSM,
                Text(
                  place.rating!.toStringAsFixed(1),
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (place.reviewCount != null)
                  Text(
                    ' (${place.reviewCount}개 리뷰)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  /// 상세 정보 카드 (설명)
  Widget _buildDetailInfoCard(BuildContext context, AppLocalizations l10n) {
    if (place.description == null) return SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: AppSpacing.symmetric(horizontal: 16),
      padding: AppSpacing.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20.w, color: theme.primaryColor),
              AppSpacing.horizontalSpaceSM,
              Text(
                '장소 정보',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            place.description!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  /// 영업 정보 카드
  Widget _buildBusinessInfoCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: AppSpacing.symmetric(horizontal: 16),
      padding: AppSpacing.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 20.w, color: theme.primaryColor),
              AppSpacing.horizontalSpaceSM,
              Text(
                '영업 정보',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceLG,

          // 영업시간
          if (place.businessHours != null) ...[
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 18.w,
                  color: colorScheme.onSurfaceVariant,
                ),
                AppSpacing.horizontalSpaceMD,
                Text(
                  place.businessHours!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (place.phoneNumber != null) AppSpacing.verticalSpaceMD,
          ],

          // 전화번호
          if (place.phoneNumber != null)
            GestureDetector(
              onTap: () => _makePhoneCall(place.phoneNumber!),
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    size: 18.w,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  AppSpacing.horizontalSpaceMD,
                  Text(
                    place.phoneNumber!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: theme.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 위치 정보 카드
  Widget _buildLocationCard(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: AppSpacing.symmetric(horizontal: 16),
      padding: AppSpacing.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 20.w, color: theme.primaryColor),
              AppSpacing.horizontalSpaceSM,
              Text(
                '위치',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppSpacing.verticalSpaceMD,
          Text(
            place.address,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          if (place.detailAddress != null) ...[
            AppSpacing.verticalSpaceXS,
            Text(
              place.detailAddress!,
              style: AppTextStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          AppSpacing.verticalSpaceMD,
          Row(
            children: [
              Icon(
                Icons.directions,
                size: 16.w,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 6.w), // 6.w는 AppSpacing 표준값이 아니므로 유지
              Text(
                place.distanceText,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 하단 액션 버튼
  ///
  /// PrimaryButton과 SecondaryButton 컴포넌트를 사용하여
  /// 일관된 스타일과 간결한 코드 구조를 유지합니다.
  Widget _buildBottomActions(BuildContext context, AppLocalizations l10n) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: ButtonGroup(
        children: [
          PrimaryButton(
            text: '지도에서 보기',
            icon: Icons.map,
            onPressed: () {
              // TODO: 지도 탭으로 이동
              debugPrint('지도에서 보기 클릭');
            },
            isFullWidth: false, // ButtonGroup이 Expanded 처리
          ),
          SecondaryButton(
            text: '길찾기',
            icon: Icons.directions,
            onPressed: () {
              // TODO: 길찾기 (구글맵/애플맵)
              debugPrint('길찾기 클릭');
            },
            isFullWidth: false, // ButtonGroup이 Expanded 처리
          ),
        ],
      ),
    );
  }

  /// 전화 걸기
  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
