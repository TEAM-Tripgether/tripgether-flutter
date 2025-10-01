import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../features/home/data/models/place_model.dart';

/// 정사각형 스타일의 장소 카드 위젯 (홈 화면용)
///
/// 대표 이미지와 기본 정보만 표시하는 컴팩트한 카드
class PlaceCardCompact extends StatelessWidget {
  /// 표시할 장소 정보
  final SavedPlace place;

  /// 카드 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 카드 너비 (기본값: 160.w)
  final double? width;

  const PlaceCardCompact({
    super.key,
    required this.place,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            debugPrint('장소 카드 클릭: ${place.name}');
          },
      child: Container(
        width: width ?? 160.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // 대표 이미지 (정사각형)
            _buildMainImage(),

            // 장소 정보
            _buildPlaceInfo(context),
          ],
        ),
      ),
    );
  }

  /// 대표 이미지 빌드 (정사각형)
  Widget _buildMainImage() {
    final imageUrl =
        place.imageUrls.isNotEmpty ? place.imageUrls.first : null;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          child: imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: width ?? 160.w,
                  height: 160.h, // 정사각형
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: width ?? 160.w,
                    height: 160.h,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: width ?? 160.w,
                    height: 160.h,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      size: 32.w,
                      color: Colors.grey[400],
                    ),
                  ),
                )
              : Container(
                  width: width ?? 160.w,
                  height: 160.h,
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.place,
                    size: 48.w,
                    color: Colors.grey[400],
                  ),
                ),
        ),

        // 방문 완료 뱃지
        if (place.isVisited)
          Positioned(
            top: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.green[500],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '방문완료',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

        // 즐겨찾기 아이콘
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              place.isFavorite ? Icons.bookmark : Icons.bookmark_border,
              size: 20.w,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// 장소 정보 빌드
  Widget _buildPlaceInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리
          Row(
            children: [
              Text(
                place.category.emoji,
                style: TextStyle(fontSize: 14.sp),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  place.category.displayName,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 6.h),

          // 장소명
          Text(
            place.name,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6.h),

          // 평점 및 거리
          Row(
            children: [
              if (place.rating != null) ...[
                Icon(Icons.star, size: 12.w, color: Colors.amber),
                SizedBox(width: 2.w),
                Text(
                  place.rating!.toStringAsFixed(1),
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Icon(Icons.location_on, size: 12.w, color: Colors.grey[500]),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  place.distanceText,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 정사각형 장소 카드 가로 스크롤 리스트
class PlaceHorizontalList extends StatelessWidget {
  /// 표시할 장소 리스트
  final List<SavedPlace> places;

  /// 섹션 제목
  final String? title;

  /// 더보기 버튼 탭 시 콜백
  final VoidCallback? onSeeMoreTap;

  const PlaceHorizontalList({
    super.key,
    required this.places,
    this.title,
    this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        if (title != null) _buildSectionHeader(context),

        SizedBox(height: 12.h),

        // 장소 리스트 (가로 스크롤)
        SizedBox(
          height: 260.h, // 이미지(160) + 정보 영역(~100)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: places.length,
            itemBuilder: (context, index) {
              return PlaceCardCompact(
                place: places[index],
                onTap: () {
                  debugPrint('장소 선택: ${places[index].name}');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// 섹션 헤더 위젯 빌드
  Widget _buildSectionHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          if (onSeeMoreTap != null)
            GestureDetector(
              onTap: onSeeMoreTap,
              child: Row(
                children: [
                  Text(
                    '더보기',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12.w,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
