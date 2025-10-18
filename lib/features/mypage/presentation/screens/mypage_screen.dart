import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';
import 'package:tripgether/core/constants/app_strings.dart';
import 'package:tripgether/core/providers/locale_provider.dart';
import 'package:tripgether/core/router/routes.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/l10n/app_localizations.dart';
import 'package:tripgether/features/mypage/presentation/widgets/profile_header.dart';
import 'package:tripgether/features/auth/providers/login_provider.dart';
import 'package:tripgether/features/auth/providers/user_provider.dart';

/// 마이페이지 화면
///
/// 사용자의 개인 정보와 설정을 관리할 수 있는 화면입니다.
/// 개인 계정 중심의 화면으로 설정 버튼을 강조하여 배치했습니다.
class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeNotifierProvider);
    return Scaffold(
      // 마이페이지에 최적화된 AppBar
      // 개인 계정 관리 중심으로 설정 기능을 강조
      appBar: CommonAppBar(
        title: AppStrings.of(context).navMyPage,
        showMenuButton: false, // 마이페이지에서는 메뉴 버튼 제거 (개인 공간)
        showNotificationIcon: true, // 개인 알림 확인을 위해 알림 아이콘 유지
        onNotificationPressed: () {
          debugPrint('마이페이지 알림 버튼 클릭');
          // TODO: 개인 알림 목록 화면으로 이동
        },
        rightActions: [
          // 설정 버튼 - 마이페이지의 핵심 기능
          Semantics(
            label: '설정 버튼',
            button: true,
            child: IconButton(
              icon: Icon(
                Icons.settings_outlined,
                size: 24.w,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                debugPrint('마이페이지 설정 버튼 클릭');
                // TODO: 설정 화면으로 이동
              },
              tooltip: AppStrings.of(context).settings,
            ),
          ),
          // 알림 아이콘은 showNotificationIcon으로 처리됨
          AppSpacing.horizontalSpaceSM, // Material Design 가이드라인에 따른 오른쪽 마진
        ],
      ),
      body: ListView(
        children: [
          // ✅ 프로필 헤더 (최상단)
          const ProfileHeader(),

          AppSpacing.verticalSpaceLG,

          // 언어 선택 섹션
          _buildLanguageSection(context, ref, l10n, currentLocale),

          AppSpacing.verticalSpaceXXL,

          // 로그아웃 버튼 섹션
          _buildLogoutSection(context, ref),

          // 하단 여백
          AppSpacing.verticalSpaceHuge,
        ],
      ),
    );
  }

  /// 언어 선택 섹션 빌드
  Widget _buildLanguageSection(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    Locale? currentLocale,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: AppSpacing.only(left: 16, top: 24, right: 16, bottom: 12),
          child: Text(
            l10n.languageSelection,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),

        // 현재 언어 표시
        Padding(
          padding: AppSpacing.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${l10n.currentLanguage}: ${_getLanguageName(l10n, currentLocale)}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),

        // 언어 선택 옵션들
        _buildLanguageOption(
          context,
          ref,
          l10n,
          l10n.korean,
          const Locale('ko'),
          currentLocale?.languageCode == 'ko',
        ),
        _buildLanguageOption(
          context,
          ref,
          l10n,
          l10n.english,
          const Locale('en'),
          currentLocale?.languageCode == 'en',
        ),
        _buildLanguageOption(
          context,
          ref,
          l10n,
          '${l10n.settings} (System)', // 시스템 언어
          null,
          currentLocale == null,
        ),
      ],
    );
  }

  /// 개별 언어 선택 옵션 빌드
  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String languageName,
    Locale? locale,
    bool isSelected,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      title: Text(
        languageName,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? primaryColor : colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: primaryColor, size: 24.w)
          : null,
      onTap: () async {
        // 언어 변경
        await ref.read(localeNotifierProvider.notifier).setLocale(locale);

        // 스낵바로 알림
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${l10n.language}: $languageName',
                style: textTheme.bodyMedium,
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  /// 현재 언어 이름 가져오기
  String _getLanguageName(AppLocalizations l10n, Locale? locale) {
    if (locale == null) {
      return '${l10n.settings} (System)';
    }
    switch (locale.languageCode) {
      case 'ko':
        return l10n.korean;
      case 'en':
        return l10n.english;
      default:
        return locale.languageCode;
    }
  }

  /// 로그아웃 버튼 섹션
  ///
  /// **기능**:
  /// - 로그인 상태일 때만 표시
  /// - 로그아웃 버튼 클릭 시:
  ///   1. LoginProvider.logout() 호출
  ///   2. UserNotifier 상태 초기화
  ///   3. Secure Storage 정리
  ///   4. 로그인 화면으로 이동
  Widget _buildLogoutSection(BuildContext context, WidgetRef ref) {
    // 로그인 상태 확인
    final userAsync = ref.watch(userNotifierProvider);

    // 로그인하지 않은 상태면 버튼 숨김
    return userAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
      data: (user) {
        if (user == null) {
          return const SizedBox.shrink();
        }

        // 로그인된 상태: 로그아웃 버튼 표시
        final textTheme = Theme.of(context).textTheme;
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 구분선
              Divider(
                height: 1.h,
                thickness: 1.w,
                color: colorScheme.outlineVariant,
              ),

              AppSpacing.verticalSpaceXXL,

              // 로그아웃 버튼
              OutlinedButton.icon(
                onPressed: () => _handleLogout(context, ref),
                icon: Icon(Icons.logout, size: 20.w, color: colorScheme.error),
                label: Text(
                  AppLocalizations.of(context).logout,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  side: BorderSide(
                    color: colorScheme.error.withValues(alpha: 0.5),
                    width: 1.5.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),

              SizedBox(height: 8.h),

              // 안내 문구
              Text(
                AppLocalizations.of(context).logoutHint,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  /// 로그아웃 처리
  ///
  /// **동작**:
  /// 1. 사용자에게 확인 다이얼로그 표시
  /// 2. 확인 시 LoginProvider.logout() 호출
  /// 3. 로그인 화면으로 이동
  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // 로그아웃 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.logoutConfirmTitle,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(l10n.logoutConfirmMessage, style: textTheme.bodyMedium),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.btnCancel,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // 로그아웃 버튼
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.logout,
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    // 사용자가 취소를 선택한 경우
    if (confirmed != true || !context.mounted) {
      return;
    }

    try {
      // 로그아웃 실행
      await ref.read(loginNotifierProvider.notifier).logout();

      if (!context.mounted) return;

      final l10nAfter = AppLocalizations.of(context);
      final textThemeAfter = Theme.of(context).textTheme;

      // 성공 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10nAfter.logoutSuccess,
            textAlign: TextAlign.center,
            style: textThemeAfter.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // 로그인 화면으로 이동
      context.go(AppRoutes.login);
    } catch (e) {
      if (!context.mounted) return;

      final l10nError = AppLocalizations.of(context);
      final textThemeError = Theme.of(context).textTheme;
      final colorSchemeError = Theme.of(context).colorScheme;

      // 에러 발생 시 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10nError.logoutFailed(e.toString()),
            style: textThemeError.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: colorSchemeError.error,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
