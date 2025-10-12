import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../shared/widgets/common/common_app_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

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
                color: Colors.grey[700],
              ),
              onPressed: () {
                debugPrint('마이페이지 설정 버튼 클릭');
                // TODO: 설정 화면으로 이동
              },
              tooltip: AppStrings.of(context).settings,
            ),
          ),
          // 알림 아이콘은 showNotificationIcon으로 처리됨
          SizedBox(width: 8.w), // Material Design 가이드라인에 따른 오른쪽 마진
        ],
      ),
      body: ListView(
        children: [
          // 언어 선택 섹션
          _buildLanguageSection(context, ref, l10n, currentLocale),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 섹션 헤더
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
          child: Text(
            l10n.languageSelection,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),

        // 현재 언어 표시
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Text(
            '${l10n.currentLanguage}: ${_getLanguageName(l10n, currentLocale)}',
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
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
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      title: Text(
        languageName,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Icons.check_circle,
              color: Theme.of(context).primaryColor,
              size: 24.w,
            )
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
                style: TextStyle(fontFamily: 'Pretendard', fontSize: 14.sp),
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
}
