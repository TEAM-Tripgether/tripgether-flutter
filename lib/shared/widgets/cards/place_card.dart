import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/home/data/models/place_model.dart';
import '../../../l10n/app_localizations.dart';

/// 그리드 레이아웃용 장소 카드 위젯
///
/// SNS 콘텐츠처럼 썸네일 이미지 중심의 컴팩트한 디자인
/// Hero 애니메이션을 지원하여 상세 화면으로 부드러운 전환 제공
class PlaceGridCard extends StatelessWidget {
  /// 표시할 장소 정보
  final SavedPlace place;

  /// 카드 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 그리드에서의 마진 설정
  final EdgeInsets? margin;

  const PlaceGridCard({
    super.key,
    required this.place,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => debugPrint('장소 카드 클릭: ${place.name}'),
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: AppRadius.allLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: AppRadius.allLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero 애니메이션이 적용된 썸네일 이미지
              _buildHeroThumbnail(),

              // 장소 정보 영역
              _buildPlaceInfo(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Hero 애니메이션이 적용된 썸네일 이미지
  /// place.id를 tag로 사용하여 상세 화면과 연결
  Widget _buildHeroThumbnail() {
    // 첫 번째 이미지를 썸네일로 사용
    final thumbnailUrl = place.imageUrls.isNotEmpty
        ? place.imageUrls[0]
        : 'https://picsum.photos/300/200?random=${place.id}';

    return Expanded(
      child: Hero(
        tag: 'place_${place.id}',
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported,
                  size: AppSizes.iconXLarge,
                  color: Colors.grey[400],
                ),
                SizedBox(height: AppSpacing.sm.h),
                Text(
                  '이미지 없음',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 12.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 장소 정보 영역 (이름, 카테고리, 평점)
  Widget _buildPlaceInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리와 이름
          Row(
            children: [
              Text(place.category.emoji, style: textTheme.titleSmall),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  place.name,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),

          // 카테고리 및 거리
          Row(
            children: [
              Text(
                place.category.displayName,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Icon(
                Icons.location_on,
                size: AppSizes.iconSmall,
                color: Colors.grey[500],
              ),
              AppSpacing.horizontalSpaceXS,
              Text(
                place.distanceText,
                style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),

          // 평점 표시
          if (place.rating != null) ...[
            SizedBox(height: AppSpacing.xs.h),
            Row(
              children: [
                Icon(Icons.star, size: AppSizes.iconSmall, color: Colors.amber),
                AppSpacing.horizontalSpaceXS,
                Text(
                  place.rating!.toStringAsFixed(1),
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (place.reviewCount != null)
                  Text(
                    ' (${place.reviewCount})',
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// 저장된 장소 카드 위젯
///
/// 사용자가 저장한 장소를 카드 형태로 표시
/// 장소명, 카테고리, 주소, 이미지 미리보기 포함
class PlaceCard extends StatelessWidget {
  /// 표시할 장소 정보
  final SavedPlace place;

  /// 카드 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 이미지 탭 시 실행될 콜백
  final Function(int imageIndex)? onImageTap;

  const PlaceCard({
    super.key,
    required this.place,
    this.onTap,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            debugPrint('장소 카드 클릭: ${place.name}');
          },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.allLarge,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 정보 영역 (장소명, 카테고리, 주소)
            _buildPlaceInfo(context),

            // 구분선
            Container(height: 1, color: Colors.grey[200]),

            // 이미지 미리보기 영역
            _buildImagePreview(),
          ],
        ),
      ),
    );
  }

  /// 장소 정보 영역 빌드
  Widget _buildPlaceInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 장소명과 카테고리
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 카테고리 이모지
              Text(place.category.emoji, style: textTheme.titleMedium),
              SizedBox(width: AppSpacing.xs),
              // 장소명
              Expanded(
                child: Text(
                  place.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),

          // 카테고리 및 업종
          Text(
            place.category.displayName,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: AppSpacing.xs.h),

          // 주소
          Text(
            place.address,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppSpacing.sm.h),

          // 추가 정보 (평점, 리뷰, 거리)
          _buildAdditionalInfo(),
        ],
      ),
    );
  }

  /// 추가 정보 위젯 (평점, 리뷰, 거리 등)
  Widget _buildAdditionalInfo() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        final textTheme = Theme.of(context).textTheme;

        return Row(
          children: [
            // 평점
            if (place.rating != null) ...[
              Icon(Icons.star, size: AppSizes.iconSmall.w, color: Colors.amber),
              AppSpacing.horizontalSpaceXS,
              Text(
                place.rating!.toStringAsFixed(1),
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (place.reviewCount != null) ...[
                Text(
                  ' (${place.reviewCount})',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
              SizedBox(width: AppSpacing.md),
            ],

            // 거리
            Icon(
              Icons.location_on,
              size: AppSizes.iconSmall.w,
              color: Colors.grey[500],
            ),
            AppSpacing.horizontalSpaceXS,
            Text(
              place.distanceText,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),

            // 방문 여부 표시
            if (place.isVisited) ...[
              SizedBox(width: AppSpacing.md),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs,
                  vertical: AppSpacing.xs.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: AppRadius.allSmall,
                  border: Border.all(color: Colors.green[200]!, width: 0.5),
                ),
                child: Text(
                  l10n.placeVisited,
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  /// 이미지 미리보기 영역 빌드
  Widget _buildImagePreview() {
    if (place.imageUrls.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      height: 112.h, // 100h 이미지 + 12h 패딩
      padding: EdgeInsets.all(AppSpacing.md),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: place.imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (onImageTap != null) {
                onImageTap!(index);
              } else {
                debugPrint('이미지 클릭: ${place.name} - 이미지 $index');
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: AppSpacing.sm),
              child: ClipRRect(
                borderRadius: AppRadius.allMedium,
                child: CachedNetworkImage(
                  imageUrl: place.imageUrls[index],
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey[400]!,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: AppSizes.iconDefault,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 저장된 장소 리스트 위젯
///
/// 여러 장소를 세로 스크롤 가능한 리스트로 표시
class PlaceListSection extends StatelessWidget {
  /// 표시할 장소 리스트
  final List<SavedPlace> places;

  /// 섹션 제목
  final String? title;

  /// 더보기 버튼 탭 시 콜백
  final VoidCallback? onSeeMoreTap;

  /// 개별 장소 카드 탭 시 콜백
  final void Function(SavedPlace place)? onPlaceTap;

  /// 최대 표시 개수 (null이면 전체 표시)
  final int? maxItems;

  const PlaceListSection({
    super.key,
    required this.places,
    this.title,
    this.onSeeMoreTap,
    this.onPlaceTap,
    this.maxItems,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayPlaces = maxItems != null && places.length > maxItems!
        ? places.take(maxItems!).toList()
        : places;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        if (title != null) _buildSectionHeader(context),

        // 장소 리스트 또는 빈 상태 메시지
        if (places.isEmpty)
          // 저장한 장소가 없을 때 빈 상태 메시지 표시
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.huge.h,
            ),
            child: Center(
              child: Text(
                l10n.noSavedPlacesYet,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        else
          // 장소 리스트 표시
          ...displayPlaces.map(
            (place) => PlaceCard(
              place: place,
              onTap: onPlaceTap != null
                  ? () => onPlaceTap!(place)
                  : () {
                      // 기본 동작: 디버그 출력
                      debugPrint('장소 선택: ${place.name}');
                    },
              onImageTap: (index) {
                // 이미지 상세 보기 또는 지도 화면으로 이동
                debugPrint('이미지 선택: ${place.name} - 이미지 $index');
              },
            ),
          ),

        // 더보기 버튼
        if (maxItems != null &&
            places.length > maxItems! &&
            onSeeMoreTap != null)
          _buildSeeMoreButton(context),
      ],
    );
  }

  /// 섹션 헤더 위젯 빌드
  Widget _buildSectionHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
      ).copyWith(top: AppSpacing.lg.h, bottom: AppSpacing.sm.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (onSeeMoreTap != null)
            GestureDetector(
              onTap: onSeeMoreTap,
              child: Row(
                children: [
                  Text(
                    l10n.seeMore,
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                  AppSpacing.horizontalSpaceXS,
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppSizes.iconSmall,
                    color: primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// 더보기 버튼 위젯 빌드
  Widget _buildSeeMoreButton(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: onSeeMoreTap,
      child: Container(
        margin: EdgeInsets.all(AppSpacing.lg),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.md.h),
        decoration: BoxDecoration(
          border: Border.all(color: primaryColor, width: 1),
          borderRadius: AppRadius.allMedium,
        ),
        child: Center(
          child: Text(
            l10n.seeMorePlaces,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
