import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../features/home/data/models/sns_content_model.dart';
import '../../../l10n/app_localizations.dart';
import '../common/platform_icon.dart';

/// SNS 콘텐츠 카드 위젯
class SnsContentCard extends StatelessWidget {
  final SnsContent content;
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? margin;
  final bool isGridLayout;

  const SnsContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.width,
    this.margin,
    this.isGridLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => debugPrint('SNS 콘텐츠 클릭: ${content.contentUrl}'),
      child: Container(
        width: isGridLayout ? null : (width ?? 120.w),
        height: isGridLayout ? 250.h : 170.h,
        margin: margin ?? EdgeInsets.only(right: 12.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero 위젯으로 이미지 감싸기
              // tag는 콘텐츠의 고유 ID를 사용하여 화면 간 연결
              Hero(
                tag: 'sns_content_${content.id}',
                child: CachedNetworkImage(
                  imageUrl: content.thumbnailUrl,
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
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48.w,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),

              // 그라데이션 오버레이 및 텍스트 정보
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                    stops: [0.5, 1.0],
                  ),
                ),
                padding: EdgeInsets.all(8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlatformIcon(
                      source: content.source,
                      size: isGridLayout ? 18.w : 24.w,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      content.title,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3.0,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ],
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
}

/// SNS 콘텐츠 가로 스크롤 리스트 위젯
///
/// 여러 SNS 콘텐츠를 가로로 스크롤 가능한 리스트로 표시
class SnsContentHorizontalList extends StatelessWidget {
  /// 표시할 SNS 콘텐츠 리스트
  final List<SnsContent> contents;

  /// 섹션 제목
  final String? title;

  /// 더보기 버튼 탭 시 콜백
  final VoidCallback? onSeeMoreTap;

  /// 개별 콘텐츠 카드 탭 시 콜백 (콘텐츠와 인덱스를 전달)
  final void Function(SnsContent content, int index)? onContentTap;

  const SnsContentHorizontalList({
    super.key,
    required this.contents,
    this.title,
    this.onSeeMoreTap,
    this.onContentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) _buildSectionHeader(context),
        SizedBox(height: 16.h),
        SizedBox(
          height: 170.h, // 썸네일 높이만 (제목과 크리에이터 정보는 이미지 내부에 오버레이)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return SnsContentCard(
                content: contents[index],
                onTap: onContentTap != null
                    ? () => onContentTap!(contents[index], index)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  /// 섹션 헤더 위젯 빌드
  Widget _buildSectionHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context);

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
                    l10n.seeMore,
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
