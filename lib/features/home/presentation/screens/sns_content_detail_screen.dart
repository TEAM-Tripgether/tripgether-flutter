import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../shared/widgets/common/platform_icon.dart';
import '../../data/models/sns_content_model.dart';

/// SNS 콘텐츠 상세 화면
///
/// YouTube 동영상, Instagram 게시물 등의 상세 정보를 쇼츠/릴스 형식으로 표시하고
/// 가로 스와이프로 다른 콘텐츠를 탐색할 수 있습니다.
/// 외부 링크로 이동할 수 있는 기능을 제공합니다.
class SnsContentDetailScreen extends StatefulWidget {
  /// 표시할 SNS 콘텐츠 리스트
  final List<SnsContent> contents;

  /// 초기 표시할 콘텐츠 인덱스
  final int initialIndex;

  const SnsContentDetailScreen({
    super.key,
    required this.contents,
    required this.initialIndex,
  });

  @override
  State<SnsContentDetailScreen> createState() => _SnsContentDetailScreenState();
}

class _SnsContentDetailScreenState extends State<SnsContentDetailScreen> {
  /// PageView 컨트롤러
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // PageController 초기화 - 초기 페이지를 initialIndex로 설정
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      // CommonAppBar 추가 - 뒤로가기 버튼과 공유 기능
      appBar: CommonAppBar.forSubPage(
        title: l10n.snsContentDetail,
        rightActions: [
          // 공유 버튼
          IconButton(
            icon: Icon(Icons.share_outlined, size: 24.w),
            onPressed: () {
              // TODO: 공유 기능 구현
              debugPrint('공유 버튼 클릭');
            },
            tooltip: l10n.share,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      // PageView를 사용한 가로 스와이프 네비게이션
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.contents.length,
        itemBuilder: (context, index) {
          final content = widget.contents[index];
          // 각 페이지는 세로 스크롤 가능한 콘텐츠 상세 정보
          return _buildContentDetailPage(context, content, l10n);
        },
      ),
    );
  }

