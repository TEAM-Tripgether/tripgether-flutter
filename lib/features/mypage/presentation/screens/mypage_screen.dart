import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tripgether/shared/widgets/common/common_app_bar.dart';
import 'package:tripgether/shared/widgets/common/app_snackbar.dart';
import 'package:tripgether/shared/widgets/dialogs/common_dialog.dart';
import 'package:tripgether/core/providers/locale_provider.dart';
import 'package:tripgether/core/router/routes.dart';
import 'package:tripgether/core/theme/app_colors.dart';
import 'package:tripgether/core/theme/app_spacing.dart';
import 'package:tripgether/core/theme/app_text_styles.dart';
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
      /// 화이트 배경 (일관성: AppBar와 동일)
      backgroundColor: AppColors.white,
      // 마이페이지에 최적화된 AppBar
      // 개인 계정 관리 중심으로 설정 기능을 강조
      appBar: CommonAppBar(
        title: l10n.navMyPage,
        backgroundColor: AppColors.white, // 다른 페이지와 동일한 흰색 배경
        showMenuButton: false, // 마이페이지에서는 메뉴 버튼 제거 (개인 공간)
        showBackButton: false, // 뒤로가기 버튼도 제거 (바텀 네비게이션으로 이동)
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  debugPrint('마이페이지 설정 버튼 클릭');
                  // TODO: 설정 화면으로 이동
                },
                borderRadius: BorderRadius.circular(AppSizes.iconXLarge / 2),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.xs),
                  child: SvgPicture.asset(
                    'assets/icons/setting.svg',
                    width: AppSizes.iconXLarge,
                    height: AppSizes.iconXLarge,
                  ),
                ),
              ),
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

          // 🧪 테스트 섹션: 온보딩 화면 이동 버튼
          _buildTestSection(context),

          AppSpacing.verticalSpaceXL,

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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: AppSpacing.only(left: 16, top: 24, right: 16, bottom: 12),
          child: Text(
            l10n.languageSelection,
            style: AppTextStyles.titleSemiBold16,
          ),
        ),

        // 현재 언어 표시
        Padding(
          padding: AppSpacing.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            '${l10n.currentLanguage}: ${_getLanguageName(l10n, currentLocale)}',
            style: AppTextStyles.bodyRegular14.copyWith(
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
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ListTile(
      contentPadding: AppSpacing.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        languageName,
        style: isSelected
            ? AppTextStyles.bodyMedium16.copyWith(color: primaryColor)
            : AppTextStyles.bodyRegular14.copyWith(
                color: colorScheme.onSurface,
              ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: primaryColor,
              size: AppSizes.iconDefault,
            )
          : null,
      onTap: () async {
        // 언어 변경
        await ref.read(localeNotifierProvider.notifier).setLocale(locale);

        // 스낵바로 알림
        if (context.mounted) {
          AppSnackBar.showInfo(
            context,
            '${l10n.language}: $languageName',
            duration: const Duration(seconds: 2),
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

  /// 🧪 테스트 섹션: 온보딩 화면 및 다이얼로그 테스트용 버튼
  ///
  /// **목적**: 개발/테스트 중 온보딩 화면 및 CommonDialog를 쉽게 테스트할 수 있도록 함
  /// **주의**: 프로덕션 배포 전에 제거 필요
  Widget _buildTestSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: AppSpacing.symmetric(horizontal: 16),
      padding: AppSpacing.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.5),
          width: AppSizes.borderThin,
        ),
        borderRadius: AppRadius.allLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 섹션 제목
          Row(
            children: [
              Icon(
                Icons.science_outlined,
                size: AppSizes.iconMedium,
                color: colorScheme.secondary,
              ),
              AppSpacing.horizontalSpaceSM,
              Text(
                '🧪 테스트 모드',
                style: AppTextStyles.titleSemiBold14.copyWith(
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),

          AppSpacing.verticalSpaceMD,

          // 온보딩 화면 이동 버튼
          ElevatedButton.icon(
            onPressed: () {
              context.push(AppRoutes.onboarding);
            },
            icon: Icon(Icons.assignment_outlined, size: AppSizes.iconMedium),
            label: Text('온보딩 화면 테스트', style: AppTextStyles.titleSemiBold14),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
            ),
          ),

          AppSpacing.verticalSpaceMD,

          // CommonDialog 테스트 제목
          Text(
            'CommonDialog 테스트',
            style: AppTextStyles.titleSemiBold14.copyWith(
              color: colorScheme.secondary,
            ),
          ),

          AppSpacing.verticalSpaceSM,

          // 삭제 확인 다이얼로그 테스트
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CommonDialog.forDelete(
                  title: '장소를 삭제하시겠습니까?',
                  description: '삭제된 장소는 복구할 수 없습니다.',
                  subtitle: '연관된 코스도 함께 삭제됩니다.',
                  onConfirm: () {
                    debugPrint('삭제 확인됨');
                  },
                ),
              );
            },
            icon: Icon(Icons.delete_outline, size: AppSizes.iconMedium),
            label: Text('삭제 확인 다이얼로그', style: AppTextStyles.titleSemiBold14),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.errorContainer,
              foregroundColor: colorScheme.onErrorContainer,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
            ),
          ),

          AppSpacing.verticalSpaceSM,

          // 오류 다이얼로그 테스트
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CommonDialog.forError(
                  title: '오류가 발생했습니다',
                  description: '네트워크 연결을 확인해주세요.',
                  subtitle: '오류 코드: 500',
                ),
              );
            },
            icon: Icon(Icons.error_outline, size: AppSizes.iconMedium),
            label: Text('오류 다이얼로그', style: AppTextStyles.titleSemiBold14),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
            ),
          ),

          AppSpacing.verticalSpaceSM,

          // 일반 확인 다이얼로그 테스트
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CommonDialog.forConfirm(
                  title: '변경사항을 저장하시겠습니까?',
                  description: '저장하지 않으면 변경사항이 사라집니다.',
                  onConfirm: () {
                    debugPrint('저장 확인됨');
                  },
                ),
              );
            },
            icon: Icon(Icons.help_outline, size: AppSizes.iconMedium),
            label: Text('일반 확인 다이얼로그', style: AppTextStyles.titleSemiBold14),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
            ),
          ),

          SizedBox(height: 8.h),

          // 성공 알림 다이얼로그 테스트
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CommonDialog.forSuccess(
                  title: '저장 완료',
                  description: '변경사항이 성공적으로 저장되었습니다.',
                ),
              );
            },
            icon: Icon(Icons.check_circle_outline, size: AppSizes.iconMedium),
            label: Text('성공 알림 다이얼로그', style: AppTextStyles.titleSemiBold14),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.tertiaryContainer,
              foregroundColor: colorScheme.onTertiaryContainer,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: AppRadius.allMedium),
            ),
          ),

          AppSpacing.verticalSpaceSM,

          // 안내 문구
          Text(
            '※ 개발/테스트 전용 기능입니다',
            style: AppTextStyles.metaMedium12.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
        final colorScheme = Theme.of(context).colorScheme;

        return Container(
          margin: AppSpacing.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 구분선
              Divider(
                height: 1.h,
                thickness: AppSizes.dividerThin,
                color: colorScheme.outlineVariant,
              ),

              AppSpacing.verticalSpaceXXL,

              // 로그아웃 버튼
              OutlinedButton.icon(
                onPressed: () => _handleLogout(context, ref),
                icon: Icon(
                  Icons.logout,
                  size: AppSizes.iconMedium,
                  color: colorScheme.error,
                ),
                label: Text(
                  AppLocalizations.of(context).logout,
                  style: AppTextStyles.bodyMedium16.copyWith(
                    color: colorScheme.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: AppSpacing.symmetric(vertical: 14),
                  side: BorderSide(
                    color: colorScheme.error.withValues(alpha: 0.5),
                    width: 1.5.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.allMedium,
                  ),
                ),
              ),

              AppSpacing.verticalSpaceSM,

              // 안내 문구
              Text(
                AppLocalizations.of(context).logoutHint,
                style: AppTextStyles.metaMedium12.copyWith(
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
    final colorScheme = Theme.of(context).colorScheme;

    // 로그아웃 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          l10n.logoutConfirmTitle,
          style: AppTextStyles.titleSemiBold16,
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: AppTextStyles.bodyRegular14,
        ),
        actions: [
          // 취소 버튼
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.btnCancel,
              style: AppTextStyles.buttonSelectSemiBold16.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // 로그아웃 버튼
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.logout,
              style: AppTextStyles.buttonSelectSemiBold16.copyWith(
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

      // 성공 스낵바 표시
      AppSnackBar.showSuccess(
        context,
        l10nAfter.logoutSuccess,
        duration: const Duration(seconds: 2),
      );

      // 로그인 화면으로 이동
      context.go(AppRoutes.login);
    } catch (e) {
      if (!context.mounted) return;

      final l10nError = AppLocalizations.of(context);

      // 에러 발생 시 스낵바 표시
      AppSnackBar.showError(
        context,
        l10nError.logoutFailed(e.toString()),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
