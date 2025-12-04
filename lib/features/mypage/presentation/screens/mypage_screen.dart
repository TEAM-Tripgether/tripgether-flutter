import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/features/mypage/presentation/widgets/profile_header.dart';
import 'package:tripgether/features/mypage/presentation/widgets/menu_section.dart';
import 'package:tripgether/features/mypage/presentation/widgets/menu_item.dart';
import 'package:tripgether/features/mypage/presentation/widgets/toggle_menu_item.dart';
import 'package:tripgether/shared/widgets/dialogs/common_dialog.dart';
import 'package:tripgether/shared/widgets/common/section_divider.dart';

/// 마이페이지 화면 (새 디자인)
///
/// **디자인 스펙**:
/// - 각 섹션 컨테이너: backgroundLight (#F8F8F8), radius 8
/// - 섹션 태그: subColor2 (#BBBBBB), titleSemiBold14
/// - 메뉴 텍스트: textColor1 (#130537), bodyMedium16
///
/// **섹션 구성**:
/// 1. 프로필 헤더 (터치 시 프로필 수정 화면 이동)
/// 2. 내 정보 섹션
/// 3. 알림 설정 섹션
/// 4. 고객지원 섹션
/// 5. 정책 & 안전 섹션
/// 6. 앱 버전 푸터
class MyPageScreen extends ConsumerStatefulWidget {
  const MyPageScreen({super.key});

  @override
  ConsumerState<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends ConsumerState<MyPageScreen> {
  // 알림 설정 상태 (추후 Provider로 이동 가능)
  bool _isPushNotificationEnabled = true;
  bool _isEmailNotificationEnabled = false;

  // 앱 버전 (pubspec.yaml에서 런타임에 로드)
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  /// pubspec.yaml에서 앱 버전 로드
  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _appVersion = packageInfo.version;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonAppBar(
        title: l10n.navMyPage,
        backgroundColor: AppColors.white,
        showMenuButton: false,
        showBackButton: false,
        showNotificationIcon: true,
        onNotificationPressed: () {
          debugPrint('마이페이지 알림 버튼 클릭');
          // TODO: 알림 목록 화면으로 이동
        },
      ),
      body: ListView(
        children: [
          AppSpacing.verticalSpaceLG,

          // ✅ 프로필 헤더 (터치 시 프로필 수정 화면 이동 → 로그아웃도 그 화면에서)
          const ProfileHeader(),

          AppSpacing.verticalSpaceLG,

          // ✅ 프로필과 메뉴 섹션 구분선 (높이 24)
          SectionDivider.thick(),

          AppSpacing.verticalSpaceXXL,

          // ✅ 내 정보 섹션
          _buildMyInfoSection(context, l10n),

          AppSpacing.verticalSpaceLG,

          // ✅ 알림 설정 섹션
          _buildNotificationSection(l10n),

          AppSpacing.verticalSpaceLG,

          // ✅ 고객지원 섹션
          _buildSupportSection(context, l10n),

          AppSpacing.verticalSpaceLG,

          // ✅ 정책 & 안전 섹션
          _buildPolicySection(context, l10n),

          AppSpacing.verticalSpaceLG,

          // ✅ 앱 버전 섹션
          _buildAppVersionSection(context),

          AppSpacing.verticalSpaceHuge,
        ],
      ),
    );
  }

  /// 내 정보 섹션
  Widget _buildMyInfoSection(BuildContext context, AppLocalizations l10n) {
    return MenuSection(
      tag: '내 정보',
      children: [
        MenuItem(
          title: '연결 계정 관리',
          onTap: () {
            debugPrint('연결 계정 관리 클릭');
            // TODO: 연결 계정 관리 화면으로 이동
          },
        ),
        MenuItem(
          title: '관심사 수정',
          onTap: () {
            debugPrint('관심사 수정 클릭');
            // TODO: 관심사 수정 화면으로 이동
          },
        ),
      ],
    );
  }

  /// 알림 설정 섹션
  Widget _buildNotificationSection(AppLocalizations l10n) {
    return MenuSection(
      tag: '알림 설정',
      children: [
        ToggleMenuItem(
          title: '푸시 알림',
          value: _isPushNotificationEnabled,
          onChanged: (value) {
            setState(() {
              _isPushNotificationEnabled = value;
            });
            debugPrint('푸시 알림: $value');
            // TODO: 푸시 알림 설정 저장
          },
        ),
        ToggleMenuItem(
          title: '이메일 알림',
          value: _isEmailNotificationEnabled,
          onChanged: (value) {
            setState(() {
              _isEmailNotificationEnabled = value;
            });
            debugPrint('이메일 알림: $value');
            // TODO: 이메일 알림 설정 저장
          },
        ),
      ],
    );
  }

  /// 고객지원 섹션
  Widget _buildSupportSection(BuildContext context, AppLocalizations l10n) {
    return MenuSection(
      tag: '고객지원',
      children: [
        MenuItem(
          title: '고객센터',
          onTap: () {
            debugPrint('고객센터 클릭');
            // TODO: 고객센터 화면 또는 외부 링크
          },
        ),
        MenuItem(
          title: '문의하기',
          onTap: () {
            debugPrint('문의하기 클릭');
            // TODO: 문의하기 화면
          },
        ),
        MenuItem(
          title: '공지사항',
          onTap: () {
            debugPrint('공지사항 클릭');
            // TODO: 공지사항 화면
          },
        ),
      ],
    );
  }

  /// 정책 & 안전 섹션
  Widget _buildPolicySection(BuildContext context, AppLocalizations l10n) {
    return MenuSection(
      tag: '정책 & 안전',
      children: [
        MenuItem(
          title: '이용약관',
          onTap: () {
            debugPrint('이용약관 클릭');
            // TODO: 이용약관 화면
          },
        ),
        MenuItem(
          title: '개인정보 처리방침',
          onTap: () {
            debugPrint('개인정보 처리방침 클릭');
            // TODO: 개인정보 처리방침 화면
          },
        ),
        MenuItem(
          title: '오픈소스 라이센스',
          onTap: () {
            debugPrint('오픈소스 라이센스 클릭');
            // 오픈소스 라이센스 화면 표시
            showLicensePage(
              context: context,
              applicationName: 'Tripgether',
              applicationVersion: _appVersion,
            );
          },
        ),
      ],
    );
  }

  /// 앱 버전 섹션 (섹션 태그 없이 단독 표시)
  Widget _buildAppVersionSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: InkWell(
        onTap: () => _showAppInfoDialog(context),
        borderRadius: BorderRadius.circular(8.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 앱 버전 라벨
            Text(
              '앱 버전',
              style: AppTextStyles.bodyMedium16.copyWith(
                color: AppColors.textColor1,
              ),
            ),
            // 버전 값
            Text(
              _appVersion.isEmpty ? '-' : _appVersion,
              style: AppTextStyles.bodyMedium16.copyWith(
                color: AppColors.subColor2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 앱 정보 다이얼로그 표시 (CommonDialog 사용)
  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CommonDialog.forError(
        title: 'Tripgether',
        description: '버전: ${_appVersion.isEmpty ? '-' : _appVersion}',
        subtitle: '© 2024 Tripgether. All rights reserved.',
        confirmText: '확인',
      ),
    );
  }
}