  /// 개별 콘텐츠 상세 페이지 구성
  Widget _buildContentDetailPage(
    BuildContext context,
    SnsContent content,
    AppLocalizations l10n,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          // 썸네일 이미지 또는 동영상 영역 (쇼츠 형식 - 세로로 긴 형태)
          _buildMediaSection(context, content),

          SizedBox(height: 16.h),

          // 콘텐츠 정보 영역
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 채널 정보 및 바로가기
                _buildChannelInfo(context, content, l10n),

                SizedBox(height: 16.h),

                // 제목
                _buildTitle(context, content),

                SizedBox(height: 12.h),

                // 카테고리 태그
                _buildCategoryTag(context, l10n),

                SizedBox(height: 16.h),

                // 설명 영역
                _buildDescription(context, l10n),

                SizedBox(height: 24.h),

                // 관련 장소 카드 섹션
                _buildRelatedPlaceSection(context),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 미디어 섹션 (쇼츠/릴스 형식 - 세로로 긴 형태)
  Widget _buildMediaSection(BuildContext context, SnsContent content) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 가로 폭을 더 줄여서 슬림한 쇼츠 형식으로 표시
    return Center(
      child: SizedBox(
        width: 280.w, // 가로 폭 제한 (더 슬림하게)
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              // Hero 위젯으로 썸네일 이미지 감싸기
              // SnsContentCard와 같은 tag를 사용하여 연결
              Hero(
                tag: 'sns_content_${content.id}',
                child: CachedNetworkImage(
                  imageUrl: content.thumbnailUrl,
                  width: 280.w,
                  height: 450.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 450.h,
                    color: colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 450.h,
                    color: colorScheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64.w,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),

              // 동영상 재생 아이콘 (YouTube/TikTok인 경우)
              if (content.type == ContentType.video ||
                  content.type == ContentType.shorts)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.scrim.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          size: 48.w,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 채널 정보 및 바로가기 링크
  Widget _buildChannelInfo(
    BuildContext context,
    SnsContent content,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // 플랫폼 아이콘
        _buildPlatformIcon(content),

        SizedBox(width: 8.w),

        // 채널명
        Text(
          content.creatorName,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),

        Spacer(),

        // 게시물 바로가기 링크 (외부 SNS로 이동)
        GestureDetector(
          onTap: () => _openExternalLink(context, content),
          child: Row(
            children: [
              Icon(
                Icons.open_in_new,
                size: 16.w,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 4.w),
              Text(
                l10n.goToOriginalPost,
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 플랫폼 아이콘 (YouTube, Instagram, TikTok)
  /// PlatformIcon 위젯을 사용하여 SVG 아이콘 표시 (배경 없이)
  Widget _buildPlatformIcon(SnsContent content) {
    return PlatformIcon(
      source: content.source,
      size: 24.w, // 배경이 없으니 아이콘 크기를 약간 키움
    );
  }

  /// 제목
  Widget _buildTitle(BuildContext context, SnsContent content) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Text(
      content.title,
      style: textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        height: 1.4,
      ),
    );
  }

  /// 카테고리 태그
  Widget _buildCategoryTag(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          Icons.label_outline,
          size: 16.w,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: 4.w),
        Text(
          l10n.aiContentSummary,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  /// 설명 영역 (긴 텍스트)
  Widget _buildDescription(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Text(
      _getDummyDescription(),
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
        height: 1.7,
      ),
    );
  }

  /// 관련 장소 카드 섹션
  Widget _buildRelatedPlaceSection(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    // 더미 장소 이미지 URL 목록 (실제로는 API에서 가져와야 함)
    final placeImages = [
      'https://picsum.photos/200/200?random=1',
      'https://picsum.photos/200/200?random=2',
      'https://picsum.photos/200/200?random=3',
      'https://picsum.photos/200/200?random=4',
      'https://picsum.photos/200/200?random=5',
      'https://picsum.photos/200/200?random=6',
    ];

    return Container(
      // 쉐도우가 있는 카드 컨테이너
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: Offset(0, 2.h),
            blurRadius: 12.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 섹션 제목
          Text(
            '토리토스시 토요히라점',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          // 위치 정보
          Text(
            '홋카이도 · 스시',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),

          SizedBox(height: 12.h),

          // 주소
          Text(
            '일본 〒062-0904 Hokkaido, Sapporo, Toyohira Ward, Toyohira 4 Jo, 6 Chome-1-10',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),

          SizedBox(height: 16.h),

          // 이미지 갤러리 (가로 스크롤) - 실제 이미지 사용
          SizedBox(
            height: 100.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: placeImages.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 100.w,
                  margin: EdgeInsets.only(right: 8.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: placeImages[index],
                      width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_not_supported,
                          size: 32.w,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 외부 링크 열기
  Future<void> _openExternalLink(
    BuildContext context,
    SnsContent content,
  ) async {
    final uri = Uri.parse(content.contentUrl);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          final textTheme = Theme.of(context).textTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context).cannotOpenLink,
                style: textTheme.bodyMedium,
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('링크 열기 실패: $e');
      if (context.mounted) {
        final textTheme = Theme.of(context).textTheme;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).linkOpenError,
              style: textTheme.bodyMedium,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// 더미 설명 텍스트 (실제로는 API에서 가져와야 함)
  String _getDummyDescription() {
    return '''상포로 3대 스시 맛집 '토리토' - 북해도 살았던 친한 동생이 추천해준 개당 1200원대의 가성비 초밥 맛집에 들어가 오늘 먹었는데 인상의 내던 비빔 가격이 정말 직인 가성비가 강점입니다. 밥 양을 취향대로 조절할 수 있고, 추천 메뉴는 마구로, 오징어, 호타데, 아마에비, 구운 참치. 인기 메뉴이라 대기가 있을 수 있으며, 간장에 와사비를 풀기보다 회 위에 살짝 얹어 먹는 방식이 좋 아릅니다.''';
  }
}
