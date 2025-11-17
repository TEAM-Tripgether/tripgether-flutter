/// 플랫폼별 아이콘 경로 매핑 유틸리티
///
/// SNS 플랫폼에 따라 적절한 아이콘 경로를 반환합니다.
class PlatformIconMapper {
  PlatformIconMapper._(); // Private constructor to prevent instantiation

  /// 플랫폼 이름에 따른 아이콘 경로 반환
  ///
  /// 지원되는 플랫폼:
  /// - INSTAGRAM
  /// - YOUTUBE
  /// - TIKTOK (추후 지원 예정)
  ///
  /// 지원되지 않는 플랫폼의 경우 기본 아이콘을 반환합니다.
  static String getIconPath(String platform) {
    switch (platform.toUpperCase()) {
      case 'INSTAGRAM':
        return 'assets/platform_icons/instagram.svg';
      case 'YOUTUBE':
        return 'assets/platform_icons/youtube.svg';
      // case 'TIKTOK':
      //   return 'assets/platform_icons/tiktok.svg';
      default:
        return 'assets/platform_icons/default.svg';
    }
  }

  /// 플랫폼 이름 표시용 레이블 반환
  static String getPlatformLabel(String platform) {
    switch (platform.toUpperCase()) {
      case 'INSTAGRAM':
        return 'Instagram';
      case 'YOUTUBE':
        return 'YouTube';
      // case 'TIKTOK':
      //   return 'TikTok';
      default:
        return 'SNS';
    }
  }
}
