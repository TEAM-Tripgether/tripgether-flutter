import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
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
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero 이미지 갤러리
            _buildHeroImageGallery(),

            SizedBox(height: 16.h),

            // 기본 정보 카드
            _buildBasicInfoCard(context, l10n),

            SizedBox(height: 12.h),

            // 상세 정보 카드
            _buildDetailInfoCard(context, l10n),

            SizedBox(height: 12.h),

            // 영업 정보 카드
            if (place.businessHours != null || place.phoneNumber != null)
              _buildBusinessInfoCard(context, l10n),

            SizedBox(height: 12.h),

            // 위치 정보 카드
            _buildLocationCard(context, l10n),

            SizedBox(height: 32.h),
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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(place.category.emoji, style: textTheme.labelLarge),
                    SizedBox(width: 4.w),
                    Text(
                      place.category.displayName,
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              if (place.isVisited)
                Container(
                  padding: EdgeInsets.symmetric(
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
                      SizedBox(width: 4.w),
                      Text(
                        l10n.placeVisited,
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700], // 의미론적 녹색 유지
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 16.h),

          // 장소명
          Text(
            place.name,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),

          SizedBox(height: 12.h),

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
                SizedBox(width: 8.w),
                Text(
                  place.rating!.toStringAsFixed(1),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                if (place.reviewCount != null)
                  Text(
                    ' (${place.reviewCount}개 리뷰)',
                    style: textTheme.bodyMedium?.copyWith(
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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20.w, color: theme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                '장소 정보',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            place.description!,
            style: textTheme.bodyMedium?.copyWith(
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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 20.w, color: theme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                '영업 정보',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // 영업시간
          if (place.businessHours != null) ...[
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 18.w,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: 12.w),
                Text(
                  place.businessHours!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (place.phoneNumber != null) SizedBox(height: 12.h),
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
                  SizedBox(width: 12.w),
                  Text(
                    place.phoneNumber!,
                    style: textTheme.bodyMedium?.copyWith(
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
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 20.w, color: theme.primaryColor),
              SizedBox(width: 8.w),
              Text(
                '위치',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            place.address,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          if (place.detailAddress != null) ...[
            SizedBox(height: 4.h),
            Text(
              place.detailAddress!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(
                Icons.directions,
                size: 16.w,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 6.w),
              Text(
                place.distanceText,
                style: textTheme.bodySmall?.copyWith(
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
  Widget _buildBottomActions(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 지도에서 보기 버튼
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: 지도 탭으로 이동
                debugPrint('지도에서 보기 클릭');
              },
              icon: Icon(Icons.map, size: 20.w),
              label: Text(
                '지도에서 보기',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          // 길찾기 버튼
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: 길찾기 (구글맵/애플맵)
                debugPrint('길찾기 클릭');
              },
              icon: Icon(Icons.directions, size: 20.w),
              label: Text(
                '길찾기',
                style: textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: theme.primaryColor, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
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
