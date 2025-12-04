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

  /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
  final String? businessStatus;

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
    this.businessStatus,
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
            colorFilter: ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn),
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

        // 영업 상태 및 영업시간
        if (widget.businessStatus != null ||
            widget.businessHours.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          _BusinessHoursSection(
            businessHours: widget.businessHours,
            businessStatus: widget.businessStatus,
          ),
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

  const _InfoRow({required this.icon, required this.text, this.onTap});

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

  /// 영업 상태 (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY)
  final String? businessStatus;

  const _BusinessHoursSection({
    required this.businessHours,
    this.businessStatus,
  });

  @override
  State<_BusinessHoursSection> createState() => _BusinessHoursSectionState();
}

class _BusinessHoursSectionState extends State<_BusinessHoursSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // businessStatus 우선 처리 (폐업/임시휴업 상태)
    final statusInfo = _getBusinessStatusInfo();

    // 폐업인 경우 영업시간 표시 안함
    if (statusInfo.isPermanentlyClosed) {
      return _buildStatusOnlyRow(statusInfo);
    }

    // 영업시간이 없고 특별한 상태도 없는 경우
    if (widget.businessHours.isEmpty && statusInfo.label == null) {
      return const SizedBox.shrink();
    }

    final isOpen = _isCurrentlyOpen(widget.businessHours);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더 (탭 가능)
        InkWell(
          onTap: widget.businessHours.isNotEmpty
              ? () => setState(() => _isExpanded = !_isExpanded)
              : null,
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
              // 영업 상태 텍스트
              _buildStatusText(isOpen, statusInfo),
              const Spacer(),
              // 펼침/접힘 아이콘 (영업시간이 있는 경우만)
              if (widget.businessHours.isNotEmpty)
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: AppSizes.iconSmall,
                  color: AppColors.textColor1.withValues(alpha: 0.6),
                ),
            ],
          ),
        ),

        // 펼쳐진 리스트
        if (_isExpanded && widget.businessHours.isNotEmpty) ...[
          SizedBox(height: AppSpacing.sm),
          ..._buildHoursList(widget.businessHours),
        ],
      ],
    );
  }

  /// 영업 상태 정보 가져오기
  _BusinessStatusInfo _getBusinessStatusInfo() {
    final status = widget.businessStatus;

    if (status == 'CLOSED_PERMANENTLY') {
      return _BusinessStatusInfo(
        label: '폐업',
        color: AppColors.error,
        isPermanentlyClosed: true,
      );
    } else if (status == 'CLOSED_TEMPORARILY') {
      return _BusinessStatusInfo(
        label: '임시 휴업',
        color: AppColors.warning,
        isPermanentlyClosed: false,
      );
    }

    // OPERATIONAL인 경우 "영업 중" 표시
    if (status == 'OPERATIONAL') {
      return _BusinessStatusInfo(
        label: '영업 중',
        color: AppColors.mainColor,
        isPermanentlyClosed: false,
      );
    }

    // null인 경우 (상태 정보 없음)
    return _BusinessStatusInfo(
      label: null,
      color: AppColors.mainColor,
      isPermanentlyClosed: false,
    );
  }

  /// 상태만 표시하는 행 (폐업인 경우)
  Widget _buildStatusOnlyRow(_BusinessStatusInfo statusInfo) {
    return Row(
      children: [
        Icon(
          Icons.cancel_outlined,
          size: AppSizes.iconSmall,
          color: statusInfo.color,
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          statusInfo.label ?? '',
          style: AppTextStyles.titleSemiBold13.copyWith(
            color: statusInfo.color,
          ),
        ),
      ],
    );
  }

  /// 상태 텍스트 위젯 생성
  Widget _buildStatusText(bool isOpen, _BusinessStatusInfo statusInfo) {
    // 임시 휴업 상태인 경우
    if (statusInfo.label == '임시 휴업') {
      return Text(
        '임시 휴업',
        style: AppTextStyles.titleSemiBold13.copyWith(color: statusInfo.color),
      );
    }

    // OPERATIONAL 상태이고 영업시간이 없는 경우 → label 그대로 표시
    if (statusInfo.label == '영업 중' && widget.businessHours.isEmpty) {
      return Text(
        statusInfo.label!,
        style: AppTextStyles.titleSemiBold13.copyWith(color: statusInfo.color),
      );
    }

    // 영업시간이 있는 경우 → 현재 시간 기준으로 표시
    return Text(
      isOpen ? '영업 중' : '영업 종료',
      style: AppTextStyles.titleSemiBold13.copyWith(
        color: isOpen
            ? AppColors.mainColor
            : AppColors.textColor1.withValues(alpha: 0.6),
      ),
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
    final openMinutes = int.parse(openParts[0]) * 60 + int.parse(openParts[1]);

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

/// 영업 상태 정보를 담는 내부 클래스
class _BusinessStatusInfo {
  /// 표시할 라벨 (null이면 기본 영업 상태 표시)
  final String? label;

  /// 텍스트 색상
  final Color color;

  /// 폐업 여부 (true면 영업시간 표시 안함)
  final bool isPermanentlyClosed;

  const _BusinessStatusInfo({
    required this.label,
    required this.color,
    required this.isPermanentlyClosed,
  });
}
