import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/models/business_hour_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// 장소 상세 정보 섹션
///
/// - 주소 (location_on 아이콘 + 텍스트)
/// - 전화번호 (phone.svg 아이콘 + 텍스트, 탭 가능)
/// - 영업시간 (clock.svg 아이콘 + 확장 가능한 리스트)
/// - 별점 (star 아이콘 + 평점 + 리뷰 수)
///
/// 재사용 가능: PlaceDetailScreen, PlaceCard 등
class PlaceInfoSection extends StatefulWidget {
  /// 주소
  final String address;

  /// 전화번호 (선택 사항)
  final String? phone;

  /// 별점 (선택 사항)
  final double? rating;

  /// 리뷰 수 (선택 사항)
  final int? reviewCount;

  /// 영업시간 목록 (선택 사항)
  final List<BusinessHourModel> businessHours;

  /// 전화번호 탭 콜백 (선택 사항)
  final VoidCallback? onPhoneTap;

  /// 주소 탭 콜백 (선택 사항)
  final VoidCallback? onAddressTap;

  const PlaceInfoSection({
    super.key,
    required this.address,
    this.phone,
    this.rating,
    this.reviewCount,
    this.businessHours = const [],
    this.onPhoneTap,
    this.onAddressTap,
  });

  @override
  State<PlaceInfoSection> createState() => _PlaceInfoSectionState();
}

class _PlaceInfoSectionState extends State<PlaceInfoSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 주소
        _InfoRow(
          icon: SvgPicture.asset(
            'assets/icons/location_on.svg',
            width: AppSizes.iconSmall,
            height: AppSizes.iconSmall,
            colorFilter: ColorFilter.mode(
              AppColors.mainColor,
              BlendMode.srcIn,
            ),
          ),
          text: widget.address,
          onTap: widget.onAddressTap,
        ),

        // 전화번호
        if (widget.phone != null) ...[
          SizedBox(height: AppSpacing.sm),
          _InfoRow(
            icon: SvgPicture.asset(
              'assets/icons/phone.svg',
              width: AppSizes.iconSmall,
              height: AppSizes.iconSmall,
              colorFilter: ColorFilter.mode(
                AppColors.mainColor,
                BlendMode.srcIn,
              ),
            ),
            text: widget.phone!,
            onTap: widget.onPhoneTap,
          ),
        ],

        // 영업시간
        if (widget.businessHours.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          _BusinessHoursSection(businessHours: widget.businessHours),
        ],

        // 별점
        if (widget.rating != null) ...[
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/star.svg',
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
                colorFilter: ColorFilter.mode(
                  AppColors.mainColor,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                '${widget.rating} ${widget.reviewCount != null ? '(${widget.reviewCount})' : ''}',
                style: AppTextStyles.bodyMedium13.copyWith(
                  color: AppColors.textColor1.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// 정보 행 위젯 (아이콘 + 텍스트)
class _InfoRow extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium13.copyWith(
              color: AppColors.textColor1.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadius.allSmall,
        child: content,
      );
    }

    return content;
  }
}

/// 영업시간 확장 가능 섹션
class _BusinessHoursSection extends StatefulWidget {
  final List<BusinessHourModel> businessHours;

  const _BusinessHoursSection({required this.businessHours});

  @override
  State<_BusinessHoursSection> createState() => _BusinessHoursSectionState();
}

class _BusinessHoursSectionState extends State<_BusinessHoursSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isOpen = _isCurrentlyOpen(widget.businessHours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (탭 가능)
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          borderRadius: AppRadius.allSmall,
          child: Row(
            children: [
              // clock.svg 아이콘 (색상 포함된 상태로 표시)
              SvgPicture.asset(
                'assets/icons/clock.svg',
                width: AppSizes.iconSmall,
                height: AppSizes.iconSmall,
              ),
              SizedBox(width: AppSpacing.xs),
              // 영업 중/영업 종료 텍스트
              Text(
                isOpen ? '영업 중' : '영업 종료',
                style: AppTextStyles.titleSemiBold13.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
              const Spacer(),
              // 펼침/접힘 아이콘
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: AppSizes.iconSmall,
                color: AppColors.textColor1.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),

        // 펼쳐진 리스트
        if (_isExpanded) ...[
          SizedBox(height: AppSpacing.sm),
          ..._buildHoursList(widget.businessHours),
        ],
      ],
    );
  }

  /// 영업시간 리스트 생성
  List<Widget> _buildHoursList(List<BusinessHourModel> hours) {
    return hours.map((hour) {
      return Padding(
        padding: EdgeInsets.only(
          left: AppSizes.iconSmall + AppSpacing.xs,
          bottom: AppSpacing.xs,
        ),
        child: Row(
          children: [
            // 요일
            Text(
              hour.dayOfWeek.toKoreanDayOfWeek(),
              style: AppTextStyles.bodyMedium13.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.6),
              ),
            ),
            const Spacer(),
            // 영업시간
            Text(
              '${hour.openTime} - ${hour.closeTime}',
              style: AppTextStyles.bodyMedium13.copyWith(
                color: AppColors.textColor1.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// 현재 시간 기준 영업 중 여부 확인
  bool _isCurrentlyOpen(List<BusinessHourModel> hours) {
    if (hours.isEmpty) return false;

    final now = DateTime.now();
    final todayDayOfWeek = _getDayOfWeekEnum(now.weekday);

    // 오늘의 영업시간 찾기
    final todayHours = hours.where((h) => h.dayOfWeek == todayDayOfWeek);
    if (todayHours.isEmpty) return false;

    final todayHour = todayHours.first;

    // 현재 시간
    final currentMinutes = now.hour * 60 + now.minute;

    // 오픈/마감 시간 파싱
    final openParts = todayHour.openTime.split(':');
    final openMinutes =
        int.parse(openParts[0]) * 60 + int.parse(openParts[1]);

    final closeParts = todayHour.closeTime.split(':');
    final closeMinutes =
        int.parse(closeParts[0]) * 60 + int.parse(closeParts[1]);

    // 영업 중 여부 판단
    return currentMinutes >= openMinutes && currentMinutes <= closeMinutes;
  }

  /// DateTime.weekday(1-7) → DayOfWeek Enum (MONDAY-SUNDAY)
  String _getDayOfWeekEnum(int weekday) {
    const map = {
      1: 'MONDAY',
      2: 'TUESDAY',
      3: 'WEDNESDAY',
      4: 'THURSDAY',
      5: 'FRIDAY',
      6: 'SATURDAY',
      7: 'SUNDAY',
    };
    return map[weekday] ?? 'MONDAY';
  }
}
