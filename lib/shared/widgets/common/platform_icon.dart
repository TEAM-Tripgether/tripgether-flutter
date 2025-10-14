import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../features/home/data/models/sns_content_model.dart';

/// 플랫폼별 아이콘을 표시하는 공통 위젯
///
/// YouTube, Instagram, TikTok 등 다양한 SNS 플랫폼의 아이콘을 통일된 방식으로 표시합니다.
/// SVG 파일을 사용하여 고품질 아이콘을 제공하며, 새로운 플랫폼 추가 시 이 파일만 수정하면 됩니다.
class PlatformIcon extends StatelessWidget {
  /// 표시할 플랫폼 종류
  final SnsSource source;

  /// 아이콘 크기 (기본값: 24.w)
  final double? size;

  /// 배경 표시 여부 (기본값: false, 아이콘만 표시)
  final bool showBackground;

  /// 배경 패딩 (showBackground가 true일 때만 적용)
  final double? backgroundPadding;

  const PlatformIcon({
    super.key,
    required this.source,
    this.size,
    this.showBackground = false,
    this.backgroundPadding,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppSizes.iconDefault;

    // 접근성: 스크린 리더를 위한 플랫폼 라벨
    final semanticsLabel = _getPlatformLabel();

    // 배경이 있는 경우
    if (showBackground) {
      return Semantics(
        label: semanticsLabel,
        child: Container(
          padding: EdgeInsets.all(backgroundPadding ?? AppSpacing.xs),
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: AppRadius.allMedium,
          ),
          child: _buildIcon(iconSize, color: _overrideIconColorForBackground()),
        ),
      );
    }

    // 아이콘만 표시
    return Semantics(label: semanticsLabel, child: _buildIcon(iconSize));
  }

  /// 플랫폼별 아이콘 위젯 생성
  ///
  /// [iconSize] 아이콘의 크기
  /// [color] 아이콘 색상 오버라이드 (null이면 기본 색상 사용)
  Widget _buildIcon(double iconSize, {Color? color}) {
    final assetPath = _getAssetPath();

    // SVG 파일이 있으면 SVG 사용
    if (assetPath != null) {
      return SvgPicture.asset(
        assetPath,
        width: iconSize,
        height: iconSize,
        // color가 제공될 때만 단색 오버레이 적용
        // Instagram 같은 그라데이션 아이콘은 null로 전달하여 원본 색상 유지
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
      );
    }

    // SVG가 없으면 Material 아이콘 사용 (폴백)
    return Icon(
      _getFallbackIcon(),
      size: iconSize,
      color: color ?? _getIconColor(),
    );
  }

  /// 플랫폼별 SVG 파일 경로 반환
  String? _getAssetPath() {
    switch (source) {
      case SnsSource.youtube:
        return 'assets/platform_icons/youtube.svg';
      case SnsSource.instagram:
        return 'assets/platform_icons/instagram.svg';
      case SnsSource.tiktok:
        return null; // TikTok SVG 파일이 없으면 null 반환
    }
  }

  /// 플랫폼별 폴백 Material 아이콘 반환
  IconData _getFallbackIcon() {
    switch (source) {
      case SnsSource.youtube:
        return Icons.play_circle_filled;
      case SnsSource.instagram:
        return Icons.camera_alt;
      case SnsSource.tiktok:
        return Icons.music_note;
    }
  }

  /// 플랫폼별 아이콘 색상 반환 (배경이 없을 때)
  Color _getIconColor() {
    switch (source) {
      case SnsSource.youtube:
        return Colors.red;
      case SnsSource.instagram:
        return Colors.purple;
      case SnsSource.tiktok:
        return Colors.black;
    }
  }

  /// 플랫폼별 배경 색상 반환 (배경이 있을 때)
  Color _getBackgroundColor() {
    switch (source) {
      case SnsSource.youtube:
        return Colors.red;
      case SnsSource.instagram:
        return Colors.purple;
      case SnsSource.tiktok:
        return Colors.black;
    }
  }

  /// 배경 상황에서의 아이콘 색상 오버라이드
  ///
  /// showBackground=true일 때 배경색과 아이콘 색이 동일하면 대비가 부족하므로
  /// 흰색으로 강제 변경하여 명확한 시각적 대비 제공
  ///
  /// Instagram은 그라데이션 특성상 null 반환하여 원본 색상 유지
  Color? _overrideIconColorForBackground() {
    if (!showBackground) return null;

    switch (source) {
      case SnsSource.youtube:
      case SnsSource.tiktok:
        // YouTube(빨강 배경), TikTok(검정 배경)은 흰색 아이콘으로 대비 확보
        return Colors.white;
      case SnsSource.instagram:
        // Instagram은 그라데이션 SVG 원본 색상 유지
        return null;
    }
  }

  /// 접근성을 위한 플랫폼 라벨 반환
  ///
  /// 스크린 리더가 아이콘을 읽을 수 있도록 각 플랫폼 이름 제공
  String _getPlatformLabel() {
    switch (source) {
      case SnsSource.youtube:
        return 'YouTube 아이콘';
      case SnsSource.instagram:
        return 'Instagram 아이콘';
      case SnsSource.tiktok:
        return 'TikTok 아이콘';
    }
  }
}
