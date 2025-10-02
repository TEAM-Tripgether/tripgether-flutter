import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../features/home/data/models/sns_content_model.dart';
import '../../../l10n/app_localizations.dart';

/// SNS 콘텐츠 카드 위젯
///
/// YouTube, Instagram 등의 콘텐츠를 표시하는 카드
/// 썸네일, 제목, 출처 아이콘을 포함
class SnsContentCard extends StatelessWidget {
  /// 표시할 SNS 콘텐츠
  final SnsContent content;

  /// 카드 탭 시 실행될 콜백
  final VoidCallback? onTap;

  /// 카드 너비 (기본값: 160.w)
  final double? width;

  const SnsContentCard({
    super.key,
    required this.content,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            // 기본 동작: 콘텐츠 URL로 이동 (실제 구현 시 url_launcher 사용)
            debugPrint('SNS 콘텐츠 클릭: ${content.contentUrl}');
          },
      child: Container(
        width: width ?? 120.w, // 더 크게 확대 (짝수 유지)
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지
            _buildThumbnail(),

            SizedBox(height: 8.h),

            // 콘텐츠 제목
            _buildTitle(),

            SizedBox(height: 4.h),

            // 크리에이터 정보 및 조회수
            _buildCreatorInfo(),
          ],
        ),
      ),
    );
  }

  /// 썸네일 이미지 위젯 빌드
  Widget _buildThumbnail() {
    return Stack(
      children: [
        // 썸네일 이미지 - 릴스/쇼츠 스타일 (120w x 170h)
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedNetworkImage(
            imageUrl: content.thumbnailUrl,
            width: width ?? 120.w,
            height: 170.h, // 세로로 긴 형태로 복원
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: width ?? 120.w,
              height: 170.h,
              color: Colors.grey[200],
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[400]!),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              width: width ?? 120.w,
              height: 170.h, // 세로로 긴 형태로 복원
              color: Colors.grey[200],
              child: Icon(
                Icons.image_not_supported,
                size: 32.w,
                color: Colors.grey[400],
              ),
            ),
          ),
        ),

        // SNS 플랫폼 아이콘 (좌측 하단으로 변경)
        Positioned(bottom: 8.h, left: 8.w, child: _buildSourceIcon()),
      ],
    );
  }

  /// SNS 플랫폼 아이콘 빌드 (배경 제거, 아이콘만 표시)
  Widget _buildSourceIcon() {
    IconData icon;
    Color iconColor;

    switch (content.source) {
      case SnsSource.youtube:
        icon = Icons.play_circle_filled;
        iconColor = Colors.red;
        break;
      case SnsSource.instagram:
        icon = Icons.camera_alt;
        iconColor = Colors.purple;
        break;
      case SnsSource.tiktok:
        icon = Icons.music_note;
        iconColor = Colors.black;
        break;
    }

    return Icon(icon, size: 24.w, color: iconColor);
  }

  /// 콘텐츠 제목 위젯 빌드
  Widget _buildTitle() {
    return Text(
      content.title,
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        height: 1.3,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// 크리에이터 정보 위젯 빌드
  Widget _buildCreatorInfo() {
    return Row(
      children: [
        Expanded(
          child: Text(
            content.creatorName,
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
        SizedBox(width: 4.w),
        Text(
          _formatViewCount(content.viewCount),
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// 조회수 포맷팅 헬퍼 메서드
  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(0)}K';
    }
    return count.toString();
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
        // 섹션 헤더
        if (title != null) _buildSectionHeader(context),

        SizedBox(height: 30.h),

        // 콘텐츠 리스트 - 릴스/쇼츠 스타일 (120w x 170h)
        SizedBox(
          height:
              250.h, // 썸네일(170) + 간격(8) + 제목(~34) + 간격(4) + 정보(~18) + 여유공간(16)
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: contents.length,
            itemBuilder: (context, index) {
              return SnsContentCard(
                content: contents[index],
                onTap: onContentTap != null
                    ? () => onContentTap!(contents[index], index)
                    : () {
                        // 기본 동작: 디버그 출력
                        debugPrint('SNS 콘텐츠 선택: ${contents[index].title}');
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
